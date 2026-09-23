---
name: jkreview
description: Review a GitHub PR. Provide a URL to review without checking it out locally, or omit the URL if the branch is already checked out.
---

**If a GitHub PR URL is provided:**
Use `gh pr view <url>` for metadata and `gh pr diff <url>` for the diff. Do not check out the branch. Review purely from the diff and any linked context (description, comments).

**If no URL is provided:**
Assume the current branch is the PR under review. Use `git diff $(git merge-base HEAD main)...HEAD` (detect the right base), plus `gh pr view` if a PR exists.

Review as a thoughtful senior engineer doing a real code review:
- Is the approach sound, or is there a better way?
- Bugs, edge cases, error handling gaps
- Security or performance concerns
- Clarity: would you understand this in six months?
- Anything that would block you from approving

Give specific file/line feedback. Separate blocking issues from suggestions. End with a clear statement: approve, approve-with-comments, or request-changes — and why.

**Line-number discipline (systematic failure mode, check this every time):**
A line number is only valid if it was read from the actual source file at the PR's head commit —
never from a diff. If you save a diff to a scratch file and view it with a numbered tool (Read,
`cat -n`, etc.), those numbers belong to the diff file, not the source file, even though both look
like plain line numbers. Citing the diff file's numbers as source line numbers is easy to do and
easy to miss.

Before writing any `file:line` citation:
- If the branch is checked out and its `HEAD` matches the PR's head SHA (`git rev-parse HEAD`),
  get the line number from `grep -n <pattern> <path>` or a direct Read of the real file — not from
  the diff.
- If not checked out, fetch the real file at the head SHA (e.g.
  `gh api repos/<owner>/<repo>/contents/<path>?ref=<sha>`, or `git show <sha>:<path>` if that SHA
  is fetchable locally) and `grep -n` against that. Do not hand-count from a `@@ -a,b +c,d @@` hunk
  header, and never reuse a number you saw while reading a `.diff` file.
- Before finalizing the review, re-verify every cited line number this way. If one doesn't check
  out, drop the number rather than guess — a vague-but-correct pointer beats a precise-but-wrong
  one.

Show your feedback in the Claude Code session. Don't post to the PR unless directed to do so.
