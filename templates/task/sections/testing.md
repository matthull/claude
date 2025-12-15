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

<!-- PLANNER NOTE: Describe test scenarios, do NOT write test code
     - List scenarios as plain English descriptions
     - Reference line numbers from existing test files
     - Maximum 1-5 lines of code for context only
     - Implementer will write actual tests following TDD
-->

## Test Scenarios

**Required**:
- [ ] Happy path: {HAPPY_PATH_DESCRIPTION}
- [ ] Edge cases: {EDGE_CASE_DESCRIPTIONS}
- [ ] Error handling: {ERROR_SCENARIO_DESCRIPTIONS}

**Reference existing test patterns:**
- Similar to: `{existing_spec_file}:{line_numbers}`
- Follow structure in: `{canonical_test_example}`

<!-- PLANNER NOTE: Do NOT include test code blocks - describe scenarios only -->

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

### MANDATORY: Test Failure Stop Protocol

**This is an ABSOLUTE constraint with NO exceptions:**

```
WHEN running tests:
  IF output contains ANY failure indicators:
    IMMEDIATELY output: "🛑 STOP: Test failures detected"
    DO NOT analyze failures
    DO NOT explain why they might have occurred
    DO NOT categorize as "pre-existing" or "unrelated"
    EXECUTE: STOP and Ask protocol
    REPORT: "Tests failing. Need guidance."
    AWAIT: User decision
  ELSE:
    Output: "✅ All tests passing"
    PROCEED: To next step
```

**Rationale**: Test failures indicate broken functionality. Proceeding compounds errors. Analysis happens AFTER stopping, not before.

### Test Quality Checklist

**Before Marking Task Complete**:
- [ ] **ONE spec file per class (no method-specific spec files)**
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
- ❌ **Create multiple spec files for individual methods** (ONE spec file per class)
- ❌ **Add boilerplate comments** (no `# Arrange`, `# Act`, `# Assert`, `# Setup`, `# Given/When/Then` - let code structure speak for itself)
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
- ✅ Comments ONLY for non-obvious business logic or complex algorithms (rare)
