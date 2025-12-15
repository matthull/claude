---
type: task-template
section: infrastructure-ops
description: Infrastructure setup, cloud services, CI/CD, monitoring, deployment
applies_to: supabase, database, ci-cd, github-actions, eas, sentry, posthog, deployment
source_guidance:
  global:
    - development-process/verification-principle
---

## CRITICAL: Validate Before Handoff (ABSOLUTE)

**You MUST validate infrastructure changes before handing off to user**

**RATIONALE:** Infrastructure mistakes are expensive. Misconfigured services, broken pipelines, or security holes waste hours of debugging. Claude catches errors first.

**You MUST ALWAYS:**
- Test that services respond (health endpoints, CLI status commands)
- Verify configurations are applied (not just created)
- Check connectivity between components
- Confirm credentials/secrets work
- Document what you verified and how

---

## CRITICAL: Test Strategy for Infrastructure (ABSOLUTE)

**Infrastructure work is NOT traditional TDD** - but verification is equally critical.

**RATIONALE:** You can't write a unit test for "Supabase project exists." But you MUST have a verification plan.

**You MUST ALWAYS:**
- Define verification approach BEFORE starting
- Use health checks, status commands, and connectivity tests
- Verify end-to-end flow (not just individual components)
- Document verification steps for user to repeat

**Testing Approaches by Task Type:**

| Task Type | Verification Approach |
|-----------|----------------------|
| Database setup | Connect, run query, check schema |
| Auth config | Test login flow, verify tokens |
| RLS policies | Test as different users, verify access denied/allowed |
| CI/CD pipeline | Trigger build, verify artifacts |
| Monitoring | Generate error, verify it appears in dashboard |
| Secrets/env vars | Verify app reads them (check logs, test endpoint) |

---

## CRITICAL: Security First (ABSOLUTE)

**Infrastructure changes often have security implications**

**You MUST ALWAYS:**
- Never commit secrets to git (use environment variables)
- Verify RLS policies deny unauthorized access (test negative cases)
- Check that sensitive endpoints require authentication
- Use least-privilege for service accounts
- Document security-relevant configuration

**You MUST NEVER:**
- Disable RLS "temporarily" (it never gets re-enabled)
- Use admin/service keys in client code
- Skip auth checks "for testing"
- Commit `.env` files or credentials

---

## Infrastructure Implementation Details

### Supabase Setup Verification

**Project exists and accessible**:
```bash
# CLI check
supabase status
supabase projects list

# Direct connection test
psql $DATABASE_URL -c "SELECT 1"
```

**Auth configuration**:
```bash
# Check auth settings via API
curl -X GET "$SUPABASE_URL/auth/v1/settings" \
  -H "apikey: $SUPABASE_ANON_KEY"

# Test signup/login flow
# (Create test user, verify token returned)
```

**RLS policies**:
```sql
-- Test as anon user (should fail for protected tables)
SET ROLE anon;
SELECT * FROM protected_table;  -- Should error or return empty

-- Test as authenticated user
SET ROLE authenticated;
SET request.jwt.claims = '{"sub": "user-uuid", "role": "staff"}';
SELECT * FROM protected_table;  -- Should return user's data only
```

**Storage buckets**:
```bash
# List buckets
curl -X GET "$SUPABASE_URL/storage/v1/bucket" \
  -H "Authorization: Bearer $SUPABASE_SERVICE_KEY"

# Test upload/download permissions
```

### CI/CD Verification

**GitHub Actions**:
```bash
# Check workflow syntax
gh workflow list
gh workflow view <workflow-name>

# Trigger test run
gh workflow run <workflow-name>

# Check run status
gh run list --workflow=<workflow-name>
gh run view <run-id>
```

**EAS (Expo Application Services)**:
```bash
# Verify EAS configuration
eas whoami
eas project:info

# Test build (internal distribution)
eas build --platform android --profile preview --non-interactive

# Check build status
eas build:list
```

**Environment configurations**:
```bash
# List EAS secrets
eas secret:list

# Verify env vars in build
# (Check build logs for env var loading)
```

### Monitoring Setup Verification

**Sentry**:
```bash
# Verify Sentry CLI configured
sentry-cli info

# Test error reporting
sentry-cli send-event -m "Test event from CLI"

# Verify in dashboard (manual check)
```

**PostHog**:
```javascript
// Test event capture (in app or script)
posthog.capture('test_event', { source: 'setup_verification' });

// Verify in PostHog dashboard (manual check)
```

### Database Schema Verification

**Migrations applied**:
```bash
# Check migration status
supabase db diff
supabase migration list

# Verify schema
psql $DATABASE_URL -c "\dt"  # List tables
psql $DATABASE_URL -c "\d table_name"  # Describe table
```

**Indexes exist**:
```sql
SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'table_name';
```

### Verification Loops for Infrastructure

**Loop 1 (Component Check)**: Each service/component works in isolation
```bash
# Database responds
psql $DATABASE_URL -c "SELECT 1"

# Auth endpoint responds
curl $SUPABASE_URL/auth/v1/health

# Storage accessible
curl $SUPABASE_URL/storage/v1/health
```

**Loop 2 (Integration Check)**: Components work together
```bash
# App can connect to database
npm run db:test-connection  # (if script exists)

# App can authenticate
# (Run auth flow, verify token)

# CI can build and deploy
gh workflow run ci.yml
```

**Loop 3 (End-to-End Check)**: Full flow works
```bash
# User signup → login → access data → logout
# (Manual test or E2E script)

# Deploy → verify in staging → smoke test
```

### Pre-Handoff Checklist

**Before marking task complete, Claude MUST verify:**

- [ ] **Service accessible** - Health endpoints respond
- [ ] **Configuration applied** - Settings are active (not just saved)
- [ ] **Credentials work** - Can authenticate with provided secrets
- [ ] **Security verified** - RLS denies unauthorized access
- [ ] **Integration tested** - Components talk to each other
- [ ] **Rollback documented** - How to undo if needed
- [ ] **User can verify** - Verification steps documented

### Smoke Test Pattern

Create a smoke test script for complex infrastructure:

```bash
#!/bin/bash
# smoke-test.sh - Verify infrastructure is working

set -e

echo "=== Infrastructure Smoke Test ==="

FAILED=false

test_endpoint() {
  local name=$1
  local url=$2
  if curl -sf "$url" > /dev/null; then
    echo "✓ $name"
  else
    echo "✗ $name - FAILED"
    FAILED=true
  fi
}

echo ""
echo "--- Supabase ---"
test_endpoint "Auth health" "$SUPABASE_URL/auth/v1/health"
test_endpoint "REST API" "$SUPABASE_URL/rest/v1/"
test_endpoint "Storage" "$SUPABASE_URL/storage/v1/"

echo ""
echo "--- Database ---"
if psql "$DATABASE_URL" -c "SELECT 1" > /dev/null 2>&1; then
  echo "✓ Database connection"
else
  echo "✗ Database connection - FAILED"
  FAILED=true
fi

echo ""
echo "--- Monitoring ---"
# Sentry: Check if DSN is configured
if [ -n "$SENTRY_DSN" ]; then
  echo "✓ Sentry DSN configured"
else
  echo "⚠ Sentry DSN not set"
fi

# PostHog: Check if key is configured
if [ -n "$POSTHOG_KEY" ]; then
  echo "✓ PostHog key configured"
else
  echo "⚠ PostHog key not set"
fi

echo ""
if [ "$FAILED" = true ]; then
  echo "=== SOME CHECKS FAILED ==="
  exit 1
else
  echo "=== ALL CHECKS PASSED ==="
fi
```

### Common Patterns

**Environment Management**:
- Use `.env.example` with dummy values (committed)
- Use `.env.local` for real values (gitignored)
- Use EAS secrets for CI/CD
- Document all required variables

**Database Setup**:
- Use migrations (not manual SQL in production)
- Create RLS policies before inserting data
- Test policies with different user contexts
- Index foreign keys and frequently queried columns

**CI/CD Configuration**:
- Start with minimal pipeline, add complexity as needed
- Cache dependencies for faster builds
- Use environment-specific configs (dev/staging/prod)
- Test pipeline changes on branches first

**Monitoring Integration**:
- Initialize early (even if minimal usage)
- Set up error alerting (email/Slack)
- Add custom events for key user actions
- Document what events mean

### Anti-patterns to Avoid

**You MUST NEVER:**
- ❌ Hand off without testing connectivity
- ❌ Skip RLS policy testing
- ❌ Commit secrets or credentials
- ❌ Disable security features "temporarily"
- ❌ Assume configuration was applied without checking
- ❌ Skip integration testing between components
- ❌ Leave monitoring unconfigured

**Prefer:**
- ✅ Test each component, then test integration
- ✅ Verify security by testing negative cases
- ✅ Use environment variables for all secrets
- ✅ Create smoke test scripts for complex setups
- ✅ Document rollback procedures
- ✅ Test in staging before production

---

## Task Completion Criteria

An infrastructure task is complete when:

1. **Services accessible** - All endpoints respond, CLI commands work
2. **Configuration verified** - Settings are applied and active
3. **Security tested** - Unauthorized access is denied
4. **Integration verified** - Components communicate correctly
5. **Credentials work** - App can authenticate with provided secrets
6. **Documentation complete** - User knows how to verify and troubleshoot
7. **Rollback documented** - How to undo changes if needed
