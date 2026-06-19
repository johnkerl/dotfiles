---
name: review-pr
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
