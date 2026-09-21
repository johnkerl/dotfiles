---
name: jkaddrcom
description: Action GitHub PR review comments. Provide a PR URL to fix all open comments, or a specific comment URL to fix one.
---

**Detect this repo's conventions first.** Before drafting anything, check the target
repo's root for `AGENTS.md`, `CLAUDE.md`, and `CONTRIBUTING.md`. Look for, and follow
when present:

- **Commit message format.** If the repo states a convention (e.g. Conventional
  Commits `type(scope): description`), use it for the subject and put the review
  comment's URL in the body instead. If the repo states no convention, check
  `git log` on the current branch for how prior review-fix commits were written and
  match that; only fall back to a short phrase + the comment URL as the subject if
  neither gives you a pattern.
- **Pre-push checks.** A "Pre-PR Checks" section, or check scripts in
  `package.json`/`Makefile`. Run at minimum the fastest correctness-relevant ones
  (typecheck + format check are close to universal); run the full listed set when
  it's not slow. Fix anything they flag before committing — don't push red.
- **TDD / RED gate.** If the repo requires a failing test before implementation for
  behavior changes, and this fix isn't purely mechanical (rename, formatting, config,
  docs), write or identify one focused test, run it, confirm it fails for the reason
  the comment describes (not a typo or broken fixture), then implement the minimal
  fix, then confirm that test and the rest of the touched suite pass.
- **Protected behavior.** A list of areas needing extra authorization (auth, CI/CD,
  governance, irreversible external operations). If the fix touches one, stop and
  confirm before proceeding regardless of how confident you are.
- **AI-contribution disclosure.** If the repo requires one on PR comments/reviews
  (exact wording and placement vary), the reply in step 7 below needs it too — see
  that step.

**If given a specific comment URL** (e.g. `https://github.com/org/repo/pull/123#discussion_r456789`):

1. Fetch the comment: `gh api /repos/{owner}/{repo}/pulls/comments/{comment_id}`
2. Understand exactly what it's asking — read the surrounding code for context
3. Make the code change, following the conventions detected above (RED test first if
   that gate applies to this repo and this fix)
4. Run the repo's pre-push checks; fix any failures
5. Commit, using the subject convention detected above; put the comment URL in the
   body whenever the subject format doesn't have room for it
6. Push
7. Reply to the comment with the pushed commit hash — **PR number required in path**:
   ```
   gh api --method POST /repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies \
     -f body="$(git rev-parse HEAD)

   AI contribution: agent=<agent>; model=<provider>/<model>; agent version=<version-or-unavailable>."
   ```
   Fill the disclosure line with this session's own identifiers (never guess or reuse
   a stale one) — `agent=unavailable` / `model=unavailable` / `agent version=unavailable`
   for anything not exposed. Include it even if the repo's own convention isn't
   confirmed to require it on replies specifically; omit only if the repo explicitly
   says PR comments don't need one.
8. Resolve the thread via GraphQL (REST has no resolve endpoint):
   ```
   # Get the thread node_id for this comment's thread
   THREAD_ID=$(gh api graphql -f query='{
     repository(owner: "{owner}", name: "{repo}") {
       pullRequest(number: {pr}) {
         reviewThreads(first: 100) {
           nodes { id isResolved comments(first: 1) { nodes { databaseId } } }
         }
       }
     }
   }' --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.comments.nodes[0].databaseId == {comment_id}) | .id')

   gh api graphql -f query="mutation { resolveReviewThread(input: { threadId: \"$THREAD_ID\" }) { thread { isResolved } } }"
   ```

**If given a PR URL** (or no arg — detect the current branch's open PR with `gh pr view`):

- Fetch unresolved threads via GraphQL (gives `isResolved` directly, unlike the REST comments list):
  ```
  gh api graphql -f query='{
    repository(owner: "{owner}", name: "{repo}") {
      pullRequest(number: {pr}) {
        reviewThreads(first: 100) {
          nodes {
            id isResolved
            comments(first: 10) {
              nodes { databaseId body path originalLine author { login } }
            }
          }
        }
      }
    }
  }' --jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)]'
  ```
- For each unresolved thread, fetch the root comment with `gh api /repos/{owner}/{repo}/pulls/comments/{comment_id}` and process it using the single-comment flow above, **one commit per comment**
- Report a summary when done: how many addressed (with commit hashes), any skipped (with reason)

**Confidence gate.** Steps 3–8 run straight through, without stopping, only when the
fix is a no-brainer: the comment's ask is unambiguous, the change is small and
obviously correct, it doesn't touch a protected area, and — when the RED gate
applies — the failing test actually demonstrated the described bug rather than
something incidental. Otherwise stop and discuss before committing, pushing,
replying, or resolving — a drafted fix you're unsure of is worth showing before it's
a commit, not after.

**On ambiguous comments:** if you're not sure what a comment is asking, say so and ask before making a change — don't guess on a commit.

**On comments that require discussion rather than a fix:** reply explaining why you're not changing it, don't commit, don't resolve.
