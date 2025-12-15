---
description: Generate task list with verification loops from spec documents
allowed-tools: Read, Glob, Grep, Write
argument-hint: '<spec-file-or-pattern> - e.g., "specs/feature.md", "specs/**/*.md"'
---

# /taskout - Task List Generation

Generate a task list from specification documents with closed verification loops.

## Core Principle

**A task is a unit of work that can be verified to gain confidence in it as a building block before proceeding.**

Every task MUST have verification. If you cannot determine how to verify a task, STOP and ask.

## Required Input

**$ARGUMENTS** must specify spec document(s):
- Single file: `specs/001-feature/spec.md`
- Pattern: `specs/001-feature/**/*.md`
- Multiple: `spec.md design.md`

If no arguments provided, report: "Usage: /taskout <spec-file-or-pattern>"

## Process

### 1. Load Guidance

Read the task generation guidance:
`~/.claude/guidance/ai-development/task-generation.md`

### 2. Load Spec Documents

Read all files matching **$ARGUMENTS**.

### 3. Classify Tasks

For each unit of work identified, determine its type and verification approach.

**Roles reminder:** Claude is QA Engineer (all testing), Human is Product Manager (UAT/sign-off).

| Task Type | Claude Verification (QA Engineer) | Human Verification (Product Manager) |
|-----------|-----------------------------------|-------------------------------------|
| **Coding** (produces code) | Tests pass, types check, lint clean, visual verification via tools | UAT: Meets requirements? |
| **Mobile UI** | Unit tests + screenshot verification via Waydroid/ADB | UAT: UX feel, subjective quality |
| **Configuration/Setup** | Commands succeed, smoke tests, behavior verified via tools | UAT: Confirm meets intent |
| **API/Integration** | Tests pass, manual API testing via curl/tools | UAT: End-user flow works |
| **Research/Investigation** | Findings complete, consistent, well-documented | Validate conclusions |
| **Design** | Patterns valid, constraints met, conventions followed | Judge appropriateness |

**Claude owns QA:** Claude completes ALL testing (automated AND "manual" via tools) before handoff. Human does UAT on something already thoroughly tested.

**For coding tasks:** Use TDD - test creation is first implementation step.

**For non-coding tasks:** Specify verification commands or review criteria.

**If verification unclear:** Add a note and ASK in the output summary.

### 4. Generate Task List

Apply these principles:

**Task Scoping:**
- Each task = one verifiable unit of work
- WHAT not HOW (no implementation details)
- Clear acceptance criteria

**Verification (REQUIRED):**
- Every task specifies Claude verification method
- Every task specifies human verification (or "None" if fully automated)
- Verification scales with objectivity (see continuum in guidance)

**Dependencies:**
- Mark true dependencies only
- Note parallel opportunities
- Use consistent markers

**Documentation Links:**
- Reference source doc lines: `Ref: spec.md:45-67`
- Link, don't duplicate

**Final Task - Lessons Integration (REQUIRED):**

**ALWAYS add a "Lessons Integration" task as the final task.** This task reviews learnings from completed handoffs and feeds them back into documentation, plans, skills, and workflows.

This task should:
- Review all task handoff "Implementation Learnings" sections
- Extract patterns worth documenting
- Identify workflow/skill improvements
- Update relevant docs, plans, or templates

The spec's Retrospective section defines what to review - the task executes that review.

### 5. Output Format

```markdown
# Task List: [Feature Name]

**Source:** [spec files read]
**Generated:** [date]

---

## Spec Documents

| Document | Purpose |
|----------|---------|
| [spec.md](./spec.md) | Technical specification |
| [design.md](./design.md) | Architecture and data model |

---

## Phase 1: [Phase Name]

### T001: [Behavior/Outcome Name]

- [ ] [Acceptance criterion 1]
- [ ] [Acceptance criterion 2]
- **Claude verifies:** [Specific verification - tests, commands, review]
- **Human verifies:** [What human checks, or "None"]
- **Ref:** spec.md:XX-YY
- **Dependencies:** None

### T002: [Behavior/Outcome Name]

- [ ] [Acceptance criterion]
- **Claude verifies:** [Verification method]
- **Human verifies:** [Human check]
- **Ref:** spec.md:XX-YY
- **Dependencies:** T001

---

## Phase 2: [Phase Name]

### T003-T005: Parallel Tasks

These tasks can run in parallel.

### T003: [Behavior]
...

---

## Final Phase: Retrospective

### TXXX: Lessons Integration

- [ ] Review all task handoff "Implementation Learnings" sections
- [ ] Extract documentation updates (architecture decisions, patterns, gotchas)
- [ ] Identify project plan updates (scope changes, new constraints)
- [ ] Propose workflow improvements (skills, templates, process)
- [ ] Update relevant docs/plans or create issues for follow-up
- **Claude verifies:** All handoffs reviewed, actionable items captured
- **Human verifies:** Updates are appropriate and complete
- **Ref:** spec.md (Retrospective section)
- **Dependencies:** All other tasks complete

---

## Summary

- **Total tasks:** X
- **Parallel opportunities:** T003-T005, T007-T008
- **Critical path:** T001 → T002 → T006 → T009
- **Verification unclear:** [List any tasks where verification needs clarification]
```

### 6. Verification Review

Before saving, check EVERY task:

- [ ] Has Claude verification specified?
- [ ] Has human verification specified (even if "None")?
- [ ] Is verification actually achievable?

If any task lacks clear verification, note it in the Summary section under "Verification unclear" and ask user for guidance.

### 7. Save Output

Write task list to same directory as first spec file:
- If spec is `specs/001-feature/spec.md` → `specs/001-feature/tasks.md`
- If spec is `feature.md` → `tasks.md`

Report: "Task list written to [path]"

If there are tasks with unclear verification, ask:
"The following tasks need verification clarification: [list]. How should these be verified?"

---

## Examples

### Coding Task (TDD)

```markdown
### T001: User authentication

- [ ] Users can sign up with email/password
- [ ] Users can sign in with valid credentials
- [ ] Invalid credentials return error
- **Claude verifies (QA):** All tests pass, types check, lint clean, flow tested in Waydroid
- **Human verifies (UAT):** Meets auth requirements, UX acceptable
- **Ref:** spec.md:12-34
- **Dependencies:** None
```

### Mobile UI Task

```markdown
### T002: Task list component

- [ ] Component renders task items
- [ ] Tap shows task detail
- [ ] Empty state displays correctly
- **Claude verifies (QA):** Unit tests pass, visual verification via Waydroid screenshot, all states tested
- **Human verifies (UAT):** UX feel, meets design intent
- **Ref:** spec.md:45-60
- **Dependencies:** T001
```

### Configuration Task

```markdown
### T003: Configure ESLint with Prettier

- [ ] ESLint flat config created
- [ ] Prettier integration working
- [ ] Ignores configured correctly
- **Claude verifies (QA):** `npx expo lint` exits 0, `prettier --check` passes, sample file linted
- **Human verifies (UAT):** None (fully automated)
- **Ref:** spec.md:45-60
- **Dependencies:** None
```

### Research Task

```markdown
### T004: Investigate auth provider options

- [ ] Document pros/cons of 3+ providers
- [ ] Identify integration requirements
- [ ] Recommend approach with rationale
- **Claude verifies (QA):** All criteria addressed, internally consistent, well-documented
- **Human verifies (UAT):** Validate recommendation fits project needs
- **Ref:** spec.md:70-85
- **Dependencies:** None
```

### Design Task

```markdown
### T005: Design data sync architecture

- [ ] Define sync boundaries
- [ ] Document conflict resolution strategy
- [ ] Specify offline behavior
- **Claude verifies (QA):** Patterns consistent with project conventions, no obvious gaps
- **Human verifies (UAT):** Architecture appropriate for requirements
- **Ref:** spec.md:90-120
- **Dependencies:** T004
```

### Lessons Integration Task (Final Task - Always Include)

```markdown
## Final Phase: Retrospective

### TXXX: Lessons Integration

- [ ] Review all task handoff "Implementation Learnings" sections
- [ ] Extract documentation updates (architecture decisions, patterns, gotchas)
- [ ] Identify project plan updates (scope changes, new constraints)
- [ ] Propose workflow improvements (skills, templates, process)
- [ ] Update relevant docs/plans or create issues for follow-up
- **Claude verifies:** All handoffs reviewed, actionable items captured
- **Human verifies:** Updates are appropriate and complete
- **Ref:** spec.md (Retrospective section)
- **Dependencies:** All other tasks complete
```

**Note:** Task number (TXXX) should be the next sequential number after all implementation tasks.
