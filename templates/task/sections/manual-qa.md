---
type: task-template
section: manual-qa
description: Manual QA procedures, console verification, browser testing, and QA checklists
applies_to: all
source_guidance:
  global:
    - testing/test-driven-development
    - code-quality/immediately-runnable-code
---

## Manual QA Verification

### QA Gate Checklist

**This task is NOT complete until all items are checked**:

- [ ] Automated tests passing (Loop 2)
- [ ] Manual verification complete (Loop 3)
- [ ] Edge cases manually tested
- [ ] Error states behave correctly
- [ ] Data persists as expected
- [ ] No console errors/warnings (if UI involved)
- [ ] Performance acceptable (no obvious slowdowns)

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

### Manual QA Anti-patterns

**You MUST NEVER**:
- ❌ Skip manual QA because "tests pass"
- ❌ Test only happy path (must test edge cases)
- ❌ Assume UI works without visual verification
- ❌ Mark complete without verifying data persistence
- ❌ Ignore browser console errors
- ❌ Test in development only (verify in staging if possible)
- ❌ Skip testing with real data (not just fixtures)

**Prefer**:
- ✅ Test with production-like data volumes
- ✅ Verify both UI and database state
- ✅ Test with multiple user roles/permissions
- ✅ Clear browser cache between test runs
- ✅ Test edge cases and error scenarios
- ✅ Document unexpected behavior even if minor

### When to Involve Human QA

**Claude Code Can Handle**:
- Deterministic console verification
- Database state checks
- Log output verification
- Simple UI rendering checks

**Human Should Handle**:
- Complex multi-step user workflows
- Visual design verification
- Cross-browser compatibility
- Accessibility testing
- Subjective UX evaluation
- Real user acceptance testing
