---
type: task-template
section: software-development
description: Software development specific principles - TDD, testing discipline, code quality
applies_to: coding, features, bug-fixes, refactoring
source_guidance:
  global:
    - testing/test-driven-development
    - code-quality/immediately-runnable-code
---

## CRITICAL: Testing Discipline (ABSOLUTE)

**EVERY piece of code MUST be verified by at least ONE method:**
- **Unit tests** (Jest, RSpec, Vitest) - for services, models, utilities, hooks
- **Component tests** (RNTL, Storybook) - for UI components
- **E2E tests** (Maestro, Playwright) - for integration points, user flows

**This is binary, not optional:**
- If unit tests + component tests cover 100% of code paths → E2E not required
- If ANY code path is NOT covered → E2E is REQUIRED

### Test Execution Rules

- You **MUST NEVER** skip, disable, or comment out any tests for any reason, under any circumstance.
- You **MUST NEVER** proceed to any subsequent task if tests are failing.
- You **MUST NEVER** mark a task as complete if tests are failing.
- You **MUST NEVER** dismiss test failures as "pre-existing" or "unrelated to current work". ALL test failures require immediate action.
- You **MUST NEVER** assume code works without testing it. You **MUST ALWAYS** verify functionality through one of:
  1. **TDD cycle** (write test first, then implementation), OR
  2. **Immediate manual testing** (execute in REPL, run test suite, verify output), OR
  3. **User verification** (explicitly ask user to test and confirm before proceeding)
- **IF TESTS FAIL:** You **MUST IMMEDIATELY STOP** all work and initiate the 'STOP and Ask' protocol to either fix the failures or request explicit user guidance.

**RATIONALE:** Untested code is unverified code. Assumptions about correctness lead to bugs. Test failures indicate broken functionality. Proceeding with failing tests compounds errors and wastes time.

---

## CRITICAL: Test Every New Method (ABSOLUTE)

**You MUST NEVER add a public method without its own test.**

**RATIONALE:** Untested methods = hidden bugs + broken contracts.

**You MUST test at the layer where defined:**
- Hook/utility → Unit test
- Component → Component test (RNTL) or Storybook
- Service method → Service spec
- API endpoint → Request/integration spec
- Model method → Model spec

**WRONG:** Adding `useSync()` hook without `useSync.test.ts`
**RIGHT:** Write test FIRST (TDD red), then implement

---

## CRITICAL: TDD Workflow (ABSOLUTE)

**Test-Driven Development is the default workflow for coding tasks.**

**The Cycle:**
1. **RED** - Write a failing test that describes the desired behavior
2. **GREEN** - Write minimal code to make the test pass
3. **REFACTOR** - Clean up while keeping tests green

**You MUST ALWAYS:**
- Write the test before the implementation
- Run tests after each change
- Keep tests focused (one behavior per test)
- Name tests descriptively (describe what, not how)

**You MUST NEVER:**
- Write implementation before tests
- Write tests that test implementation details
- Skip the refactor step
- Let tests stay red while writing more code

---

## Software Development Verification Loops

**Loop 1 (TDD - Focused Tests)**: Run tests for the specific code being changed
```bash
# Examples:
npm test -- --testPathPattern="ComponentName"
bundle exec rspec spec/services/my_service_spec.rb
npx vitest run src/hooks/useMyHook.test.ts
```

**🛑 MANDATORY TEST STATUS CHECK**

Before proceeding to Loop 2 or marking this task complete, you MUST:

1. **Output this exact line**: `🛑 RUNNING MANDATORY TEST CHECK`
2. **Run the test suite** (Loop 1 command above)
3. **Check output for ANY failure indicators**:
   - Look for: `FAILED`, `ERROR`, `0 passing`, `failures:`, `Failures:`, exit code ≠ 0
4. **If ANY failures exist**:
   - **IMMEDIATELY output**: `🛑 STOP: Test failures detected`
   - **DO NOT analyze, explain, or categorize the failures**
   - **Execute STOP and Ask protocol immediately**
   - **Report**: "Tests are failing. Need guidance: [paste failure output]"
   - **AWAIT user decision**
5. **Only if ZERO failures**:
   - Output: `✅ TEST CHECK PASSED: All tests green`
   - Proceed to Loop 2

**Loop 2 (Scoped - Related Tests)**: Run tests for the feature/module area
```bash
# Examples:
npm test -- --testPathPattern="features/auth"
bundle exec rspec spec/services/ spec/models/user_spec.rb
npx vitest run src/features/tasks/
```

**🛑 LOOP 2 TEST CHECK**

Repeat the MANDATORY TEST STATUS CHECK procedure above for Loop 2.

**Loop 3 (E2E - User Flow)**: Verify the full user experience
```bash
# Examples:
maestro test .maestro/flows/login.yaml
npx playwright test e2e/user-flow.spec.ts
# Or manual testing in browser/device
```

**Loop 3 Determination (Binary - REQUIRED or NOT REQUIRED)**:

Loop 3 is **REQUIRED** unless ALL code paths are 100% exercised by:
- Unit tests, OR
- Component tests/Storybooks

**If ANY code path is NOT covered by unit/component tests → Loop 3 is REQUIRED.**

Common scenarios where Loop 3 is REQUIRED:
- Backend API integration (data flows through real API)
- Database changes (data persists correctly)
- Multi-component data flow
- Navigation/routing changes
- Any integration point not covered by unit tests

**NOT REQUIRED only when**:
- Pure utility functions with 100% unit test coverage
- Purely presentational components with complete test/Storybook coverage AND zero backend integration

---

## Code Quality Checklist

**Before Completing Task**:
- [ ] **TDD followed** - Tests written before implementation
- [ ] **All tests pass** - Loop 1 and Loop 2 green
- [ ] **Every public method tested** - No untested public APIs
- [ ] **No skipped tests** - No `.skip`, `.only`, or commented tests
- [ ] **Coverage maintained** - No coverage regression
- [ ] **Loop 3 complete** - E2E verified (if required)
- [ ] **No linting errors** - Code passes lint checks
- [ ] **Types correct** - No TypeScript errors

---

## Software Development Success Criteria

- [ ] 🛑 MANDATORY TEST CHECK executed and passed for Loop 1
- [ ] 🛑 MANDATORY TEST CHECK executed and passed for Loop 2
- [ ] Every new public method has its own test
- [ ] All tests pass (no failures, no skipped)
- [ ] Loop 3 complete (REQUIRED unless 100% covered by unit/component tests)
- [ ] Code follows project conventions
- [ ] No linting or type errors

---

## Anti-patterns to Avoid

**You MUST NEVER:**
- ❌ Write code before writing the test
- ❌ Skip tests "just this once"
- ❌ Comment out failing tests
- ❌ Use `.skip` or `.only` in committed code
- ❌ Assume "it works" without running tests
- ❌ Proceed with any failing tests
- ❌ Test implementation details instead of behavior
- ❌ Write tests that pass regardless of implementation

**Prefer:**
- ✅ TDD: Red → Green → Refactor
- ✅ One assertion concept per test
- ✅ Descriptive test names
- ✅ Test behavior, not implementation
- ✅ Run tests frequently (after every change)
- ✅ Fix failing tests immediately
- ✅ Maintain high coverage
