---
name: jkactivity
description: Summarize what a GitHub user has been working on recently, from their authored PRs and assigned issues. Requires a GitHub handle.
argument-hint: <github-handle> [org=grafana] [days=30]
---

Arguments: `$ARGUMENTS`

The first argument is the GitHub handle and is required. If it is missing, stop and ask for it;
do not guess from git config or context. Optional `org=<org>` (default `grafana`) and
`days=<n>` (default `30`) may follow.

Compute the cutoff date as today minus `days`, in `YYYY-MM-DD` form.

## Queries

Do not filter by state. Open, closed, and merged items all count as work.

These are the `gh` equivalents of the GitHub web searches
`is:pr author:<handle> archived:false org:<org>` and
`is:issue assignee:<handle> archived:false org:<org>`, sorted by most recently updated:

```bash
gh search prs --author <handle> --owner <org> --archived=false --updated ">=<cutoff>" \
  --limit 100 --json repository,title,state,isDraft,createdAt,updatedAt,closedAt,url \
  --jq '.[] | [.updatedAt[:10], .createdAt[:10], .state, (if .isDraft then "draft" else "" end), .repository.nameWithOwner, .title, .url] | @tsv'

gh search issues --assignee <handle> --owner <org> --archived=false --updated ">=<cutoff>" \
  --limit 100 --json repository,title,state,createdAt,updatedAt,closedAt,url \
  --jq '.[] | [.updatedAt[:10], .createdAt[:10], .state, .repository.nameWithOwner, .title, .url] | @tsv'
```

Run both in parallel. If either returns exactly 100 rows, say the results were truncated.

## Summarizing

- Group items into themes of work, not by repo. A feature often spans several repos (for
  example, a service PR plus a deployment-config PR that enables it). Order themes by how much
  of the person's time they appear to take.
- Within a theme, tell the story in order when there is one: build, rollout, then fixes.
- Link each open PR to the issue it fixes when the titles make the match clear.
- Tell `merged` apart from `closed`. A closed PR that was not merged is either abandoned or
  replaced by another one; say you don't know which unless you checked.
- `--updated` catches old items that were only touched briefly. Use `createdAt` to point these
  out, and put long-open assigned issues with little activity in a separate "stale or
  low-activity" list rather than presenting them as active work.
- Base the summary on titles, states, and dates. Say so at the top. Read PR or issue bodies
  (`gh pr view <url> --json body`) only for items whose titles are too vague to place, and say
  which ones you read.
- Every item gets a full link. Show dates as `YYYY-MM-DD` or `MM-DD`.
- End by noting what the queries do not cover (reviews given, comments on others' issues,
  commits pushed directly) and offer `--reviewed-by <handle>` or `--commenter <handle>`
  follow-ups.

Show the summary in the Claude Code session only. Do not post it anywhere.
