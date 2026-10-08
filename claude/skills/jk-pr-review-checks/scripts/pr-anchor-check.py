#!/usr/bin/env python3
"""Check whether review-comment anchors (FILE:LINE) fall inside a pull request's diff.

Why: a review comment can be placed on a line the PR did not change, but that usually means the
finding is about older code, so it may be wrong about the PR's responsibility, under-informed, or
unwelcome. This tells you, per anchor, whether the line is changed, context, or outside the diff,
and (with --provenance) whether the line was introduced by the PR or was already there.

Usage (run with `python3 -I pr-anchor-check.py ...`; standard library only):

  # Exactly what GitHub shows (needs the gh CLI and a repo checkout of the PR's repository):
  pr-anchor-check.py --pr 1920 pkg/foo/bar.go:102 pkg/foo/baz.go:7

  # From local refs; use the PR's own base branch (for stacked PRs that is not main):
  pr-anchor-check.py --base origin/main --head origin/feature pkg/foo/bar.go:102

  # Anchors taken from a draft whose comment headings look like
  #   ### 3. pkg/foo/bar.go, line 289
  #   ### 5. pkg/foo/baz.go, lines 16 and 30
  pr-anchor-check.py --pr 1920 --from-draft ~/Desktop/pr-1920-review-draft.md

  # Also say whether each line was introduced by the PR (local refs only):
  pr-anchor-check.py --base origin/main --head origin/feature --provenance FILE:LINE

Exit status: 0 if every anchor is on a changed or context line of the diff; 1 if any is outside it
or in a file the diff does not touch; 2 on usage errors.
"""
import argparse
import json
import re
import subprocess
import sys

HUNK = re.compile(r"^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@")


def run(*cmd, check=True):
    p = subprocess.run(cmd, capture_output=True, text=True)
    if check and p.returncode != 0:
        sys.exit(f"command failed: {' '.join(cmd)}\n{p.stderr.strip()}")
    return p.stdout


def parse_diff(text):
    """Return {path: {"hunks": [(start, end)], "changed": set(lines), "context": set(lines)}}.

    Lines are new-file (right side) line numbers, which is what an inline comment refers to.
    """
    files, cur, new = {}, None, None
    for line in text.split("\n"):
        if line.startswith("+++ "):
            path = line[4:]
            if path == "/dev/null":
                cur = None
                continue
            path = path[2:] if path.startswith("b/") else path
            cur = files.setdefault(path, {"hunks": [], "changed": set(), "context": set()})
            new = None
            continue
        if cur is None:
            continue
        m = HUNK.match(line)
        if m:
            start, n = int(m.group(1)), int(m.group(2) if m.group(2) is not None else 1)
            if n:
                cur["hunks"].append((start, start + n - 1))
            new = start
            continue
        if new is None:
            continue
        if line.startswith("+") and not line.startswith("+++"):
            cur["changed"].add(new)
            new += 1
        elif line.startswith("-") and not line.startswith("---"):
            pass  # exists only on the old side
        elif line.startswith("\\"):
            pass  # "\ No newline at end of file"
        else:
            cur["context"].add(new)
            new += 1
    return files


def classify(files, path, line):
    f = files.get(path)
    if f is None:
        return "FILE-NOT-IN-DIFF", None
    if line in f["changed"]:
        return "CHANGED", None
    if line in f["context"]:
        return "CONTEXT", None
    near = min(f["changed"], key=lambda x: abs(x - line)) if f["changed"] else None
    return "OUTSIDE-DIFF", near


def anchors_from_draft(path):
    out = []
    pat = re.compile(r"([\w./-]+\.\w+),\s*(?:around\s+)?lines?\s+(\d+)(?:\s*(?:and|,)\s*(\d+))?")
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            if not line.startswith("###"):
                continue
            for m in pat.finditer(line):
                out.append((m.group(1), int(m.group(2))))
                if m.group(3):
                    out.append((m.group(1), int(m.group(3))))
    return out


def permalink(repo_url, sha, path, line):
    return f"{repo_url}/blob/{sha}/{path}#L{line}"


def provenance(base, head, path, line):
    """Say which commit last touched the line and whether it is part of the PR."""
    pr_commits = set(run("git", "rev-list", head, "--not", base).split())
    out = run("git", "blame", "-L", f"{line},{line}", "--porcelain", head, "--", path, check=False)
    if not out:
        return "no blame (file or line missing at head)"
    sha = out.split()[0]
    subject = run("git", "log", "-1", "--format=%s", sha).strip()
    where = "introduced or last changed IN this PR" if sha in pr_commits else "already on the base branch"
    return f"{where}: {sha[:8]} {subject}"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("anchors", nargs="*", help="FILE:LINE (line in the new version of the file)")
    ap.add_argument("--pr", help="PR number or URL; uses `gh pr diff`, which is what GitHub shows")
    ap.add_argument("--base", help="base ref (the PR's own base branch)")
    ap.add_argument("--head", help="head ref")
    ap.add_argument("--from-draft", help="markdown draft whose '###' headings carry 'path, line N'")
    ap.add_argument("--provenance", action="store_true", help="also report whether each line is new in the PR (needs --base/--head)")
    a = ap.parse_args()

    anchors = []
    for s in a.anchors:
        path, _, line = s.rpartition(":")
        if not path or not line.isdigit():
            sys.exit(f"bad anchor {s!r}; expected FILE:LINE")
        anchors.append((path, int(line)))
    if a.from_draft:
        anchors += anchors_from_draft(a.from_draft)
    if not anchors:
        sys.exit("no anchors given")

    repo_url = head_sha = None
    if a.pr:
        diff = run("gh", "pr", "diff", a.pr)
        info = json.loads(run("gh", "pr", "view", a.pr, "--json", "url,headRefOid,baseRefName,headRefName"))
        repo_url = info["url"].rsplit("/pull/", 1)[0]
        head_sha = info["headRefOid"]
        print(f"PR {info['url']}  base={info['baseRefName']}  head={info['headRefName']} ({head_sha[:8]})")
    elif a.base and a.head:
        diff = run("git", "diff", "-U3", f"{a.base}...{a.head}")
        head_sha = run("git", "rev-parse", a.head).strip()
        remote = run("git", "remote", "get-url", "origin", check=False).strip()
        m = re.search(r"github\.com[:/](.+?)(?:\.git)?$", remote)
        repo_url = f"https://github.com/{m.group(1)}" if m else None
        print(f"diff {a.base}...{a.head}  (head {head_sha[:8]})")
    else:
        sys.exit("give --pr N, or --base REF --head REF")

    files = parse_diff(diff)
    bad = 0
    for path, line in anchors:
        status, near = classify(files, path, line)
        note = ""
        if status in ("OUTSIDE-DIFF", "FILE-NOT-IN-DIFF"):
            bad += 1
            if near is not None:
                note = f"  (nearest changed line {near}; hunks {files[path]['hunks']})"
            elif status == "FILE-NOT-IN-DIFF":
                note = "  (this PR does not touch the file)"
        print(f"{status:17} {path}:{line}{note}")
        if status in ("OUTSIDE-DIFF", "FILE-NOT-IN-DIFF") and repo_url and head_sha:
            print(f"{'':17} permalink for a PR-conversation comment: {permalink(repo_url, head_sha, path, line)}")
        if a.provenance and a.base and a.head:
            print(f"{'':17} provenance: {provenance(a.base, a.head, path, line)}")
    if bad:
        print(f"\n{bad} anchor(s) outside the diff: check whether the finding is about code this PR changed "
              "before posting it as an inline comment.")
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
