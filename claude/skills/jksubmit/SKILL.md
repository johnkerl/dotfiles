---
name: jksubmit
description: Commit, push, and open a draft PR with a written description. Use when ready to share work in progress for review.
---

Stage any unstaged changes the user intended to include (ask if it's ambiguous), then commit with a message that accurately summarizes the work. Push the branch. Open a draft PR with `gh pr create --draft`.

Write a PR description that a skeptical senior reviewer would find useful:
- What changed and why (not a list of files)
- Any non-obvious decisions or tradeoffs
- How to test it, if non-trivial
- Known gaps or things intentionally left out

If the repo has a PR template, follow its structure. If there's an existing PR for this branch, update its description instead of creating a new one.

Don't ask for confirmation before pushing or creating the PR — the user invoked this because they're ready.
