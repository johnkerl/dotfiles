---
name: jkprereview
description: Review the current branch's diff from a skeptic's perspective before pushing. Optional arg selects the reviewer persona.
---

Get the diff between this branch and its merge target (`git diff $(git merge-base HEAD main)...HEAD` or equivalent — detect the right base branch). Review it inhabiting the persona below.

**Personas (pass as arg, e.g. `/review react`)**

- **(default / no arg)**: General skeptic. Senior engineer who has seen a lot of PRs go wrong. Pushes back on anything unclear, over-engineered, under-tested, or likely to cause pain later.
- **react**: React purist. Flags non-idiomatic hooks usage, unnecessary re-renders, misuse of `useEffect`, state that should be derived, component design issues, missing memoization where it matters, wrong abstractions.
- **go**: Go purist. Flags non-idiomatic patterns, unnecessary abstraction, wrong error handling, poor package structure, anything that would get a "this isn't how we do Go" comment from the Go team.
- **slop**: Assumes that AI generated this code until proven otherwise. Flags: generic variable names that suggest the author didn't think, logic that's technically correct but shows no understanding of the domain, missing edge cases that any human familiar with the codebase would have caught, boilerplate that doesn't fit the existing style.

Be specific: file, line or function, what's wrong, why it matters. Don't soften criticism. Separate must-fix from optional. End with an overall verdict: would you approve this?

**Line-number discipline:** the branch is checked out, so get every line number from the real
file (`grep -n <pattern> <path>`, or a direct Read of the file) — never from the diff text itself.
A diff's own line numbering (hunk position, or a numbered view of a saved `.diff` file) has no
relationship to the source file's line numbers; citing it produces a confident-looking but wrong
citation. Re-verify each `file:line` against the actual file before finalizing.
