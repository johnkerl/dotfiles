---
name: pr-review-checks
description: Checks to run on every finding before drafting review comments on someone else's pull request. Verify that each comment's line is in the PR's diff, whether the problem was introduced by the PR or was already there, and whether the PR is based on the current tip of its base branch. Use whenever drafting, reviewing or posting PR review comments.
---

# PR review checks

Run these on every finding before it becomes a comment. They exist because two mistakes are easy
to make and both land on the PR author:

- Putting a comment on a line the PR did not change. GitHub allows it (for example on expanded
  context), but it is usually a sign that the finding is wrong about the PR's responsibility, is
  under-informed about why the code is there, or will not be welcome. Treat it as a prompt to
  check, not as a blocker.
- Presenting something already on the base branch as if the PR introduced it. That is unfair to the
  author and weakens the review.

## For each comment

1. Anchor. Compute the diff the way GitHub does and see whether the file and line are in it:
   `pr-anchor-check.py` (below). If the line is outside the diff, either move the finding to a
   PR-conversation comment with a full permalink to the head commit and say that the code is not
   part of the diff, or, if you still want it inline, be sure it is about something this PR
   changed.
2. Provenance. Say which of these it is, with evidence: introduced by this PR; made worse by this
   PR (give both numbers); already on the base branch. Run the same repro on the base, or use
   `--provenance` below (blame plus the PR's commit list). Already-on-base findings are
   follow-ups: label them, and do not use them as a reason to hold the merge.
3. Base freshness (stacked PRs especially). Diff against the PR's own base branch, which for a
   stacked PR is not main. Check that the head is based on the current tip of that base
   (`git merge-base` versus the base head), and try `git merge-tree --write-tree --name-only`
   to count conflicts with the base and with sibling PRs.
4. Evidence. Prefer a small test that fails on the PR head and a minimal fix confirmed against
   the existing suite. Say what was run, what was only read, and what is inference.
5. Tag. Mark each comment [change], [follow-up], [question] or [nit], so the author can tell
   what blocks.

Keep drafts out of the PR until the user says to post. Save drafts to ~/Desktop. Notes meant for
the user (trust, tone, what to hold) go in a section marked as not for pasting.

## The anchor script

`scripts/pr-anchor-check.py`, bundled with this skill (standard library only). Run it as
`python3 -I ${CLAUDE_SKILL_DIR}/scripts/pr-anchor-check.py`; it is executed, not read.

```sh
# What GitHub shows (needs gh and a checkout of the PR's repository):
python3 -I ${CLAUDE_SKILL_DIR}/scripts/pr-anchor-check.py --pr 1920 pkg/foo/bar.go:102 pkg/foo/baz.go:7

# From local refs; use the PR's own base branch:
python3 -I ${CLAUDE_SKILL_DIR}/scripts/pr-anchor-check.py --base origin/main --head origin/feature \
  --provenance pkg/foo/bar.go:102

# Anchors read from a draft whose comment headings look like "### 3. pkg/foo/bar.go, line 289"
# (also "lines 16 and 30" and "around line 285"):
python3 -I ${CLAUDE_SKILL_DIR}/scripts/pr-anchor-check.py --pr 1920 \
  --from-draft ~/Desktop/pr-1920-review-draft.md
```

Per anchor it prints CHANGED, CONTEXT, OUTSIDE-DIFF or FILE-NOT-IN-DIFF. For anything outside the
diff it prints the nearest changed line and a permalink to use in a PR-conversation comment. With
`--provenance` it says whether the line was introduced in the PR or was already on the base
branch, and by which commit (limits: blame shows the last commit to touch the line, so moved code
looks new; this does not replace running a repro on the base). Exit status is 1 if any anchor is
outside the diff, so it can gate a script.

Spell out permalinks in full: `https://github.com/<org>/<repo>/blob/<full-sha>/<path>#L<line>`.
