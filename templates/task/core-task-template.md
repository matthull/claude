---
type: task-template
name: core-task-template
description: Universal task handoff template for all coding tasks
applies_to: all
source_guidance:
  global:
    - development-process/tdd-human-review-cycle
    - testing/test-driven-development
    - code-quality/immediately-runnable-code
    - ai-development/ultra-concise-enforcement
---

# Task Handoff: {TASK_ID}

**Task ID**: {TASK_ID} | **Date**: {DATE}
**Goal**: {TASK_GOAL}
**Status**: {STATUS}

---

## CRITICAL: Code Guidance Format

This handoff provides **guidance**, NOT implementations:

- ✅ Method signatures and interfaces
- ✅ Expected test structure
- ✅ API contracts and data shapes
- ✅ Code pattern references
- ❌ **NEVER complete implementations** - defeats TDD purpose
- ❌ **NEVER pre-written solution code** - must write minimal code to pass tests

---

## Quick Context

```bash
# Load ONLY relevant sections
{GREP_COMMANDS}

# Key files
{CAT_COMMANDS}

# Canonical examples (read and follow patterns)
{CANONICAL_EXAMPLE_COMMANDS}
```

**Note**: Canonical examples are exemplar implementations. Read them BEFORE implementing to understand codebase patterns and conventions.

---

## Current State

- **Done**: {LIST_OF_COMPLETED_ITEMS}
- **Next**: {LIST_OF_UPCOMING_ITEMS}
- **Blocked**: {LIST_OF_BLOCKING_ITEMS}
- **Deferred**: {LIST_OF_DEFERRED_ITEMS_WITH_REASONS}

---

## Task Details

### {TASK_ID}: {TASK_DESCRIPTION}

**Location**: {FILE_PATH}
**Scope**: {SCOPE_DESCRIPTION}

**Test Scenarios**:
- {SCENARIO_1}
- {SCENARIO_2}
- {SCENARIO_N}

**Reference**: {LINK_TO_RESEARCH_DOC}

<!-- SECTION HOOK: Technology-specific patterns
     Insert sections like:
     - ruby-rails-code.md (method signatures, RSpec patterns, console commands)
     - vue-component.md (component structure, Storybook patterns, Vitest)
     - architecture-design.md (layer context, integration flows)
     - bug-fix-resolution.md (root cause, solution, lessons learned)
-->

---

## Dependencies

{LIST_OF_DEPENDENCIES}

<!-- SECTION HOOK: Domain-specific guidance
     Insert sections like:
     - api-integration.md (API contracts, VCR cassettes, error handling)
     - testing.md (test scenarios, coverage, debugging strategies)
     - manual-qa.md (QA checklists, verification procedures)
-->

---

## Task Completion Gate (MANDATORY)

<!-- NOTE: Verification commands below ({FOCUSED_TEST_COMMAND}, {PROJECT_TEST_COMMAND}, etc.)
     are provided by technology sections (ruby-rails-code.md, vue-component.md)
-->

### Loop 1: TDD Inner Loop

```bash
{FOCUSED_TEST_COMMAND}
```

**Purpose**: Focused development on single component/test file

**Technology-specific examples** (see section templates for details):
- **Backend (Ruby)**: `bundle exec rspec spec/services/foo_spec.rb`
- **Frontend (Vue)**: `npm run storybook` → Verify component at http://localhost:6006

### Loop 2: Project-Wide Verification

```bash
{PROJECT_TEST_COMMAND}
```

**MANDATORY before marking ANY task complete - must complete in < 30 seconds**

**Technology-specific examples** (see section templates for details):
- **Backend (Ruby)**: `bundle exec rspec` or `./specs/{PROJECT}/verify-specs.sh`
- **Frontend (Vue/Vitest)**: `npm run test` or `vitest`
- **Python**: `pytest`
- **Go**: `go test ./...`

### Loop 3: Manual QA (OPTIONAL - requires user approval to skip)

**This loop may be skipped ONLY when**:
- Unit tests provide 100% confidence (rare)
- Pure logic with no external dependencies or integrations
- User explicitly approves skipping

**You MUST perform Loop 3 when**:
- Integrating multiple components
- External APIs or databases involved
- Complex business logic with side effects
- ANY uncertainty about correctness

**Stop and Ask Protocol**:
```
Before skipping Loop 3, you MUST ask user for approval.
Never skip without explicit user permission.
```

**Backend**: Console verification
```bash
{CONSOLE_VERIFICATION_COMMANDS}
```

**Frontend**: Browser verification
```bash
{BROWSER_VERIFICATION_COMMANDS}
```

**When to perform**:
- **Claude Code**: Automated QA for deterministic scenarios
- **Human**: Complex workflows, visual verification, edge cases

### Failure Protocol

**You MUST NEVER proceed with failing tests**

- FAILING SPECS = INCOMPLETE TASK
- You **MUST** fix immediately
- **Stop and Ask** if you need clarification on expected behavior
- NO EXCEPTIONS
- NO PROCEEDING

---

## Success Criteria

- [ ] {CRITERION_1}
- [ ] {CRITERION_2}
- [ ] {CRITERION_3}
- [ ] **Guidance only (no complete implementations provided)**
- [ ] **All tests passing (zero failures)**
- [ ] Loop 1 verification passing
- [ ] Loop 2 verification passing (all project tests)
- [ ] Loop 3 manual QA complete (if applicable)

---

## Completion Summary

**Date Completed**: {DATE_COMPLETED}
**Final Test State**: {TEST_STATE_SUMMARY}

**Key Changes**:
{SUMMARY_OF_CHANGES}

**Files Changed**:
{LIST_OF_FILES_CHANGED}

**Test Coverage**:
{TEST_COVERAGE_SUMMARY}
