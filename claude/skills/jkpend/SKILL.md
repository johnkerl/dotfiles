---
name: jkpend
description: Stage a GitHub PR review as a pending, unsubmitted review, with the review body and each comment attached to its line, so the user can edit and submit it in the GitHub UI. Use when the user asks to "leave it pending", "stage the review", "put the comments in the PR without submitting", or wants to avoid copy/paste from a review draft. Never submits.
---

# Stage a pending PR review

Create a `PENDING` review on a PR. Only the user can see it, and nobody is notified. The user edits the comments and submits it themselves.

Use this after reviewing (see `/jkreview` and `/jk-pr-review-checks`), or on an existing draft file. It takes a PR URL and, optionally, a draft path. With no draft, write one first, in `~/Desktop`, in the format below.

## Draft format

- `## Review body`: the top-level text.
- `## Inline comments`: one `### <path>, line <N> [<tag>]` heading per comment, then the comment text. Tags are change, question, nit or follow-up. `<path>` is repo-relative and `<N>` is a line number in the file at the PR head.
- `## Conversation comment [follow-up]` (optional): text that is not anchored to a line. It is appended to the review body, because a pending review cannot hold a separate conversation comment.

Keep notes for the user (tone, what to hold, communication-style commentary) out of the draft. They go in the chat reply.

## Before creating anything

1. Identity: `gh api user --jq .login` is the user, not a bot or another account.
2. Head: `gh pr view <n> --json headRefOid --jq .headRefOid` equals the commit the draft's line numbers were taken from. If it moved, re-run the anchor check against the new head and update the draft first.
3. Existing pending review: `gh api repos/<org>/<repo>/pulls/<n>/reviews --jq '.[] | select(.state=="PENDING") | {id, user: .user.login}'`. If the user already has one, stop and ask. GitHub allows one pending review per user per PR.
4. Anchors: run `python3 -I ~/.claude/skills/jk-pr-review-checks/scripts/pr-anchor-check.py --pr <n> <path>:<line> ...` on every comment. A line outside the diff goes in the review body with a full permalink, not inline.
5. Secrets: scan the draft for keys, tokens, passwords and private keys, using formats and context, not filenames alone. Never display a suspected value. Report its location and type and pause.

## Create it

1. Build the payload, keeping the output in the scratchpad:
   `python3 -I ~/kerl/.claude/skills/jkpend/scripts/build-review.py <draft.md> <full-head-sha> <scratchpad>/review_payload.json`
   It exits non-zero and writes nothing if the draft is malformed. Fix the draft, don't work around it.
2. Do not add an `event` field. A payload without `event` is what keeps the review pending.
3. `gh api -X POST repos/<org>/<repo>/pulls/<n>/reviews --input <scratchpad>/review_payload.json --jq '{id, state, user: .user.login, html_url}'`

## Verify

- The returned `state` is `PENDING`.
- `gh api repos/<org>/<repo>/pulls/<n>/reviews/<id>/comments --jq '.[] | {path, position, hunk_tail: (.diff_hunk | split("\n") | last)}'`: each `hunk_tail` is the intended source line. The API reports `line` and `side` as null for pending comments, so do not use them as the check.

## Report to the user

- The review URL, and how to submit it: Files changed, then Finish your review.
- The number of comments, and the commit the review is pinned to.
- That no verdict was chosen. The user picks Approve, Comment or Request changes.
- That a push to the PR after this may mark some comments outdated.

## Never

- Never submit the review, set `event`, or pick a verdict for the user.
- Never delete or overwrite someone else's pending review, and never delete the user's without being asked.
- Never write a bare `@name` for someone the user did not mean to notify. Put roles and code in backticks.
