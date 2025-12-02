---
type: guidance
status: current
category: ai-development
tags:
- ai-development
- tdd
- task-generation
- project-management
focus_levels:
- strategic
- design
---

# Task List Generation Principles

## Purpose

Task lists decompose features into discrete, verifiable work items. They bridge source documents (specs, PRDs, design docs, etc.) and implementation handoffs.

## Core Principles

### Task Scoping
- Each task = one verifiable unit of work
- Clear acceptance criteria
- Feeds into implementation handoff
- No implementation details

### Task Identification
- Use consistent ID scheme (T001, 1.1, etc.)
- Group related tasks
- Mark parallel opportunities

## Reference Documentation

### Link, Don't Duplicate
```markdown
**Reference:** `grep -n "Component Architecture" design.md` (lines 78-121)
**Reference:** `grep -n "Data Pipeline" spec.md` (lines 685-823)
```

### Documentation Flow
```
Source Docs → Task List → Handoff → Implementation
    ↓            ↓           ↓            ↓
 (WHAT)     (BREAKDOWN)  (DETAILS)    (CODE)
```

### Source Documents Vary
- Could be: requirements.md, spec.md, PRD, design docs
- Could be: user stories, tickets, architecture diagrams
- Task list references whatever exists
- Don't assume specific file names

## Dependencies & Parallelization

### Identify True Dependencies
- Component A needs Component B = dependency
- Components A and B independent = parallel
- Mark only actual blockers

### Parallel Work Markers
- Use consistent marker (e.g., 🔀)
- Group parallel tasks together
- Note task ranges: "T004-T006 can run in parallel"

## TDD Integration

### Task Names Imply Tests
- Name the feature/behavior
- ❌ "Write authentication test"
- ✅ "User Authentication"
- Test creation is first step

### Verification Points
- Add explicit checkpoints
- Use consistent marker (e.g., ✅)
- Specify what to verify, not how

### When Tests Are Separate
- Adding tests to existing code
- Creating regression baselines
- Building test infrastructure

## Handling Existing Code

### When Modifying Existing Components
- Consider regression protection
- Document current behavior first
- Mark backwards compatibility needs

### Pattern Example (Not Required)
```markdown
Task: Enhance Shared Component
- [ ] Document current interface
- [ ] Create regression tests if missing
- [ ] Make enhancement
- [ ] ✅ Verify compatibility
```

## Phase Organization

### Flexible Structure
- Phases group related work
- Number/name as appropriate
- Common patterns:
  - Prerequisites/Setup
  - Core Implementation
  - Integration
  - Polish

### Phase Principles
- Setup tasks often independent
- Core work may parallelize
- Integration needs components
- Polish typically parallel

## Task Format Guidelines

### Essential Elements
- Clear task description
- Dependencies (if any)
- References to source docs
- Verification points

### Optional Elements
- Acceptance criteria
- Risk markers
- Parallel indicators
- Notes on complexity

## What Doesn't Belong

### Leave for Handoffs
- Implementation patterns
- Code examples
- Detailed test scenarios
- Technical approach
- File structures

### Keep Abstract
- WHAT not HOW
- Behavior not implementation
- Requirements not solutions

## Examples

### Simple Task
```markdown
Task: Rate Limiting
- Implement rate limits per spec
- ✅ Verify limits enforced
- Ref: api-spec.md lines 45-67
```

### Task with Dependencies
```markdown
Task: Integration Flow
- Connect components A, B, C
- ✅ Verify data flows correctly
- Dependencies: Components A, B, C complete
```

### Parallel Tasks
```markdown
Tasks (can parallelize):
- T001: Component A
- T002: Component B
- T003: Component C
```

## Adaptation Guidelines

### Project Context Matters
- Adapt format to project needs
- Use existing ID schemes
- Follow team conventions
- Reference actual documents

### Scale Appropriately
- Simple feature = simple list
- Complex system = detailed phases
- Match detail to complexity

## Framework-Specific Patterns

### Rails API Endpoint Tasks
Routes + jbuilder + controller = ONE task
- Request specs require all three
- Can't test controller without route
- Can't verify response without view

```markdown
# ❌ WRONG: Separate tasks
T009: Add routes
T010: Create controller
T011: Create jbuilder view

# ✅ CORRECT: Single task
T009: Create engagements_over_time endpoint (TDD)
- Route: GET /app/api/v2/usage_dashboard/engagements_over_time
- Controller: EngagementsOverTimeController#index
- View: index.json.jbuilder
- Request specs test the full stack
```

## Common Patterns

### Enhancement Pattern
When changing existing code:
1. Understand current behavior
2. Protect against regression
3. Make changes
4. Verify compatibility

### Greenfield Pattern
New implementation:
1. Start with simplest case
2. Build incrementally
3. Add complexity gradually
4. Integrate components

### Investigation Pattern
When requirements unclear:
1. Research/spike tasks first
2. Document findings
3. Then implementation tasks

## Anti-Patterns

### Over-Specification
- Implementation details in tasks
- Rigid phase structures
- Assuming specific files exist
- Prescriptive numbering

### Under-Specification
- "Implement feature" (too vague)
- Missing verification points
- No references to source
- Hidden dependencies

### False Structure
- Phases for single tasks
- Unnecessary hierarchy
- Fake dependencies
- Over-complex IDs