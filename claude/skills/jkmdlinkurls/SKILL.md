---
name: jkmdlinkurls
description: In one or more Markdown files, replace every bare URL (https://foo.bar) with an explicit link ([https://foo.bar](https://foo.bar)), in place. Leaves code spans, fenced code blocks, existing links, images, autolinks and HTML untouched. Requires one or more file paths as arguments.
---

**Input:** one or more file paths, separated by spaces. At least one is required. If none is given,
print `usage: /jkmdlinkurls <file> [<file> ...]` and stop; don't guess a file. Expand `~`. If a path
doesn't exist or isn't a regular file, say so, skip it, and carry on with the others. Do not follow
a path into a directory or expand globs the user didn't type.

This is a text-editing skill and nothing else. Never run `git add`, `git commit`, `git stash`, or any
other git command that changes state; never stage, commit, push or open a PR. The user drives git.
Read-only git (for example `git diff`) is fine if it helps.

Always read each file fresh from disk at the start of every run, even if it was read earlier in the
conversation. The user probably edited it by other means in between, so any earlier copy in context
is stale. Work only from that fresh read, and don't overwrite their edits with an older version. If
the file changes between your read and your write, re-read it and redo the replacement on the new text.

Edit each file in place. No backup copy and no confirmation: the file is normally under git. Write
through the real path: the Edit tool refuses symlinks, so resolve with `realpath` and edit the target.

## What counts as a bare URL

A run of non-space characters starting `http://` or `https://`, outside every context listed under
"Leave alone". Don't include trailing sentence punctuation in the URL: strip any of `. , ; : ! ?` from
the end, and a closing `)` or `]` only when there is no matching opener inside the URL. The stripped
punctuation stays after the new link. Example: `see https://a.b/c.` becomes
`see [https://a.b/c](https://a.b/c).`

Wrap it as `[URL](URL)`, the same string for the text and the target. Nothing else about the line
changes.

## Leave alone

A URL in any of these is not bare; don't change it:

- Within double quotes: `"https://x"`. A URL between a pair of straight `"` characters on the same
  line.
- Within backticks: `` `https://x` ``. Any URL inside an inline code span, even when the span
  holds other text too (`` `curl https://x` ``).
- Within a fenced code block: a multi-line block opened and closed by three backticks (or `~~~`).
- Already a link, `[...](...)`, with the URL as the target or inside the brackets:
  `[text](https://x)`, `[https://x](https://x)`. A `![alt](https://x)` image counts too.
- An autolink: `<https://x>`.
- A reference definition: `[ref]: https://x`.
- Raw HTML: `<a href=...>`.
- YAML front matter.
- Anything without an `http://` or `https://` scheme: `dev.grafana-dev.net`, `mailto:`, `ftp:`.

If a URL left alone is an autolink, reference definition, raw HTML or front matter, list it in the
report.

## Procedure

1. Read the file fresh from disk, now. Don't reuse an earlier read.
2. Do the replacement with a short script, not by hand, so every occurrence is caught. Run Python
   with `python3 -I`, split the text into lines, track whether you are inside a fenced block (a line
   starting with three backticks or `~~~` toggles it), split each remaining line on code spans and
   on double-quoted spans (`"..."` on one line), and apply the substitution only to the text outside
   them. Skip a match when it is directly preceded by `(`, `[` or `<`, or followed by `]`, `)` or `>`
   that closes an existing link.
3. Write the file back, keeping the original trailing newline (or lack of one) and line endings.
4. Check: `grep -n 'https\?://'` on the file, then read each hit. Every remaining URL should be in a
   link, double quotes, a code span, a fenced block, or another case under "Leave alone". Fix
   anything that isn't.
5. The script must be idempotent. Running it a second time changes nothing; if it would, there is a
   bug.

## Report

Per file: how many URLs were wrapped, plus any URL left alone as an autolink, reference definition,
raw HTML or front matter. One line per file, no restating of the rules.
