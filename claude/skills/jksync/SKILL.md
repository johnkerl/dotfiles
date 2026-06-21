---
name: jksync
description: Sync the current branch with the repo's primary branch (main, master, preprod, etc). Pulls primary, switches back, merges in, pushes.
---

Detect the repo's primary branch: check `git remote show origin` for HEAD, then fall back to looking for main/master/preprod/develop in that order.

Steps:
1. Record the current branch name
2. If there are uncommitted changes, `git stash`
3. `git switch <primary>` and `git pull`
4. `git switch <original-branch>`
5. `git pull` (if an upstream is set for this branch)
6. `git merge <primary>` — or `git rebase <primary>` if the branch's existing commits are already pushed and rebase is clearly wrong; default to merge
7. `git push`
8. If stashed, `git stash pop`

If there are merge conflicts, stop immediately and describe which files conflict and what the conflict looks like. Do not attempt to resolve conflicts automatically.

Report what you did when finished: primary branch name detected, whether a stash was needed, final push status.
