---
type: task-template
section: manual-qa
description: Claude QA Engineer procedures - automated AND "manual" testing via tools before human UAT
applies_to: all
source_guidance:
  global:
    - testing/test-driven-development
    - code-quality/immediately-runnable-code
---

## Claude QA Engineer: "Manual" Testing via Tools

**Claude is the QA Engineer.** All testing (automated AND "manual") happens before handoff to human.

**"Manual" testing means using tools** - not deferring to human:
- **Mobile**: Waydroid + ADB screenshots, Maestro flows
- **Web**: Browser automation, DevTools console, network inspection
- **API**: curl/httpie, console verification, response inspection
- **Backend**: Rails console, database queries, log inspection

**Human (Product Manager) receives a thoroughly tested feature** for UAT sign-off.

---

### CRITICAL: Tools Unavailable Protocol

**If Claude cannot complete verification because tools are unavailable:**

1. **IMMEDIATELY STOP** - Do not proceed without verification
2. **Do NOT hand off with "please manually verify"** - This is not acceptable
3. **Report clearly:**
   - What verification is needed
   - What tool would normally do it
   - Why the tool is unavailable (not configured, service down, etc.)
4. **Ask for guidance:**
   - "Should I help set up [tool]?"
   - "Is there an alternative verification approach?"
   - "Should we defer this task until tooling is available?"

**Example STOP message:**
> "🛑 STOP: Cannot complete visual verification. Waydroid is not running and I cannot start it.
>
> Needed: Screenshot verification of component rendering
> Tool: Waydroid + ADB
> Status: `waydroid status` shows 'not running'
>
> Options:
> 1. Help you start Waydroid (need `waydroid show-full-ui`)
> 2. Alternative: Write Maestro E2E test to verify (but needs device)
> 3. Defer until Waydroid is available
>
> How should I proceed?"

**You MUST NEVER:**
- ❌ Hand off with "please manually test [X]" when Claude should have tested it
- ❌ Skip verification and hope for the best
- ❌ Assume human will catch issues Claude should have caught

---

### Available QA Tools

**Mobile (React Native/Expo):**
```bash
# Screenshot verification
adb exec-out screencap -p > /tmp/screen.png

# Launch app
adb shell am start -n com.anonymous.projectalfalfa/.MainActivity

# Force stop (clean state)
adb shell am force-stop com.anonymous.projectalfalfa

# Get UI text (accessibility dump)
~/.claude/skills/waydroid-adb/scripts/get-ui-text.sh

# Tap by coordinates or button
~/.claude/skills/waydroid-adb/scripts/tap-button.sh "Button Text"
```

**Web (Browser):**
- Browser MCP tools (navigate, screenshot, click, fill)
- DevTools console inspection
- Network request inspection

**Backend (Rails/API):**
```bash
# Rails console
docker compose exec web rails console

# Database queries
docker compose exec web rails dbconsole

# API testing
curl -X GET http://localhost:3000/api/v2/endpoint
```

**General:**
```bash
# Log inspection
docker logs container_name

# Process monitoring
docker ps

# Port checking
curl -v http://localhost:PORT
```

---

### QA Gate Checklist

**Claude completes ALL of these before handoff**:

- [ ] Automated tests passing (Loop 1 + Loop 2)
- [ ] "Manual" verification complete via tools (Loop 3)
- [ ] All edge cases tested (via automated tests OR manual tool verification)
- [ ] Error states verified (trigger errors, confirm behavior)
- [ ] Data persistence verified (create, query, confirm in DB)
- [ ] No console errors/warnings (checked via tools)
- [ ] Performance acceptable (no obvious slowdowns observed)

### Backend Console Verification

**Start Rails Console**:
```bash
rails console
# OR for specific environment
rails console staging
```

**Verification Steps**:

#### Step 1: Load Test Data
```ruby
{LOAD_TEST_DATA_COMMANDS}

# Example:
resource = Resource.find({ID})
user = User.find_by(email: 'test@example.com')
```

#### Step 2: Execute Service/Method
```ruby
{EXECUTE_SERVICE_COMMANDS}

# Example:
service = ServiceName.new(resource)
result = service.call

# Inspect result
result.inspect
pp result # Pretty print for better readability
```

#### Step 3: Verify Side Effects
```ruby
{VERIFY_SIDE_EFFECTS_COMMANDS}

# Example:
resource.reload
resource.status
# => "expected_status"

resource.updated_at
# => Should be recent timestamp

# Check associated records
resource.associations.count
# => Expected count

resource.associations.last.attributes
# => Contains expected data
```

#### Step 4: Test Edge Cases
```ruby
{TEST_EDGE_CASES_COMMANDS}

# Example:
# Test with nil
ServiceName.new(nil).call rescue => e
e.message # Should have meaningful error

# Test with empty
ServiceName.new(Resource.new).call

# Test with invalid state
invalid_resource = Resource.new(status: 'invalid')
ServiceName.new(invalid_resource).call
```

**Console Verification Template**:
```ruby
# 1. Setup
resource = {SETUP_CODE}

# 2. Execute
result = {EXECUTION_CODE}

# 3. Verify primary result
raise "Unexpected result: #{result}" unless {CONDITION}

# 4. Verify side effects
resource.reload
raise "Status should be X" unless resource.status == "expected"

# 5. Verify persistence
Resource.find(resource.id).attribute
# => Should match expected

# 6. Clean up (if needed)
resource.destroy if resource.persisted?
```

### Frontend Browser Verification

**Start Development Server**:
```bash
npm run dev
# OR
rails server
```

**Access Application**:
```
Browser: http://localhost:{PORT}
```

**Verification Steps**:

#### Step 1: Navigate to Feature
```
1. Open browser to http://localhost:{PORT}
2. {NAVIGATION_STEPS}
3. Reach target UI: {TARGET_UI_LOCATION}
```

#### Step 2: Verify Initial State
```
- [ ] UI renders correctly
- [ ] No console errors (F12 → Console)
- [ ] All elements visible: {LIST_OF_ELEMENTS}
- [ ] Correct initial data displayed
```

#### Step 3: Execute User Flow
```
1. {USER_ACTION_1}
   Expected: {EXPECTED_RESULT_1}

2. {USER_ACTION_2}
   Expected: {EXPECTED_RESULT_2}

3. {USER_ACTION_3}
   Expected: {EXPECTED_RESULT_3}
```

#### Step 4: Verify Results
```
- [ ] Success message shown: "{EXPECTED_MESSAGE}"
- [ ] UI updated correctly: {UI_CHANGES}
- [ ] Data persisted (check database or refresh page)
- [ ] No error messages
```

#### Step 5: Test Error States
```
- [ ] Invalid input shows validation error
- [ ] Network error handled gracefully
- [ ] Empty state displays correctly
- [ ] Loading state appears during async operations
```

### QA Test Procedure

**Feature**: {FEATURE_NAME}
**User Story**: {USER_STORY}

**Preconditions**:
- {PRECONDITION_1}
- {PRECONDITION_2}

**Test Steps**:

| Step | Action | Expected Result | ✓/✗ |
|------|--------|----------------|-----|
| 1 | {ACTION_1} | {EXPECTED_1} | {STATUS} |
| 2 | {ACTION_2} | {EXPECTED_2} | {STATUS} |
| 3 | {ACTION_3} | {EXPECTED_3} | {STATUS} |

**Post-conditions**:
- {POSTCONDITION_1}
- {POSTCONDITION_2}

### QA Findings

**Issues Found** (if any):
- {ISSUE_1_DESCRIPTION}
  - **Severity**: {CRITICAL|HIGH|MEDIUM|LOW}
  - **Steps to Reproduce**: {STEPS}
  - **Resolution**: {HOW_FIXED}

**Edge Cases Tested**:
- {EDGE_CASE_1}: {RESULT}
- {EDGE_CASE_2}: {RESULT}

**Performance Notes**:
- {PERFORMANCE_OBSERVATION_1}
- {PERFORMANCE_OBSERVATION_2}

### Evidence & Screenshots

**Backend Evidence**:
```ruby
# Console output showing successful verification
{CONSOLE_OUTPUT_PASTE}
```

**Frontend Evidence** (if applicable):
```
Screenshot 1: {SCREENSHOT_DESCRIPTION}
Path: {SCREENSHOT_PATH}

Screenshot 2: {SCREENSHOT_DESCRIPTION}
Path: {SCREENSHOT_PATH}
```

### Browser Console Checks

**Open DevTools** (F12):

**Console Tab**:
- [ ] No errors (red messages)
- [ ] No warnings about critical issues
- [ ] Expected log messages appear (if any)

**Network Tab**:
- [ ] API calls return 200/201 (not 4xx/5xx)
- [ ] Response bodies contain expected data
- [ ] No failed requests (red status)

**Application Tab** (if relevant):
- [ ] Local storage/session storage correct
- [ ] Cookies set appropriately

### QA Anti-patterns (Claude MUST Avoid)

**You MUST NEVER**:
- ❌ Defer "manual" testing to human - use tools instead
- ❌ Hand off with "please verify [X]" when tools could verify it
- ❌ Skip edge case testing because "tests pass"
- ❌ Assume UI works without visual verification via tools
- ❌ Mark complete without verifying data persistence
- ❌ Ignore console errors visible in tool output
- ❌ Test only happy path (must test edge cases via tools)
- ❌ Skip testing with realistic data scenarios

**Claude MUST**:
- ✅ Use available tools for visual verification (Waydroid, browser MCP)
- ✅ Test with production-like data volumes
- ✅ Verify both UI (via screenshots) and database state
- ✅ Test with multiple user roles/permissions
- ✅ Test edge cases and error scenarios
- ✅ Document unexpected behavior found during testing
- ✅ Hand off with verification evidence (screenshots, console output)

### Human UAT (After Claude QA Complete)

**Claude (QA Engineer) handles ALL testing:**
- ✅ Deterministic console verification
- ✅ Database state checks
- ✅ Log output verification
- ✅ UI rendering via screenshots (Waydroid, browser tools)
- ✅ Multi-step user workflows (via Maestro, browser automation, or step-by-step tool execution)
- ✅ Edge case testing
- ✅ Error state verification

**Human (Product Manager) does UAT on thoroughly tested feature:**
- Final product acceptance - does it meet requirements?
- Subjective UX evaluation - does it feel right?
- Exploratory testing (optional) - anything Claude might have missed
- Sign-off for release

**The handoff should be:**
> "Feature is fully tested. All automated tests pass. I verified the full user flow via [tools used].
> Edge cases tested: [list]. Error handling verified. Ready for your UAT sign-off."

**NOT:**
> "Tests pass. Please manually verify [list of things Claude should have tested]."
