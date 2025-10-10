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

## Test Scenarios

**Required**:
- [ ] Happy path: {HAPPY_PATH}
- [ ] Edge cases: {EDGE_CASES}
- [ ] Error handling: {ERROR_SCENARIOS}

### {SCENARIO_1}
```ruby
it '{description}' do
  # Arrange
  {SETUP}

  # Act
  {ACTION}

  # Assert
  expect({RESULT}).to {MATCHER}
end
```

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

<!-- PLANNER NOTE: Debugging approach usually not needed - implementers know -->
<!-- Include only for complex debugging scenarios -->

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
- ❌ Write one spec per response attribute (use comprehensive specs)
- ❌ Use instance variables instead of `let`
- ❌ Use `RSpec.describe` instead of `describe`

**Prefer**:
- ✅ Test behavior, not implementation
- ✅ Comprehensive response specs (one spec per scenario, checking all attributes)
- ✅ Descriptive test names that explain "why" not "what"
- ✅ Test-first development (red-green-refactor)
- ✅ Integration tests for critical user flows
- ✅ Fast, focused unit tests for edge cases
- ✅ `let` statements over instance variables
