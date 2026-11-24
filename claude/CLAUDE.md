# Personal working preferences

## Flag uncertainty explicitly

Default bias should be toward disclosing uncertainty, not toward confident-sounding proclamations
that don't hold up under probing. When you're not sure about something — a fact, a root cause, an
API's behavior, whether something still exists — say so, rather than stating it flatly.

Distinguish, out loud, between:

- **Verified**: you read the code, ran the command, checked the docs, or otherwise confirmed it
  directly.
- **Guess / inference**: your best read given partial information. Say "I think," "probably," or "I
  haven't verified this" rather than stating it as settled.
- **Speculation**: an idea or hypothesis you haven't checked at all.

This applies across both work and personal use — no need to distinguish context. If a claim is about
to inform a decision or an action, prefer checking it over guessing at it; if you can't check it,
say that plainly rather than smoothing it over.

## Don't use ... in URLs/paths

When displaying URLs and paths, always spell them out in full. Never elide components with "...",
even if you think it's obvious what the "..." stands for. I want copy-pasteable paths and URLs.  If
anything needs to be redacted, replace that part with `REDACTED` and leave everything else intact.

## Always give PRs and issues as full URLs

Every mention of a GitHub pull request is the full URL, `https://github.com/ORG/REPO/pull/NUMBER`.
Every mention of an issue is `https://github.com/ORG/REPO/issues/NUMBER`. No exceptions: chat replies,
tables, notes, drafts, commit messages, memory files, and files I'll read.

The number is never written without the URL, in any form. Not `#14720`, not `ORG/REPO#14720`, not
`PR 14720`, not `issue 1883`, not a bare `1883`, not a list like `1874/1920/1921`, not "the 1883
backfill". This holds for the second and third mention in the same reply too. Repeat the URL. Don't
shorten it because it appeared earlier.

If you don't know which repo a number belongs to, find out before writing it. Never fall back to a bare
number. Before sending a reply or finishing a file, scan it for any 3-to-5-digit number that refers to
a PR or issue and replace each with its URL.

## Git worktrees

Do not create a Git worktree if we're already working on a feature branch and I'm asking about
things on that feature branch.

If you feel you must create a Git worktree, first ask me if that's okay, and then prompt me for the
path.  Do not propose random tmp-paths: prefer ~/git/worktrees/<reponame>/<branchname>, or, failing
that, ~/git/worktrees/<reponame>/<some-descriptive-label-here>.

## Git branch names

When you create a branch for me, in any repo, prefix it with `johnkerl/`, not `jk/`. For example,
`johnkerl/add-build-tag`. This applies to new branches only; don't rename existing `jk/` branches
unless I ask.

## Drafts and notes

Most of our conversation happens in the Claude Code session, and that is right for almost
everything. Show analysis, short drafts and notes here.

When a draft is more than trivial and I will edit it before it goes to GitHub or Slack (issue text,
PR descriptions, doc drafts), write it as Markdown in `~/Desktop/DRAFTS/`. Not in `~/Desktop`
itself, and never in a scratchpad, `/tmp` or any other deep temporary path: I won't find it there.
(Same reason worktrees go under `~/git/worktrees/`.) The scratchpad is still fine for purely
internal intermediate files I don't need to see, including a file that a skill needs as its input.

Don't write a Markdown file when the text is already going somewhere I can edit it: review comments
staged with `/jkpend` (I edit them in GitHub), or a draft PR opened with `/jksubmit` (I edit the
PR). A file there is redundant.

File names don't matter; these are temporary. I clean up `~/Desktop/DRAFTS/` myself. Never delete,
move or tidy my drafts.

Notes that are for my eyes only (tone, trust, what to hold) are fine in the session and fine in a
draft file, below a clearly marked `NOT FOR PASTING` line. Never put them in anything that goes, or
is staged to go, to GitHub or Slack.

Posting is a separate matter: see `posting-in-my-name.md`.

## Things to check when doing PR reviews

When drafting PR review comments, use the `/jk-pr-review-checks` skill.

## Acronyms and initialisms

- When someone else uses an acronym, it's fine to spell it out.
- When the acronym or initialism *is* the name (for example AWS, RDS), use it as-is.
- When a thing is usually spelled out (for example "blue-green deployment"), leave it spelled out.
  Don't introduce or adopt coined shorthand like "BGD": it's overly clever and unhelpful.
