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

## Git worktrees

Do not create a Git worktree if we're already working on a feature branch and I'm asking about
things on that feature branch.

If you feel you must create a Git worktree, first ask me if that's okay, and then prompt me for the
path.  Do not propose random tmp-paths: prefer ~/git/worktrees/<reponame>/<branchname>, or, failing
that, ~/git/worktrees/<reponame>/<some-descriptive-label-here>.

## Where to put drafts

When writing a Markdown draft or other file for me to read or pick up (issue text, PR descriptions,
doc drafts), put it in `~/Desktop`, not in a scratchpad or tmp directory. Scratchpad is fine for
purely internal intermediate files I don't need to see.

## Acronyms and initialisms

- When someone else uses an acronym, it's fine to spell it out.
- When the acronym or initialism *is* the name (for example AWS, RDS), use it as-is.
- When a thing is usually spelled out (for example "blue-green deployment"), leave it spelled out.
  Don't introduce or adopt coined shorthand like "BGD": it's overly clever and unhelpful.
