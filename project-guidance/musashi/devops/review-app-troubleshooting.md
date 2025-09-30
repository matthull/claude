---
type: guidance
status: current
category: devops
---

# Review App Troubleshooting

## App Naming Convention
```
userevidence-pr-<PR_NUMBER>

Example: PR #3151 → userevidence-pr-3151
```

## Rails Console Access
```bash
heroku run -a userevidence-pr-<PR_NUMBER> bundle exec rails console
```

**Use tmux sidecar for interactive console:**
@~/.claude/guidance/tools/tmux-sidecar.md

Console takes ~15-20s to load. Example command after load:
```bash
tmux send-keys -t SESSION:WINDOW.1 'User.count' C-m
```

## Log Analysis Workflow

### User describes issue → Claude filters logs

**Pattern:**
1. User describes what happened in app
2. Claude pulls relevant logs with grep filters
3. Show filtered logs + analysis

**Example workflow:**
```bash
# Get recent logs with filters for issue
heroku logs -n 500 --app userevidence-pr-3151 | grep -E "(404|ERROR|id)" | head -100

# Get context around specific request ID
heroku logs -n 1000 --app userevidence-pr-3151 | grep -A 5 -B 5 "request-id-here"
```

### Log filtering guidelines
- Filter by: HTTP status, error keywords, model names, request IDs
- Use `-A N` (after) and `-B N` (before) for context
- Limit output with `head` to avoid noise
- Show user: relevant 404s, errors, SQL queries, request paths

## Shared Infrastructure

**CRITICAL:** All review apps share databases:
- **PostgreSQL:** Shared across all review apps
- **Elasticsearch:** Shared across all review apps

### Implications
- Records may belong to different accounts
- `account_id` scoping critical for queries
- Data from all PRs visible in shared DB
- Account mismatch = common 404 source

### Common Pattern: Account Scoping 404s
```
Symptom: HTML page loads, API returns 404
Cause: Record exists but belongs to different account_id

Diagnosis in console:
ModelName.unscoped.where(id: X).pluck(:id, :account_id)
User.find(USER_ID).account_id

If account_ids don't match → API correctly returns 404
```

## Debugging Checklist

### For 404 errors:
1. Check if record exists: `Model.unscoped.find_by(id: X)`
2. Check account_id: `Model.unscoped.where(id: X).pluck(:id, :account_id)`
3. Check user's account: `User.find(USER_ID).account_id`
4. Compare: Do account_ids match?

### For unexpected behavior:
1. Get logs describing user action
2. Filter for relevant request path
3. Check SQL queries in logs
4. Verify scoping (account_id, soft deletes, etc.)
5. Test in console with unscoped queries

### For data issues:
1. Remember: shared DB across all PRs
2. Check account associations
3. Use `.unscoped` to bypass default scopes
4. Verify current_user context in API

## Common Commands

```bash
# View recent logs
heroku logs -n 500 --app userevidence-pr-<PR>

# Tail live logs
heroku logs --tail --app userevidence-pr-<PR>

# Check app info
heroku info --app userevidence-pr-<PR>

# Check config
heroku config --app userevidence-pr-<PR>

# List all review apps
heroku apps --team userevidence | grep "pr-"
```

## Workflow: Investigating Issue

1. **User describes problem:** "404 on asset page"
2. **Pull filtered logs:** `heroku logs -n 500 | grep "404"`
3. **Identify request ID** from 404 log entry
4. **Get full context:** `grep -A 5 -B 5 "request-id"`
5. **Show user:** Filtered logs + SQL queries
6. **If needed:** Open console to verify data
7. **Diagnose:** Account scoping, missing record, etc.