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

When displaying URLs and paths, always spell them out in full. Never elide components with "...", even
if you think it's obvious what the "..." stands for. I want copy-pasteable paths and URLs.

## Worktrees

Do not create a Git worktree if we're already working on a feature branch and I'm asking about
things on that feature branch.

If you feel you must create a Git worktree, first ask me if that's okay, and prompt me for the path.
Do not propose random tmp-paths: prefer ~/git/worktrees/<reponame>/<branchname>, or, failing that,
~/git/worktrees/<reponame>/<some-descriptive-label-here>.
