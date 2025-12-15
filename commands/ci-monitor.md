# CI Monitor and Fix Loop

You are monitoring CI for the current branch's PR and automatically fixing any failures.

## Prerequisites

**IMPORTANT:** This command requires access to the `gh` CLI tool. If you encounter permission errors or cannot run `gh` commands, STOP and ask the user:

> "I can't run GitHub CLI commands. This usually means sandbox mode is enabled. Please run `/sandbox` to disable it, then I can continue."

Do NOT proceed without `gh` access - the entire workflow depends on it.

## Process

### 1. Find the PR
```bash
# Get current branch
BRANCH=$(git branch --show-current)

# Find PR for this branch
gh pr list --head "$BRANCH" --json number,title,url --jq '.[0]'
```

If no PR exists, inform the user and exit.

### 2. Check CI Status
```bash
# Get PR number from step 1
gh pr checks <PR_NUMBER> --repo userevidence/musashi
```

### 3. Handle CI Status

**If CI is still running:**
- Inform user: "CI is still running. Waiting 25 minutes before checking again..."
- Wait 25 minutes: `sleep 1500`
- Return to step 2

**If CI passed:**
- Inform user: "All CI checks passed!"
- Exit successfully

**If CI failed:**
- Proceed to step 4

### 4. Diagnose Failures

For each failed check, get the logs:

**RSpec failures:**
```bash
gh run view <RUN_ID> --repo userevidence/musashi --log-failed 2>&1 | grep -E "(rspec.*spec.*rb|Failure|Error|expected|got:)" | head -50
```

**ESLint failures:**
```bash
gh run view <RUN_ID> --repo userevidence/musashi --log-failed 2>&1 | grep -E "(error|warning.*eslint)" | head -30
```

**Rubocop failures:**
```bash
gh run view <RUN_ID> --repo userevidence/musashi --log-failed 2>&1 | grep -E "(Offense|Style/|Layout/|Lint/)" | head -30
```

### 5. Fix Failures

**For RSpec failures:**
1. Read the failing spec file
2. Read related implementation files
3. Understand the failure (expected vs actual)
4. Fix the issue using TDD approach:
   - Run the specific failing test locally first
   - Make the fix
   - Verify the test passes locally
   - Run related tests to check for regressions

**For ESLint/Prettier failures:**
1. Try auto-fix first: `docker compose exec web yarn eslint --fix <file>`
2. If auto-fix doesn't resolve, manually fix the issue
3. Verify: `docker compose exec web yarn eslint <file>`

**For Rubocop failures:**
1. Try auto-fix first: `bundle exec rubocop -a <file>`
2. If that doesn't work, try aggressive: `bundle exec rubocop -A <file>`
3. If still failing, manually fix
4. Verify: `bundle exec rubocop <file>`

### 6. Commit and Push

After fixing all issues:
```bash
git add -A
git status --short  # Review changes

# Commit with descriptive message
git commit -m "Fix CI failures: <brief description>

- <specific fix 1>
- <specific fix 2>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

git push
```

### 7. Wait and Repeat

- Inform user: "Fixes pushed. Waiting 25 minutes for CI..."
- Wait 25 minutes: `sleep 1500`
- Return to step 2

## Important Guidelines

- **Never skip tests** - All tests must pass before considering CI fixed
- **Run tests locally first** - Before pushing, verify fixes work locally
- **Don't commit .env or local config** - Always check `git status` before committing
- **Keep fixes minimal** - Only fix what's needed, don't refactor unrelated code
- **Inform the user** at each major step so they know what's happening

## Example Output

```
Checking CI for PR #3626 (sup-211-dry-metrics-services)...

CI Status:
- Rspec: failed
- ESLint: passed
- Vitest: passed

Analyzing RSpec failure...
Failed test: spec/services/channel_engagement_metrics_service_spec.rb:420

Reading failing test...
The test expects events on end_date to be included, but they're being filtered out.

Fixing: Updating test to use fixture assets for ExistingAssetFilterable compatibility...

Running test locally...
1 example, 0 failures

Committing and pushing fix...
Waiting 25 minutes for CI...
```
