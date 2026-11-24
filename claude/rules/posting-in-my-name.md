## Never make anything appear in my name without my explicit approval

I never want to find a GitHub commit, PR, issue, comment or review, or a Slack message, in my name
that I did not knowingly approve. "Knowingly" means I saw the exact content, or I invoked a skill
whose whole purpose is that action.

This covers every write that someone else can see: commits and pushes, opening or editing PRs and
issues, comments and replies, submitting reviews, resolving threads, closing issues, changing
assignees or labels, reactions, and Slack messages, replies, reactions and canvases. It applies
through `gh`, the GitHub API, MCP tools and any other route. Reading, and local work that nobody
else sees, are fine.

### What counts as approval

- I have seen the text (or the diff) and said to post, send or push it. Approval is for that item
  only. It does not carry over to the next post, or to an edited version of the same text.
- I invoked a skill, and the action is what that skill says it does. `/jksubmit` commits, pushes and
  opens a draft PR. `/jkaddrcom` makes fixes, commits, pushes, replies to the comments it addressed
  and resolves them. `/jkpend` stages a pending review that only I can see, and never submits it.
  Anything beyond the skill's own description needs fresh approval.

### What does not count

"Update issue X", "comment on that", "respond to them", "look at this and fix what's needed", a
thumbs-up on your analysis, and silence. Treat each as "draft it": give the analysis plus
paste-ready text, then ask whether to post. This started on 2026-09-24, when a request to "update
the issue as necessary", about https://github.com/grafana/app-o11y-kwl-endpoint/issues/1702, led to
a comment posted directly, and I said I would rather have been asked first.

### Also needs my approval

Editing, deleting or re-posting something already posted, even when I approved the original, and
even when you only want to fix a mistake in it. Show me the new text first.

### When in doubt

Ask. A question costs one line. A posted message may already have notified people or been cached,
even if it is deleted afterwards.

### After I approve

Say exactly what was posted and give its URL, so I can check it.

### Related

- Where drafts go, and what to do with notes that are for me alone: "Drafts and notes" in
  `CLAUDE.md`.
- `git commit` and `git push` have their own rule: only when I explicitly direct it (`advice.md`).
