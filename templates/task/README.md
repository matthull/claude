---
type: documentation
category: templates
---

# Task Handoff Template System

**Purpose**: Transform abstract guidance principles into actionable, task-specific handoffs with hard gates and checklists.

## Overview

The template system uses a composable architecture:

```
core-task-template.md (always included)
    +
sections/*.md (mixed in based on task type)
    ↓
Generated task handoff (task-specific)
```

## Architecture

### Core Template
- **File**: `core-task-template.md`
- **Usage**: ALWAYS included for every coding task
- **Contains**: Universal sections (metadata, completion gates, success criteria)
- **Technology-agnostic**: Uses variables for tech-specific commands

### Section Templates
- **Location**: `sections/`
- **Usage**: Mixed in based on task requirements
- **Purpose**: Technology/domain-specific patterns, commands, and checklists

**Available Sections**:
- `ruby-rails-code.md` - Rails patterns, RSpec, console verification
- `vue-component.md` - Vue components, Storybook, Vitest
- `api-integration.md` - API contracts, VCR, error handling
- `dependency-modifications.md` - **CRITICAL**: Required when adding methods to existing classes
- `testing.md` - Test scenarios, coverage, debugging
- `manual-qa.md` - QA checklists, verification procedures
- `bug-fix-resolution.md` - Root cause, solution, lessons learned
- `architecture-design.md` - Layer context, integration flows

## Variable System

### Core Variables

**Task Metadata**:
- `{TASK_ID}` - Task identifier (e.g., T001)
- `{DATE}` - Current date
- `{TASK_GOAL}` - High-level objective
- `{STATUS}` - Current status (✅ COMPLETE, 🔄 In Progress, ⏳ Blocked, ❌ MUST FAIL INITIALLY)

**Task Details**:
- `{TASK_DESCRIPTION}` - Detailed task description
- `{FILE_PATH}` - Primary file location
- `{SCOPE_DESCRIPTION}` - Concise scope definition
- `{SCENARIO_1..N}` - Test scenarios
- `{LINK_TO_RESEARCH_DOC}` - Reference documentation

**Context**:
- `{GREP_COMMANDS}` - Quick context grep commands
- `{CAT_COMMANDS}` - Key file display commands
- `{CANONICAL_EXAMPLE_COMMANDS}` - Read commands for canonical examples (exemplar implementations to follow)
- `{LIST_OF_COMPLETED_ITEMS}` - Done items
- `{LIST_OF_UPCOMING_ITEMS}` - Next items
- `{LIST_OF_BLOCKING_ITEMS}` - Blockers
- `{LIST_OF_DEFERRED_ITEMS_WITH_REASONS}` - Deferred with reasons
- `{LIST_OF_DEPENDENCIES}` - Dependencies

**Verification Commands** (technology-specific):
- `{FOCUSED_TEST_COMMAND}` - Loop 1: Single test/component
- `{PROJECT_TEST_COMMAND}` - Loop 2: All project tests
- `{CONSOLE_VERIFICATION_COMMANDS}` - Loop 3: Backend console QA
- `{BROWSER_VERIFICATION_COMMANDS}` - Loop 3: Frontend browser QA

**Success Criteria**:
- `{CRITERION_1..N}` - Checkboxed success criteria

**Completion**:
- `{DATE_COMPLETED}` - Completion timestamp
- `{TEST_STATE_SUMMARY}` - Final test results
- `{SUMMARY_OF_CHANGES}` - Key changes made
- `{LIST_OF_FILES_CHANGED}` - Modified files
- `{TEST_COVERAGE_SUMMARY}` - Test coverage stats

### Section-Specific Variables

Each section template may define additional variables (documented in section template frontmatter).

## Template Composition

### Section Hook System

The core template uses `<!-- SECTION HOOK: ... -->` comments to mark insertion points for section templates:

**Hook 1: Technology-specific patterns** (after Task Details)
- Inserts: `ruby-rails-code.md`, `vue-component.md`, `architecture-design.md`, `bug-fix-resolution.md`
- Provides: Method signatures, test patterns, code examples

**Hook 2: Domain-specific guidance** (after Dependencies)
- Inserts: `api-integration.md`, `testing.md`, `manual-qa.md`
- Provides: Specialized checklists, verification procedures

**Verification Commands**: Technology sections provide variables like `{FOCUSED_TEST_COMMAND}` that are substituted into the core template's Task Completion Gate.

### Composition Rules

1. **Technology sections** → Hook 1 (after Task Details)
   - `ruby-rails-code.md`, `vue-component.md`

2. **Context sections** → Hook 1 (after Task Details)
   - `architecture-design.md`, `bug-fix-resolution.md`

3. **Domain sections** → Hook 2 (after Dependencies)
   - `api-integration.md`, `testing.md`, `manual-qa.md`

4. **Verification commands** → Variable substitution in Task Completion Gate
   - Technology sections define: `{FOCUSED_TEST_COMMAND}`, `{PROJECT_TEST_COMMAND}`, etc.

### Canonical Examples

**Purpose**: Point implementers to exemplar code that demonstrates best practices for specific patterns.

**Concept**: Each project may have "canonical" implementations - well-written examples of common patterns (controllers, services, models, workers) that new code should follow.

**In Ruby/Rails Template** (`sections/ruby-rails-code.md`):
- CRUD Controllers: `app/api/v2/video_link_assets_controller.rb`
- Integration Controllers: `app/api/v2/seismic/teamsites_controller.rb`
- Asset Models: `models/video_link_asset.rb`
- General Models: `models/seismic_integration.rb`
- API Clients: `services/highspot/client.rb`
- General Services: `services/highspot/asset_metadata.rb`
- Async Jobs: `HighspotPublicSyncWorker`

**Usage in Handoffs**:
```bash
# In Quick Context section, add canonical example read commands:
cat app/api/v2/video_link_assets_controller.rb  # CRUD pattern
cat services/highspot/client.rb                  # API client pattern
```

**Instructions**:
1. **Handoff Creator**: Identify which canonical examples apply to the task
2. **Handoff Creator**: Add read commands to `{CANONICAL_EXAMPLE_COMMANDS}`
3. **Task Implementer**: Read canonical examples BEFORE implementing
4. **Task Implementer**: Follow patterns (structure, error handling, naming conventions)

**Benefits**:
- Ensures consistency across codebase
- Accelerates development (proven patterns)
- Reduces architectural decisions (follow established patterns)
- Easier code review (matches known good examples)

### Manual Composition (Current)

1. **Start with core template**:
   ```bash
   cat ~/.claude/templates/task/core-task-template.md
   ```

2. **Insert relevant sections at appropriate SECTION HOOKs**:
   ```bash
   # For Ruby API integration task
   # Hook 1: ruby-rails-code.md
   # Hook 2: api-integration.md, testing.md
   ```

3. **Substitute variables** with actual values

4. **Save to project specs**:
   ```bash
   # Example location
   ~/code/myproject/specs/tasks/T001-feature-name.md
   ```

### Automated Composition (Future)

The `/handoff` command will:
1. Detect task type from description
2. Auto-select relevant section templates
3. Prompt for variable values
4. Generate composed handoff
5. Save to appropriate location

## YAML Frontmatter

All templates use YAML frontmatter for metadata:

**Template Frontmatter**:
```yaml
---
type: task-template
name: template-name
section: section-name  # for section templates
description: What this template provides
applies_to: ruby|vue|api|testing|all
source_guidance:
  global:
    - category/guidance-name
  project:
    - project-name/category/guidance-name
---
```

**Generated Handoff Frontmatter**:
```yaml
---
type: task-handoff
task_id: T001-feature-name
generated_from_templates:
  - core-task-template
  - sections/ruby-rails-code
source_guidance:
  global:
    - testing/test-driven-development
  project:
    - myproject/rails/patterns
---
```

## Source Guidance Backlinks

**Purpose**: Track which guidance files informed each template

**Benefits**:
- Easier refresh when guidance updates
- Audit trail of pattern origins
- Discovery: "What templates use this guidance?"
- Consistency: "Did we update all affected templates?"

**Format**: Best-effort YAML frontmatter (not strictly required, but recommended)

**Discovery Pattern**:
```bash
# Find templates using specific guidance
grep -r "testing/test-driven-development" ~/.claude/templates/task/

# Find handoffs from a template
grep -r "sections/ruby-rails-code" ~/code/*/specs/
```

**Refresh Workflow**:
1. Update guidance file
2. Find affected templates: `grep -r "guidance-name" ~/.claude/templates/task/`
3. Review and update templates
4. Optionally regenerate active handoffs

## Template Creation Guidelines

### Defense-in-Depth Principle (CRITICAL)

**Important guidance MUST appear in BOTH locations**:
1. **Upfront Directives** - At top of template section with MUST NEVER/ALWAYS keywords
2. **Quality Gates** - In checklists that must be verified before task completion

**RATIONALE**: Best-effort compliance with upfront directives, but assume agents will sometimes ignore them. Quality gates provide safety nets during task review.

**Example Pattern**:
```markdown
## CRITICAL: [Constraint Name] (ABSOLUTE)

You MUST NEVER [forbidden action]

**RATIONALE:** [One sentence explaining consequence]

... [rest of template content] ...

### Code Quality Checklist
**Before Completing Task**:
- [ ] **CRITICAL: [Same constraint in checklist form]**
- [ ] Other checks...

### Common Anti-patterns to Avoid
**You MUST NEVER**:
- ❌ **[Same constraint as first item in anti-patterns]**
- ❌ Other anti-patterns...
```

**Triple-Layer Enforcement**:
- **Layer 1**: Top of section (impossible to miss)
- **Layer 2**: Pre-completion checklist (mandatory gate)
- **Layer 3**: Anti-patterns (reinforcement)

### Self-Contained Principle (CRITICAL)

**Templates MUST be self-contained**

**You MUST NEVER**:
- ❌ Use @-references in templates (defeats efficiency purpose)
- ❌ Reference external guidance files
- ❌ Assume other files will be loaded

**ALWAYS**:
- ✅ Include all critical directives inline
- ✅ Provide complete patterns and examples
- ✅ Make templates independently usable

**RATIONALE**: Templates are meant to be efficient, focused guidance. Loading additional files defeats the purpose of the template system.

## Code Guidance Philosophy

**CRITICAL**: Handoffs provide guidance, NOT implementations

**Include**:
- ✅ Method signatures
- ✅ Expected test structure
- ✅ API contracts
- ✅ Pattern references

**NEVER Include**:
- ❌ Complete implementations
- ❌ Pre-written solution code

**Why**: TDD requires writing minimal code to pass tests. Pre-written solutions defeat the purpose.

## Verification Workflow with Task Review

Every task handoff enforces a structured verification workflow:

### Loop 1: TDD Inner Loop
**Purpose**: Focused development on single component/test
**Technology-specific**: Defined in section templates
- Ruby: `bundle exec rspec spec/path/to/file_spec.rb`
- Vue: `npm run storybook` → Browser verification

### Task Review Gate (Between Loop 1 and 2)
**Purpose**: Quality check before project-wide impact
**Command**: `/task-review` (after Loop 1 passes)
**Reviews**: Uncommitted code against task handoff quality gates and guidelines
**Action**: Fix any critical issues before proceeding to Loop 2
**Benefit**: Catches problems early, ensures adherence to standards

### Loop 2: Project-Wide Verification
**Purpose**: Ensure no regressions across entire codebase
**MANDATORY**: Must complete in < 30 seconds before marking task complete
**Technology-specific**: Defined in section templates
- Ruby: `bundle exec rspec`
- Vue: `npm run test`

### Loop 3: Manual QA (OPTIONAL - requires user approval to skip)
**Purpose**: Real-world verification beyond automated tests
**Optional**: May be skipped if unit tests provide 100% confidence AND user approves
**Required for**: Integration work, external APIs, complex business logic, database interactions
**Stop and Ask**: Must request user approval before skipping
**Technology-specific**: Defined in section templates
- Backend: Rails console testing
- Frontend: Browser interaction testing

## Core Mandates Integration

Templates reinforce system-level directives:

- **MUST NEVER** keywords for critical constraints
- **Stop and Ask** protocol when uncertain
- Hard gates (checkboxes) create accountability
- Failure protocols with zero tolerance

## Usage Examples

### Example 1: Ruby API Integration

**Templates to compose**:
- ✅ `core-task-template.md` (always)
- ✅ `sections/ruby-rails-code.md` (Ruby detected)
- ✅ `sections/api-integration.md` (API detected)
- ✅ `sections/testing.md` (default for code tasks)

### Example 2: Vue Component Bug Fix

**Templates to compose**:
- ✅ `core-task-template.md` (always)
- ✅ `sections/vue-component.md` (Vue detected)
- ✅ `sections/bug-fix-resolution.md` (bug fix detected)
- ✅ `sections/manual-qa.md` (default for frontend)

### Example 3: Simple Service Object

**Templates to compose**:
- ✅ `core-task-template.md` (always)
- ✅ `sections/ruby-rails-code.md` (Ruby detected)
- ⚠️ `sections/testing.md` (optional - skip if unit tests provide 100% confidence)

### Example 4: Service with Client Modifications

**Templates to compose**:
- ✅ `core-task-template.md` (always)
- ✅ `sections/ruby-rails-code.md` (Ruby detected)
- ✅ `sections/dependency-modifications.md` (CRITICAL - modifying existing Client class)
- ✅ `sections/api-integration.md` (API calls detected)
- ✅ `sections/testing.md` (comprehensive test coverage needed)

## Next Steps

1. ✅ Core template created
2. ⏳ Create section templates:
   - `sections/ruby-rails-code.md`
   - `sections/vue-component.md`
   - `sections/api-integration.md`
   - `sections/testing.md`
   - `sections/manual-qa.md`
   - `sections/bug-fix-resolution.md`
   - `sections/architecture-design.md`
3. ⏳ Implement `/handoff` command automation
4. ⏳ Test with real tasks
5. ⏳ Validate against historical handoffs

## Related Documentation

- **Implementation Plan**: `~/.claude/research/task-handoff-template-system-plan.md`
- **Guidance Library**: `~/.claude/guidance/`
- **Task Handoff Guidance**: `~/.claude/guidance/documentation/task-handoffs.md`
- **Core Mandates**: `~/.claude/prompts/core-mandates.md`
