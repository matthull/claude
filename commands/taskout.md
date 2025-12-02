---
description: Generate TDD-focused task list from spec documents
allowed-tools: Read, Glob, Grep, Write
argument-hint: '<spec-file-or-pattern> - e.g., "specs/feature.md", "specs/**/*.md"'
---

# /taskout - Task List Generation

Generate a task list from specification documents using TDD principles.

## Required Input
**$ARGUMENTS** must specify spec document(s):
- Single file: `specs/001-feature/spec.md`
- Pattern: `specs/001-feature/**/*.md`
- Multiple: `spec.md design.md`

If no arguments provided, report: "Usage: /taskout <spec-file-or-pattern>"

## Process

### 1. Load Guidance
Read the TDD task generation guidance:
`~/.claude/guidance/ai-development/tdd-task-generation.md`

### 2. Load Spec Documents
Read all files matching **$ARGUMENTS**.

### 3. Generate Task List
Apply guidance principles:

**Task Scoping:**
- Each task = one verifiable unit of work
- WHAT not HOW (no implementation details)
- Clear acceptance criteria

**TDD Integration:**
- Task names = behaviors (not "write test for X")
- Test creation implied as first step
- Add verification checkpoints (use checkboxes)

**Dependencies:**
- Mark true dependencies only
- Note parallel opportunities
- Use consistent markers

**Framework-Specific (Rails):**
- Routes + controller + jbuilder = ONE task
- Request specs require full stack

**Documentation Flow:**
- Reference source doc lines: `Ref: spec.md:45-67`
- Link, don't duplicate

### 4. Output Format

```markdown
# Task List: [Feature Name]

**Source:** [spec files read]
**Generated:** [date]

## Phase 1: [Phase Name]

### T001: [Behavior Name]
- [ ] [Acceptance criterion 1]
- [ ] [Acceptance criterion 2]
- [ ] Verify: [what to verify]
- **Ref:** spec.md:XX-YY
- **Dependencies:** None

### T002: [Behavior Name]
- [ ] [Acceptance criterion]
- [ ] Verify: [checkpoint]
- **Ref:** spec.md:XX-YY
- **Dependencies:** T001

## Phase 2: [Phase Name]

### T003-T005: [Parallel Tasks]
These tasks can run in parallel.

### T003: [Behavior]
...

## Summary
- Total tasks: X
- Parallel opportunities: T003-T005, T007-T008
- Critical path: T001 -> T002 -> T006 -> T009
```

### 5. Save Output
Write task list to same directory as first spec file:
- If spec is `specs/001-feature/spec.md` -> `specs/001-feature/tasks.md`
- If spec is `feature.md` -> `tasks.md`

Report: "Task list written to [path]"
