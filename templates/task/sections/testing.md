---
type: task-template
section: testing
description: Test scenarios, coverage analysis, and debugging strategies
applies_to: all
source_guidance:
  global:
    - testing/test-driven-development
    - development-process/tdd-human-review-cycle
    - code-quality/immediately-runnable-code
---

## Test Strategy

### Test Scenarios

**Scenario Coverage**:
- [ ] **Happy path**: {HAPPY_PATH_DESCRIPTION}
- [ ] **Edge cases**: {EDGE_CASES_LIST}
- [ ] **Error handling**: {ERROR_SCENARIOS}
- [ ] **Integration points**: {INTEGRATION_SCENARIOS}

**Detailed Scenarios**:

#### Scenario 1: {SCENARIO_NAME}
**Given**: {PRECONDITIONS}
**When**: {ACTION}
**Then**: {EXPECTED_OUTCOME}

**Test Implementation**:
```ruby
it '{behavior description}' do
  # Arrange: {SETUP_DESCRIPTION}
  {SETUP_CODE}

  # Act: {ACTION_DESCRIPTION}
  {ACTION_CODE}

  # Assert: {EXPECTATION_DESCRIPTION}
  expect({RESULT}).to {MATCHER}
end
```

#### Scenario 2: {SCENARIO_NAME}
**Given**: {PRECONDITIONS}
**When**: {ACTION}
**Then**: {EXPECTED_OUTCOME}

### Test Coverage Summary

**Before Changes**:
```
{TEST_COUNT_BEFORE} examples, {FAILURE_COUNT_BEFORE} failures
```

**After Changes**:
```
{TEST_COUNT_AFTER} examples, 0 failures
```

**New Test Coverage**:
- ✅ {NEW_TEST_AREA_1}
- ✅ {NEW_TEST_AREA_2}
- ✅ {NEW_TEST_AREA_3}

**Test Types**:
- **Unit tests**: {UNIT_TEST_COUNT} (testing isolated components)
- **Integration tests**: {INTEGRATION_TEST_COUNT} (testing component interactions)
- **System tests**: {SYSTEM_TEST_COUNT} (testing full workflows, if applicable)

### Debugging Approach

**Layered Testing Strategy** (when tests fail):

1. **Lowest Level First**: Test in isolation
   ```bash
   # Backend example
   rails console
   {ISOLATED_COMPONENT_TEST}

   # Verify basic functionality works
   ```

2. **Service/Component Level**: Test with minimal dependencies
   ```ruby
   # Minimal test setup
   service = ServiceName.new(minimal_dependencies)
   result = service.call
   result.inspect
   ```

3. **Integration Level**: Test with real collaborators
   ```ruby
   # Integration test with actual database, APIs (stubbed), etc.
   it 'integrates correctly' do
     # Real ActiveRecord, stubbed external APIs
   end
   ```

4. **Full System**: End-to-end testing
   ```ruby
   # Full request/response cycle
   # OR browser-based system test
   ```

**Common Debugging Steps**:
```ruby
# 1. Add debug output to understand what's happening
pp variable_name

# 2. Check assumptions
raise "Expected X, got #{actual}" unless condition

# 3. Use debugger
binding.pry  # (REMOVE before committing)

# 4. Verify test data
User.count  # Are records being created?
user.reload # Is state what you expect?

# 5. Check for order dependencies
# Run single test: bundle exec rspec spec/file_spec.rb:42
# Run in random order: bundle exec rspec --order random
```

### Test Quality Checklist

**Before Marking Task Complete**:
- [ ] **Tests written BEFORE implementation (TDD red-green-refactor)**
- [ ] **No execution order dependencies (tests pass when run in random order)**
- [ ] **No `.only` or `.skip` in committed code (or documented exception)**
- [ ] All tests pass consistently (run 3x to verify)
- [ ] No flaky tests (random failures)
- [ ] No test pollution (tests pass in isolation and in suite)
- [ ] Clear test descriptions (readable as documentation)
- [ ] No over-mocking (test real behavior when possible)
- [ ] Fast tests (< 30 seconds for full suite if possible)
- [ ] Tests verify behavior, not implementation details

### Test Improvements Made

**Reduced complexity**:
- {IMPROVEMENT_1}
- {IMPROVEMENT_2}

**Improved clarity**:
- {IMPROVEMENT_3}
- {IMPROVEMENT_4}

**Better coverage**:
- {IMPROVEMENT_5}
- {IMPROVEMENT_6}

### Anti-patterns Avoided

**You MUST NEVER**:
- ❌ Skip tests to "make it work first" (TDD red-green-refactor)
- ❌ Use `sleep` to fix timing issues (find root cause)
- ❌ Stub methods on the object under test
- ❌ Test private methods directly (test through public interface)
- ❌ Leave failing tests commented out
- ❌ Commit tests with `.only` or `.skip` without explanation

**Prefer**:
- ✅ Test behavior, not implementation
- ✅ One assertion per test (when possible)
- ✅ Descriptive test names that explain "why" not "what"
- ✅ Test-first development (red-green-refactor)
- ✅ Integration tests for critical user flows
- ✅ Fast, focused unit tests for edge cases
