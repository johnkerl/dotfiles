#!/usr/bin/env python3
"""Build a GitHub pending-review payload from a Markdown review draft.

Usage: python3 -I build-review.py <draft.md> <head-sha> <out.json>

Draft format:

  ## Review body
  <text>

  ## Inline comments

  ### <path>, line <N> [<tag>]
  <comment text>

  ## Conversation comment [follow-up]     (optional)
  <text, appended to the review body>

The payload has no "event" key. That is what makes GitHub keep the review
PENDING, so this script must never add one.

Exits non-zero, writing nothing, if the draft is malformed: a missing body,
no comments, an inline heading that does not parse, or a duplicate anchor.
Standard library only.
"""
import json
import pathlib
import re
import sys


def fail(msg):
    print(f"build-review: {msg}", file=sys.stderr)
    sys.exit(1)


def section(draft, start_pat, end_pat=None, required=True):
    m = re.search(start_pat, draft, re.M)
    if not m:
        if required:
            fail(f"missing section matching {start_pat!r}")
        return ""
    rest = draft[m.end():]
    if end_pat:
        e = re.search(end_pat, rest, re.M)
        if e:
            rest = rest[: e.start()]
    return rest.strip()


def main():
    if len(sys.argv) != 4:
        fail("usage: build-review.py <draft.md> <head-sha> <out.json>")
    draft_path, commit, out_path = sys.argv[1:]
    if not re.fullmatch(r"[0-9a-f]{40}", commit):
        fail("head-sha must be the full 40-character commit SHA")
    try:
        draft = pathlib.Path(draft_path).expanduser().read_text()
    except OSError as e:
        fail(f"cannot read the draft: {e}")

    body = section(draft, r"^## Review body\n", r"^## ")
    if not body:
        fail("the review body is empty")
    followup = section(
        draft, r"^## Conversation comment[^\n]*\n", None, required=False
    )
    if followup:
        body += "\n\nFollow-up, not for this PR:\n\n" + followup

    inline = section(draft, r"^## Inline comments\n", r"^## (?!#)")
    headings = re.findall(r"^### .*$", inline, re.M)
    comments = []
    seen = set()
    pattern = re.compile(
        r"^### (\S+), line (\d+) \[(\w[\w-]*)\]\n(.*?)(?=^### |\Z)", re.M | re.S
    )
    for m in pattern.finditer(inline):
        path, line, tag, text = m.group(1), int(m.group(2)), m.group(3), m.group(4).strip()
        if not text:
            fail(f"empty comment at {path}:{line}")
        if (path, line, tag) in seen:
            fail(f"duplicate comment at {path}:{line} [{tag}]")
        seen.add((path, line, tag))
        comments.append({"path": path, "line": line, "side": "RIGHT", "body": f"[{tag}] {text}"})
    if len(comments) != len(headings):
        fail(
            f"{len(headings)} '###' headings but only {len(comments)} parsed; "
            "each must look like '### <path>, line <N> [<tag>]'"
        )
    if not comments:
        fail("no inline comments found")

    payload = {"commit_id": commit, "body": body, "comments": comments}
    assert "event" not in payload  # keeps the review pending
    pathlib.Path(out_path).write_text(json.dumps(payload))
    print(f"body: {len(body)} chars; inline comments: {len(comments)}")
    for c in comments:
        print(f"  {c['path']}:{c['line']}  {c['body'][:70]!r}")


if __name__ == "__main__":
    main()
