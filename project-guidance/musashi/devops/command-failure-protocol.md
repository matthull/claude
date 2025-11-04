---
type: guidance
status: current
category: devops
tags:
- devops
- docker
- troubleshooting
focus_levels:
- implementation
---

# Environment & Command Failure Protocol

## Command Failure Response
- You **MUST NEVER** assume command output or guess results when commands fail
- You **MUST NEVER** proceed with development when commands fail to execute
- You **MUST NEVER** skip environmental issues or work around them
- **IF ANY COMMAND FAILS:** You **MUST IMMEDIATELY STOP** all work and:
  1. HALT current task
  2. Show exact error output to user
  3. Attempt standard fixes documented below
  4. If fixes fail, request user assistance with specific error details
  5. AWAIT explicit resolution before resuming

**RATIONALE:** Guessing command results creates false assumptions. Environmental issues compound. Failed commands indicate broken state requiring resolution.

## Standard Fix Sequence

### Missing Gems / Bundler Errors
```bash
docker compose down
docker compose build
docker compose up -d
```

### Pending Migrations
```bash
docker exec musashi-web-1 bundle exec rails db:migrate
docker exec musashi-web-1 bundle exec rails db:migrate RAILS_ENV=test
```

### Yarn Errors / Missing Packages
```bash
docker compose down
docker compose build
docker compose up -d
```

### Container Not Running
```bash
docker compose up -d
```

### Database Connection Errors
```bash
docker compose restart
```

## Fix Verification
After applying fixes:
1. Re-run the failed command
2. Verify it executes successfully
3. Only then resume original task

## Unresolvable Issues
If standard fixes fail:
1. Show user the complete error output
2. Show which fixes were attempted
3. Request specific guidance
4. STOP all work until resolved
