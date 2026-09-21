---
name: jksubmit
description: Commit, push, and open a draft PR with a written description. Use when ready to share work in progress for review.
---

**Check for this repo's own PR-opening rules first.** Look for a project-level
`pr-create` (or similarly named) skill, and for an `AGENTS.md`/`CLAUDE.md`/`CONTRIBUTING.md`
that states an issue-linking requirement ("no ghost PRs" or equivalent), a commit-message
convention, pre-push checks, or a required disclosure line on PR descriptions/comments.

- **If a repo-level PR-creation skill exists, run that instead of the steps below** —
  it exists to enforce exactly this repo's process, and skipping it to save a question
  defeats its purpose. That includes any explicit question it requires asking (e.g.
  which issue this closes) — asking that is part of running the skill, not the kind of
  confirmation-delay this skill otherwise skips.
- **If no such skill exists but the repo states rules anyway** (issue-linking, commit
  format, pre-push checks, disclosure line), follow them directly: ask the required
  question(s), use the stated commit format, run the stated checks before pushing, and
  add the disclosure line to the PR description if one is required.
- **If the repo states none of this**, use the fast path below as originally designed.

**Fast path (no repo-specific gate found):**

Stage any unstaged changes the user intended to include (ask if it's ambiguous), then commit with a message that accurately summarizes the work. Push the branch. Open a draft PR with `gh pr create --draft`.

Write a PR description that a skeptical senior reviewer would find useful:
- What changed and why (not a list of files)
- Any non-obvious decisions or tradeoffs
- How to test it, if non-trivial
- Known gaps or things intentionally left out

If the repo has a PR template, follow its structure. If there's an existing PR for this branch, update its description instead of creating a new one — if that update errors out, check the repo's own skill docs for a known workaround before giving up.

Don't ask for confirmation before pushing or creating the PR — the user invoked this because they're ready. This only covers the confirmation this skill would otherwise add on top; it never overrides a gate the repo itself requires (see above).
