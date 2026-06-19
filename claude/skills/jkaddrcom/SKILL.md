---
name: fix-comments
description: Action GitHub PR review comments. Provide a PR URL to fix all open comments, or a specific comment URL to fix one.
---

**If given a specific comment URL** (e.g. `https://github.com/org/repo/pull/123#discussion_r456789`):
1. Fetch the comment: `gh api /repos/{owner}/{repo}/pulls/comments/{comment_id}`
2. Understand exactly what it's asking — read the surrounding code for context
3. Make the code change
4. Commit: `git commit -m "Address review comment: <brief what you did>"`
5. Push
6. Reply to the comment with: `gh api --method POST /repos/{owner}/{repo}/pulls/comments/{comment_id}/replies -f body="Done in $(git rev-parse HEAD)"`
7. Resolve the thread if the API supports it: `gh api --method PUT /repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/resolve`

**If given a PR URL** (or no arg — detect the current branch's open PR with `gh pr view`):
- List all unresolved review comments: `gh api /repos/{owner}/{repo}/pulls/{pr}/comments`
- Filter to open, unresolved threads
- Process each one using the single-comment flow above, **one commit per comment**
- Report a summary when done: how many addressed, any skipped (with reason)

**On ambiguous comments:** if you're not sure what a comment is asking, say so and ask before making a change — don't guess on a commit.

**On comments that require discussion rather than a fix:** reply explaining why you're not changing it, don't commit.
