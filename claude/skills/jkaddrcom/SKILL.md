---
name: jkaddrcom
description: Action GitHub PR review comments. Provide a PR URL to fix all open comments, or a specific comment URL to fix one.
---

**If given a specific comment URL** (e.g. `https://github.com/org/repo/pull/123#discussion_r456789`):
1. Fetch the comment: `gh api /repos/{owner}/{repo}/pulls/comments/{comment_id}`
2. Understand exactly what it's asking — read the surrounding code for context
3. Make the code change
4. Commit: `git commit -m "Address review comment: <brief what you did>"`
5. Push
6. Reply to the comment — **PR number required in path**:
   ```
   gh api --method POST /repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies \
     -f body="Done in $(git rev-parse HEAD)"
   ```
7. Resolve the thread via GraphQL (REST has no resolve endpoint):
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
- Report a summary when done: how many addressed, any skipped (with reason)

**On ambiguous comments:** if you're not sure what a comment is asking, say so and ask before making a change — don't guess on a commit.

**On comments that require discussion rather than a fix:** reply explaining why you're not changing it, don't commit.
