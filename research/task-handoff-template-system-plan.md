# Task Handoff Template System - Implementation Plan

Date: 2025-10-08
Based on: Gemini analysis of 20+ historical task handoffs from Seismic integration project

**Latest Update**: 2025-10-08 - Refined plan based on implementation feedback

## Key Refinements in This Version

1. **YAML Frontmatter for Metadata**: Use structured frontmatter instead of HTML comments for all source tracking and template composition metadata
2. **Code Snippets ≠ Implementations**: Explicitly clarified that handoffs provide guidance (signatures, patterns) NOT complete implementations
3. **Simplified Header**: Removed branch/timeline/verifier metadata for single-session tasks (git provides this context)
4. **Technology-Agnostic Core Template**: Moved technology-specific verification commands to section templates
5. **Three-Loop Verification**: Added Loop 3 (Manual QA) for console/browser verification alongside TDD loops
6. **Frontend Support**: Added `vue-component.md` section template with Storybook/Vitest patterns
7. **Core Mandates Integration**: Incorporated Stop and Ask protocol and MUST NEVER keywords from system directives
8. **Default Testing Inclusion**: Made `testing.md` the default (skip only for pure unit-testable code)

## Executive Summary: What We're Building and Why

### The Problem

Claude Code's guidance system currently has a **distribution problem**:

1. **Guidance lives in abstract files**: Principles like "always verify interfaces" and "never skip tests" exist in markdown files as prose
2. **Loading is all-or-nothing**: We load entire guidance files via @-references, consuming 1000s of tokens for principles that may only partially apply
3. **Format mismatch**: Abstract principles don't translate well to task execution—developers need checklists and gates, not philosophy
4. **Weak enforcement**: Reading "you should test" is psychologically weaker than checking a box that says "[ ] All tests passing"
5. **Inconsistent application**: Without structure, guidance application varies by task and context

**Result**: We've created excellent guidance (principles, patterns, best practices) but struggle to deliver it effectively at the moment of task execution.

### What We're Building

A **multi-channel guidance dissemination system** that transforms abstract principles into task-specific, actionable formats.

**The Architecture**:
```
Guidance Library (source of truth)
    ↓
Multiple Distribution Channels
    ├─→ Task Templates → Generated Handoffs (FIRST FOCUS)
    ├─→ Code Review Subagents (project-specific)
    ├─→ GitHub Actions (CI/CD enforcement)
    ├─→ Architect Subagents (design decisions)
    └─→ [Future channels...]
```

**This Plan Focuses On**: Task handoff templates as the first channel to implement. Once proven, the same transformation patterns apply to other channels.

**Core Innovation**: Same principle, different format for different contexts:
- **System Prompt**: "You MUST NEVER skip tests" (behavioral constraint)
- **Guidance File**: "Testing discipline ensures code quality" (abstract principle)
- **Task Template**: "[ ] All tests passing before completion" (hard gate)
- **Code Review Subagent**: "Check: All tests passing? If no, flag as [BLOCKING]" (automated check)
- **GitHub Action**: `if tests_failing: block_merge()` (CI enforcement)

### Why This Matters

**1. Contextual Precision**
- Load only what's needed: Ruby template for Ruby tasks, not entire Rails guide
- **Token savings**: 60-80% reduction vs. loading full guidance files

**2. Psychological Effectiveness**
- Checkboxes create commitment: Harder to skip "[ ] Tests passing" than ignore prose
- Gates create hard stops: Can't mark complete without checking boxes
- Structured accountability: Clear what "done" means

**3. Composability**
- Mix and match: Core template + Ruby + API + Testing for a Rails API task
- Extensible: Add new sections (Vue, Docker, Security) as needed
- Project-specific: Override global templates with local patterns

**4. Consistency**
- Every handoff has same structure
- Every task has mandatory gates
- Every completion has verification requirements

**5. Guidance Leverage**
- Write guidance once, disseminate through multiple channels
- System prompt for enforcement, templates for execution, subagents for review, CI for automation
- Each channel optimized for its purpose and context
- Foundation for future channels (security scanners, onboarding bots, etc.)

### Key Insight: Format Optimization

Not all guidance should be delivered the same way:

| Channel | Format | Use Case | Example |
|---------|--------|----------|---------|
| **System Prompt** | Behavioral directives | Non-negotiable constraints | "You **MUST NEVER** skip tests" |
| **Guidance Files** | Principles & patterns | On-demand knowledge | "TDD cycle: RED-GREEN-REFACTOR" |
| **Task Templates** (FIRST) | Checklists & gates | Procedural application | "[ ] Loop 2 verification passing" |
| **Generated Handoffs** (FIRST) | Complete task specs | Active work guidance | Composed template with all details filled in |
| **Code Review Subagent** (FUTURE) | Automated checks | PR review enforcement | Check tests passing, flag as [BLOCKING] if failing |
| **GitHub Action** (FUTURE) | CI/CD rules | Merge gate enforcement | `if tests_failing: block_merge()` |
| **Architect Subagent** (FUTURE) | Decision framework | Design guidance | "Pattern detected: Consider service object" |

**The Transformation**:
```
Guidance: "You must verify functionality after each change"
    ↓
Template: "## QA Testing Checklist
           [ ] Unit tests passing
           [ ] Integration tests passing
           [ ] Manual verification complete
           [ ] User confirmation (if needed)"
    ↓
Handoff: "## QA Testing Checklist
          [✓] Unit tests passing (15 examples, 0 failures)
          [✓] Integration tests passing (3 examples, 0 failures)
          [ ] Manual verification: Test property assignment in Seismic UI
          [ ] User confirmation: @user please verify in staging"
```

### Success Criteria

We'll know this works when:
1. **Zero tasks completed with failing tests** (gates work)
2. **60-80% token reduction** on handoff loading (precision works)
3. **100% handoff consistency** (templates work)
4. **Faster task completion** (checklists work)
5. **Easier onboarding** (structure works)

### Why Task Handoffs First?

1. **Proven Pattern**: Historical handoffs from Seismic project show this structure works
2. **Immediate Value**: Every coding task needs a handoff—high usage frequency
3. **Clear Scope**: Well-defined input/output makes it easier to validate
4. **Foundation for Other Channels**: Lessons learned apply to subagents, actions, etc.

Once task templates prove effective, we'll apply the same transformation patterns to:
- **Code Review Subagent**: Transform code quality guidance → review checklist
- **GitHub Action**: Transform testing discipline → CI/CD enforcement rules
- **Architect Subagent**: Transform architecture guidance → design decision framework
- **Security Scanner**: Transform security guidance → vulnerability detection rules

### Traceability: Backlinking to Source Guidance

**Principle**: All downstream channels should backlink to the original guidance used to build them.

**Why**:
- Makes refreshing easier when upstream guidance changes
- Provides audit trail of where patterns came from
- Enables discovery: "What templates use this guidance?"
- Supports consistency: "Did we update all downstream channels?"

**Backlink Format** (YAML frontmatter):
```yaml
---
type: task-template  # or 'task-handoff' for generated handoffs
source_guidance:
  global:
    - testing/test-driven-development
    - code-quality/immediately-runnable-code
  project:
    - musashi/rails/service-objects
---
```

**Key Design Decisions**:
1. **Source indicator only**: "Global" or "Project(project-name)" - no file paths
2. **Guidance name**: Category/filename without `.md` extension
3. **Best-effort maintenance**: Not strictly required, but recommended
4. **Avoid brittle links**: Don't use absolute paths that break when files move

**Example in Template**:
```markdown
---
type: task-template
section: ruby-rails-code
source_guidance:
  global:
    - testing/test-driven-development
    - code-quality/code-review-principles
    - development-process/tdd-human-review-cycle
---

# Ruby/Rails Code Section Template

## RSpec Test Structure
...
```

**Example in Generated Handoff**:
```markdown
---
type: task-handoff
task_id: T001-seismic-property-assignment
generated_from_templates:
  - core-task-template
  - sections/ruby-rails-code
  - sections/api-integration
  - sections/testing
source_guidance:
  global:
    - testing/test-driven-development
    - architecture/api-integration
  project:
    - musashi/rails/seismic-patterns
---

# Task Handoff: T001-seismic-property-assignment
```

**Discovery Pattern**:
```bash
# Find all templates using a specific guidance
grep -r "testing/test-driven-development" ~/.claude/templates/

# Find all generated handoffs from a template
grep -r "sections/ruby-rails-code" ~/code/*/specs/
```

**Refresh Workflow** (when guidance updates):
1. Guidance file updated: `testing/test-driven-development.md`
2. Find downstream templates: `grep -r "testing/test-driven-development" ~/.claude/templates/`
3. Review and update affected templates
4. Optionally regenerate active handoffs (or note for next generation)

**Non-Goals**:
- Automatic updates (too complex, risk of mistakes)
- Strict enforcement (best-effort is enough)
- Bidirectional links (guidance doesn't need to know about templates)
- Version tracking (git handles this)

### Why Now?

We've just created `core-mandates.md` (system prompt enforcement) and cleaned up the guidance library. This is the natural next step: **take those principles and structure them for effective delivery at point of use**.

Task handoffs are the first channel, but not the only one.

## Architecture Overview

**Flow**: Guidance (abstract principles) → Templates (structured checklists) → Generated Handoffs (per-task)

**Key Insight**: Different channels need different formats. Abstract guidance needs to be transformed into actionable checklists with hard gates for effective task execution.

## Template Structure

```
~/.claude/templates/
├── core-task-template.md          # Universal coding task (ALWAYS included)
├── sections/                       # Composable domain-specific sections
│   ├── ruby-rails-code.md         # Rails patterns, RSpec, console verification
│   ├── vue-component.md           # Vue components, Storybook, Vitest
│   ├── api-integration.md         # API contracts, VCR, error handling
│   ├── testing.md                 # Test scenarios, coverage, debugging
│   ├── manual-qa.md               # QA checklists, verification procedures
│   ├── bug-fix-resolution.md      # Root cause, solution, lessons learned
│   └── architecture-design.md     # Layer context, integration flows
└── README.md                       # Template usage guide
```

## Core Template Components

**CRITICAL: Code Guidance Format**
Task handoffs provide guidance, NOT implementations:
- ✅ Method signatures and interfaces
- ✅ Expected test structure
- ✅ API contracts and data shapes
- ✅ Code pattern references
- ❌ **NEVER complete implementations** - defeats TDD purpose
- ❌ **NEVER pre-written solution code** - must write minimal code to pass tests

Based on analysis of historical handoffs, these sections appear in 80%+ of tasks:

### 1. Header/Metadata
```markdown
**Task ID**: {TASK_ID} | **Date**: {DATE}
**Goal**: {TASK_GOAL}
**Status**: {STATUS} (e.g., ✅ COMPLETE, 🔄 In Progress, ⏳ Blocked, ❌ MUST FAIL INITIALLY)
```

**Note**: Single-session tasks don't need branch tracking (implicit in git) or timeline estimates. Completion timestamp and verification are captured by git commit.

### 2. Quick Context
```markdown
## Quick Context
```bash
# Load ONLY relevant sections
{GREP_COMMANDS}

# Key files
{CAT_COMMANDS}
```
```

**Note**: Verification commands are technology-specific (defined in section templates like `ruby-rails-code.md` or `vue-component.md`).

### 3. Current State
```markdown
## Current State
- **Done**: {LIST_OF_COMPLETED_ITEMS}
- **Next**: {LIST_OF_UPCOMING_ITEMS}
- **Blocked**: {LIST_OF_BLOCKING_ITEMS}
- **Deferred**: {LIST_OF_DEFERRED_ITEMS_WITH_REASONS}
```

### 4. Task Details
```markdown
### {TASK_ID}: {TASK_NAME}
**Location**: {FILE_PATH}
**Scope**: {SCOPE_DESCRIPTION}
**Test Scenarios**:
- {SCENARIO_1}
- {SCENARIO_2}
...
**Reference**: {LINK_TO_RESEARCH_DOC}
```

### 5. Dependencies
```markdown
## Dependencies
{LIST_OF_DEPENDENCIES}
```

### 6. Task Completion Gate (MANDATORY)
```markdown
## Task Completion Gate (MANDATORY)

### Loop 1: TDD Inner Loop
```bash
{FOCUSED_TEST_COMMAND}
```
**Technology-specific examples**:
- **Backend (Ruby)**: `bundle exec rspec spec/services/foo_spec.rb`
- **Frontend (Vue)**: `npm run storybook` → Verify component in browser

### Loop 2: Project-Wide Verification
```bash
{PROJECT_TEST_COMMAND}
```
**MANDATORY before marking ANY task complete - must complete in < 30 seconds**

**Technology-specific examples**:
- **Backend (Ruby)**: `bundle exec rspec` or `./specs/{PROJECT}/verify-specs.sh`
- **Frontend (Vue)**: `npm run test` or `vitest`
- **Python**: `pytest`
- **Go**: `go test ./...`

### Loop 3: Manual QA
**Backend**: Rails console verification
```bash
rails console
# Test the actual service/method with real data
{CONSOLE_VERIFICATION_COMMANDS}
```

**Frontend**: Browser verification
```bash
npm run dev
# Browser: Navigate to affected UI
# Verify: {MANUAL_VERIFICATION_STEPS}
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
```

### 7. Success Criteria
```markdown
## Success Criteria
- [ ] {CRITERION_1}
- [ ] {CRITERION_2}
...
```

### 8. Completion Summary
```markdown
## Completion Summary
**Date Completed**: {DATE_COMPLETED}
**Final Test State**: {TEST_STATE_SUMMARY}
**Key Changes**: {SUMMARY_OF_CHANGES}
**Files Changed**: {LIST_OF_FILES_CHANGED}
**Test Coverage**: {TEST_COVERAGE_SUMMARY}
```

## Composable Sections

Domain-specific patterns that get mixed in based on task requirements:

### ruby-rails-code.md
**When to include**: Any task involving Ruby/Rails code

**Contains**:
- Method signature patterns
- RSpec test structure (describe, context, it blocks)
- Loop 1 command: `bundle exec rspec spec/path/to/file_spec.rb`
- Loop 2 command: `bundle exec rspec` or `./specs/{PROJECT}/verify-specs.sh`
- Loop 3: Rails console verification steps
- Test data setup patterns
- Code quality checklist (RuboCop, style)
- Expected test code examples

**Example patterns from historical handoffs**:
```ruby
# Method Signature
def self.extract_metadata(asset)

# Implementation Pattern
case self when FileAsset ...

# Test Data Setup
let(:testimonial) do ... end

# Expected Test
describe 'ClassName' do
  context 'when condition' do
    it 'behavior' do
      expect(result).to ...
    end
  end
end
```

### vue-component.md
**When to include**: Any task involving Vue components or frontend development

**Contains**:
- Component structure patterns
- Loop 1 command: `npm run storybook` → Browser verification at `http://localhost:6006`
- Loop 2 command: `npm run test` or `vitest`
- Loop 3: Browser manual QA steps (`npm run dev`)
- Component props and events specification
- Vitest/Testing Library test patterns
- Storybook stories structure
- CSS/styling guidelines
- Accessibility checklist

### api-integration.md
**When to include**: Any task involving external API calls

**Contains**:
- API contract specification (endpoint, method, body, response, status)
- VCR cassette requirements and evidence
- API integration point checklist
- Error handling patterns (409 Conflict, 404 Not Found, 401 Unauthorized)
- Stubbing/mocking patterns
- API discovery documentation template

**Example patterns**:
```markdown
## API Contract
**Endpoint**: PUT /api/v2/seismic/integrations
**Body**: { ... }
**Response**: { ... }
**Status**: 200

## VCR Cassette Evidence
Path: spec/vcr_cassettes/seismic/...

## Error Handling
- 409 Conflict: Upsert pattern
- 404 Not Found: Resource creation
- 401 Unauthorized: Token refresh
```

### testing.md
**When to include**: Default for most code tasks (recommended)

**Include for**:
- API integrations (VCR, mocking, error scenarios)
- UI changes (manual QA required)
- Complex business logic (multiple test scenarios)
- Bug fixes (regression tests needed)

**Skip only when**:
- Pure service objects with no external dependencies
- Simple data transformations (unit tests provide 100% confidence)
- Configuration-only changes

**Contains**:
- Detailed test scenario descriptions
- Test coverage summary (before/after counts)
- Test improvements checklist
- Debugging approach (layered testing strategy)
- Test quality patterns

**Example patterns**:
```markdown
## Test Coverage Summary
Before: X examples, Y failures
After: X examples, 0 failures

## Test Improvements
- Reduced over-mocking
- Removed redundant test context
- Added integration test coverage

## Debugging Approach
1. Test in Rails console
2. Test service layer in isolation
3. Test controller with integration test
```

### manual-qa.md
**When to include**: UI changes, user-facing features, complex workflows

**Contains**:
- Manual QA gate checklist
- Step-by-step test procedure
- UI element verification checklist
- QA findings documentation template
- Screenshots/evidence requirements

**Example patterns**:
```markdown
## Manual QA Gate
- [ ] UI renders correctly
- [ ] User flow completes successfully
- [ ] Error states handled gracefully
- [ ] Data persists correctly

## Test Procedure
1. Navigate to X
2. Click Y
3. Verify Z appears
4. Check database for expected records
```

### bug-fix-resolution.md
**When to include**: Bug fixes, production issues, incident responses

**Contains**:
- Executive summary (Problem, Root Cause, Solution, Verification)
- Resolution summary checklist
- Technical details (What Was Wrong, What Was Fixed)
- Lessons learned template
- Investigation notes archive
- Task closure checklist

**Example patterns**:
```markdown
## Executive Summary
**Problem**: {ISSUE_DESCRIPTION}
**Root Cause**: {ROOT_CAUSE_ANALYSIS}
**Solution**: {FIX_DESCRIPTION}
**Verification**: {PROOF_IT_WORKS}

## Lessons Learned
**Testing Best Practices**:
- {LESSON_1}

**API Integration Patterns**:
- {LESSON_2}

**Development Workflow**:
- {LESSON_3}
```

### architecture-design.md
**When to include**: New services, refactoring, architectural changes

**Contains**:
- Architectural context (Layer, Responsibility, Why This Exists)
- Integration flow diagram/description
- Key patterns documentation
- Inputs/Outputs specification
- Design decisions and rationale

**Example patterns**:
```markdown
## Architectural Context
**Layer**: {LAYER_NAME}
**Responsibility**: {WHAT_IT_DOES}
**Why This Exists**: {RATIONALE}
**Inputs**: {INPUT_SPEC}
**Outputs**: {OUTPUT_SPEC}

## Integration Flow
1. {STEP_1}
2. {STEP_2}
...

## Key Patterns
- {PATTERN_1_DESCRIPTION}
- {PATTERN_2_DESCRIPTION}
```

## Template Variables

Complete list of variables identified from historical handoffs:

### Task Metadata
- `{TASK_ID}` (e.g., T001)
- `{DATE}`
- `{TASK_GOAL}`
- `{STATUS}` (e.g., ✅ COMPLETE, 🔄 In Progress, ⏳ Blocked)

### Code Locations
- `{FILE_PATH}`
- `{METHOD_SIGNATURE}`
- `{CODE_SNIPPET_BEFORE}`
- `{CODE_SNIPPET_AFTER}`

### Test Specifications
- `{SCOPE_DESCRIPTION}`
- `{LIST_OF_TEST_SCENARIOS}`
- `{EXPECTED_TEST_CODE}`
- `{TEST_DATA_SETUP_CODE}`
- `{TDD_INNER_LOOP_COMMAND}`
- `{TEST_COUNT_BEFORE}`
- `{TEST_COUNT_AFTER}`

### Verification
- `{FOCUSED_TEST_COMMAND}` (Loop 1: TDD inner loop)
- `{PROJECT_TEST_COMMAND}` (Loop 2: Project-wide verification)
- `{CONSOLE_VERIFICATION_COMMANDS}` (Loop 3: Backend manual QA)
- `{MANUAL_VERIFICATION_STEPS}` (Loop 3: Frontend manual QA)
- `{GREP_COMMANDS}` (Quick context)
- `{CAT_COMMANDS}` (Quick context)

### API Integration
- `{API_ENDPOINT}`
- `{API_BODY_EXAMPLE}`
- `{API_RESPONSE_EXAMPLE}`
- `{API_STATUS_CODE}`
- `{VCR_CASSETTE_PATH}`

### Architecture
- `{LAYER_NAME}`
- `{LAYER_RESPONSIBILITY}`
- `{LAYER_INPUTS}`
- `{LAYER_OUTPUTS}`
- `{INTEGRATION_FLOW_DESCRIPTION}`
- `{KEY_PATTERN_DESCRIPTION}`

### Documentation
- `{REFERENCE_LINK}`
- `{LESSONS_LEARNED_TEMPLATE}`
- `{ANTI_PATTERN_DESCRIPTION}`
- `{CODE_CHANGES_SUMMARY}`
- `{NEXT_PHASE_DESCRIPTION}`

### UI/QA
- `{SEISMIC_UI_PROPERTIES_LIST}`

## Effective Structures (From Historical Analysis)

### What Worked Well

1. **Checklist Formats**: Extensively used for Success Criteria, Quality Checklists, QA Checklists
   - Forces explicit verification
   - Harder to skip than prose
   - Clear completion criteria

2. **Verification Scripts**: Explicitly defined and mandated
   - `./specs/001-seismic-integration/verify-specs.sh`
   - Automated project-wide test execution
   - Consistent across all tasks

3. **Before/After Commit Gates**:
   - "MANDATORY before marking ANY task complete"
   - "MUST FAIL INITIALLY" for TDD red phase
   - "MAKES T028 PASS" for TDD green phase

4. **Three-Loop Verification Structure**:
   - Loop 1: TDD Inner Loop (focused test/component development)
   - Loop 2: Project-Wide Verification (all automated tests)
   - Loop 3: Manual QA (console/browser verification)
   - Clear separation of concerns and technology-specific implementations

5. **Code Snippets with Line Ranges**:
   - `cat app/services/seismic/client.rb | sed -n '296,350p'`
   - Provides precise context without overwhelming

6. **Grep Commands for Quick Context**:
   - `git grep "TODO(seismic-qa)"`
   - Fast navigation to relevant code

7. **Failure Protocol**: Clear instructions when tests fail
   - FAILING SPECS = INCOMPLETE TASK
   - FIX IMMEDIATELY
   - NO EXCEPTIONS

8. **Anti-patterns Section**: Explicitly listing what NOT to do
   - Prevents common mistakes
   - Reinforces best practices

9. **Expected Test Sections**: Full RSpec code examples
   - Reduces ambiguity
   - Accelerates TDD red phase

## Recommended Improvements

Based on Gemini's analysis of historical handoffs:

### 1. Automate Quick Context Generation
**Current**: Manual grep/cat commands
**Improvement**: Dynamically generate based on Location variables

### 2. Standardize Location Format
**Current**: Varies between handoffs
**Improvement**: Always use `file_path:line_start-line_end`

### 3. Explicit Expected Failure Messages
**Current**: Generic "test should fail"
**Improvement**: "Expected to raise `SomeError`", "Expected `metadata` to include `key`"

### 4. Integrate Code Quality Checklist into Completion Gate
**Current**: Sometimes separate, sometimes missing
**Improvement**: Mandatory checkboxes in completion gate

### 5. Standardize Anti-patterns Section
**Current**: Ad-hoc, inconsistent
**Improvement**: Standard section in core template or lessons learned

### 6. Mandatory Files Changed Summary
**Current**: Sometimes missing
**Improvement**: Always include clear list of modified files

### 7. Mandatory Test Coverage Summary
**Current**: Inconsistent
**Improvement**: Always include before/after counts and test types

### 8. Architectural Context for All Tasks
**Current**: Only on architectural tasks
**Improvement**: Even small tasks benefit from system context

### 9. Clearer Scope Definitions
**Current**: Sometimes vague
**Improvement**: Always concise, actionable, clear boundaries

### 10. Guidance for verify-specs.sh
**Current**: Assumed to exist
**Improvement**: Provide default script or creation instructions

## Implementation Steps

### Phase 1: Core Infrastructure
1. Create `~/.claude/templates/` directory
2. Write `core-task-template.md` with all 8 universal sections
3. Add source guidance backlinks to template (HTML comments)
4. Write template `README.md` with usage guide
5. Define variable substitution system
6. Document backlinking convention in README

### Phase 2: Composable Sections
7. Create `sections/ruby-rails-code.md` (with backlinks)
8. Create `sections/vue-component.md` (with backlinks)
9. Create `sections/api-integration.md` (with backlinks)
10. Create `sections/testing.md` (with backlinks)
11. Create `sections/manual-qa.md` (with backlinks)
12. Create `sections/bug-fix-resolution.md` (with backlinks)
13. Create `sections/architecture-design.md` (with backlinks)

### Phase 3: Command Integration
14. Update `/handoff` command to:
    - Auto-detect task type from description
    - Load core template + relevant sections
    - Substitute variables
    - Generate composed handoff with backlinks
15. Add template selection logic
16. Ensure backlinks propagate from templates to generated handoffs
17. Test with real task

### Phase 4: Validation
18. Generate handoff for existing task
19. Compare to historical handoffs
20. Verify backlinks are present and correct
21. Refine templates based on gaps
22. Test refresh workflow (update guidance → find templates → update)
23. Document lessons learned

## Benefits Over Current Approach

| Current | Proposed |
|---------|----------|
| Load full guidance files via @-references | Compose contextual templates |
| Bulk loading (~1000s of tokens) | Precise loading (only what's needed) |
| Abstract principles | Actionable checklists |
| Hope Claude follows them | Hard gates (must check boxes) |
| Manual composition | Automated composition |
| Inconsistent structure | Standardized structure |

**Token Savings**: Estimated 60-80% reduction vs full guidance loading

**Effectiveness**: Checklists create psychological commitment vs. reading prose

## Usage Examples

### Example 1: Ruby API Integration Task

**User**: `/handoff implement Seismic property assignment with Rails service`

**System detects**:
- Task type: API integration
- Technologies: Ruby, Rails, API

**Loads**:
- ✓ `core-task-template.md` (always)
- ✓ `sections/ruby-rails-code.md` (detected: Ruby/Rails)
- ✓ `sections/api-integration.md` (detected: API)
- ✓ `sections/testing.md` (default for code tasks)

**Generates**: Handoff with all 4 sections composed

### Example 2: Vue Component Bug Fix

**User**: `/handoff fix rendering bug in SeismicFolderSelector component`

**System detects**:
- Task type: Bug fix
- Technologies: Vue, Frontend

**Loads**:
- ✓ `core-task-template.md` (always)
- ✓ `sections/vue-component.md` (detected: Vue)
- ✓ `sections/bug-fix-resolution.md` (detected: bug fix)
- ✓ `sections/manual-qa.md` (default for frontend)

**Generates**: Handoff with all 4 sections composed

### Example 3: Database Migration

**User**: `/handoff add custom_properties table with indexes`

**System detects**:
- Task type: Database change
- Technologies: Database, Migration

**Loads**:
- ✓ `core-task-template.md` (always)
- ✓ `sections/database-migration.md` (detected: database)
- ✓ `sections/ruby-rails-code.md` (project default)
- ✓ `sections/testing.md` (default for code tasks)

**Generates**: Handoff with all 4 sections composed

## Success Metrics

1. **Token Efficiency**: Handoffs use 60-80% fewer tokens than full guidance
2. **Completion Rate**: Tasks marked complete have all checkboxes checked
3. **Test Discipline**: Zero tasks completed with failing tests
4. **Consistency**: All handoffs follow same structure
5. **Time to Handoff**: Generated in seconds vs. manual composition

## Next Steps

1. Create directory structure
2. Draft core template (highest priority)
3. Draft 2-3 most common sections (Ruby, API, Testing)
4. Test manual composition with real task
5. Validate against historical handoffs
6. Iterate based on findings
7. Implement automated composition
8. Roll out to projects

## Related Files

- Historical handoffs: `~/code/musashi/specs/001-seismic-integration/task-handoffs/`
- Gemini analysis: (in this conversation)
- Core mandates: `~/.claude/prompts/core-mandates.md`
- Guidance library: `~/.claude/guidance/`
- Task handoff guidance: `~/.claude/guidance/documentation/task-handoffs.md`
