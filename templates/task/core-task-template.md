---
type: task-template
name: core-task-template
description: Universal task handoff template for all coding tasks
applies_to: all
---

<!-- PLANNER NOTE: This template provides guidance, NOT implementations
     - Include: Method signatures, test structure, API contracts
     - NEVER include: Complete implementations or solution code
     - Apply ultra-concise principles throughout
-->

# Task: {TASK_ID}

**Goal**: {TASK_GOAL}
**Status**: {STATUS}

---

## CRITICAL: Test Every New Method (ABSOLUTE)

**You MUST NEVER add a public method without its own test.**

**RATIONALE:** Untested methods = hidden bugs + broken contracts.

**You MUST test at the layer where defined:**
- Client method → Client spec
- Service method → Service spec
- Controller → Request spec
- Model method → Model spec

**WRONG:** Adding Client#update_file without client_spec.rb test
**RIGHT:** Write client_spec.rb test FIRST (TDD red), then implement

---

## CRITICAL: Wrong Assumptions Stop and Ask Protocol (ABSOLUTE)

**You MUST IMMEDIATELY STOP if handoff assumptions are wrong.**

**RATIONALE:** Wrong assumptions = wrong implementation.

```
STOP when codebase differs from handoff.
Report: Expected [X], found [Y]
Impact: Cannot proceed because [reason]
Need: Should I [option A] OR [option B]?
AWAIT user decision.
```

**You MUST NEVER**: Guess, adapt silently, proceed when unsure
**You MUST ALWAYS**: Stop immediately, explain clearly, wait for guidance

---

## Context

```bash
# Find relevant code
{GREP_COMMANDS}

# Check current implementation
{CAT_COMMANDS}
```

<!-- PLANNER NOTE: Include canonical examples ONLY if creating NEW class or major rewrite -->
<!-- {CANONICAL_EXAMPLE_COMMANDS} -->

---

## Task

**Fix**: {TASK_DESCRIPTION}
**File**: {FILE_PATH}

**Requirements**:
{REQUIREMENTS_LIST}

**Tests**:
- {SCENARIO_1}
- {SCENARIO_2}
- {SCENARIO_N}

<!-- SECTION HOOK: Insert technology-specific sections here based on task type -->

---

## Verification

<!-- PLANNER NOTE: Commands filled by technology sections -->

**Loop 1 (TDD)**: {FOCUSED_TEST_COMMAND}

**Task Review**: After Loop 1 passes, run `/task-review` to review implementation
- Reviews uncommitted code against task handoff quality gates
- Validates adherence to guidelines and standards
- Fix any critical issues before Loop 2
- Ensures quality before project-wide impact

**Loop 2 (Scoped)**: {PROJECT_TEST_COMMAND}
**Loop 3 (Manual)**: {CONSOLE_OR_BROWSER_COMMAND}

**You MUST NEVER proceed with failing tests.**

**Loop 3 Required When**:
- External APIs
- Database changes
- Complex logic
- Integration points

**Skip Loop 3 ONLY with user approval.**

---

## Success Criteria

- [ ] {CRITERION_1}
- [ ] {CRITERION_2}
- [ ] {CRITERION_3}
- [ ] API doc extraction completed (if API integration)
- [ ] Implementation matches extracted specs exactly (if API integration)
- [ ] Every new public method has its own test
- [ ] All tests pass
- [ ] Stop and Ask used if needed
- [ ] Loop 3 complete (if required)

---

<!-- PLANNER NOTE: Completion section filled after task done -->
## Completion

**Date**: {DATE_COMPLETED}
**Changes**: {SUMMARY_OF_CHANGES}
**Tests**: {TEST_STATE_SUMMARY}
