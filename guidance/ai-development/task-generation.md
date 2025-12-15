---
type: guidance
status: current
category: ai-development
tags:
- ai-development
- task-generation
- verification
- project-management
focus_levels:
- strategic
- design
---

# Task Generation Principles

## Core Definition

**A task is a unit of work that can be verified to gain confidence in it as a building block before proceeding.**

If a task cannot be verified, it is not a valid task. Break it down until verification is possible.

---

## Roles in the Workflow

**Clear role separation maximizes efficiency and ensures thorough testing.**

### Claude: QA Engineer

Claude is responsible for **all testing** before handoff to human:

- **Automated testing** - Unit tests, component tests, integration tests, E2E tests
- **"Manual" testing via tools** - Visual verification via Waydroid/ADB screenshots, browser automation, API testing, console verification
- **Full QA matrix execution** - All test scenarios, edge cases, error states
- **Documentation** - Issues found and fixed, verification evidence

**Claude hands off only when the feature is thoroughly tested and verified.**

### Human: Product Manager

Human receives a **thoroughly tested feature** and provides:

- **User Acceptance Testing (UAT)** - Does it meet product requirements?
- **Final sign-off** - Approve for release
- **Exploratory testing** (optional) - Edge cases Claude might have missed
- **Product judgment** - Subjective UX evaluation, business priority decisions

**Human should NOT be the first line of QA.** They receive something that already works.

### Why This Matters

- **Efficiency**: Claude can run through a QA matrix much faster than human
- **Thoroughness**: Claude won't skip edge cases due to time pressure
- **Focus**: Human attention is reserved for high-value judgment calls
- **Quality**: Two-stage testing (Claude QA → Human UAT) catches more issues

---

## The Verification Continuum

Verification responsibility exists on a spectrum from fully objective to fully subjective. Claude (as QA Engineer) always maximizes verification contribution using available tools.

| Task Type | Claude Verification (QA Engineer) | Human Verification (Product Manager) |
|-----------|-----------------------------------|-------------------------------------|
| Pure function (clear I/O, no side effects) | 100% - automated tests prove correctness | None needed |
| Code with side effects | 95% - tests, types, lint, visual verification via tools | UAT: Confirm meets requirements |
| Mobile UI components | 90% - unit tests + screenshot verification via Waydroid/ADB | UAT: UX feel, subjective quality |
| Configuration/setup | 95% - commands succeed, output checked, smoke tests | UAT: Confirm behavior matches intent |
| API integrations | 90% - automated tests + manual API testing via tools | UAT: End-user flow validation |
| Research/investigation | Review findings for completeness, consistency | Validate conclusions match needs |
| Technical design | Sanity check patterns, constraints, conventions | Judge appropriateness for project |
| UX/product design | Flag issues, check constraints, verify implementation | Primary judgment on UX quality |
| Business requirements | Check consistency, completeness, conflicts | Define and validate intent |

**Key principles:**

1. **Claude owns QA** - Claude is the QA Engineer. All testing (automated AND "manual") happens before human sees the feature.

2. **"Manual" testing via tools** - Claude uses Waydroid/ADB, browser automation, API clients, console verification, etc. Human does NOT do traditional manual QA.

3. **Human does UAT, not QA** - Human validates product requirements are met, not that the code works. The code should already work.

4. **Verification scales with tooling** - Claude's verification percentage increases as more tools become available (Waydroid, Maestro, browser MCP, etc.).

---

## Verification Methods by Task Type

### Coding Tasks: TDD

For tasks that produce code, use Test-Driven Development:

1. Write failing test that captures the requirement
2. Write minimal code to pass the test
3. Run tests - Claude verifies they pass
4. Human reviews if needed (spot-check, integration concerns)

**Task names imply tests:**
- Name the behavior, not the test
- "User Authentication" not "Write authentication test"
- Test creation is the first implementation step

### Configuration/Setup Tasks: Command Verification

For tasks that configure tools, install dependencies, or set up infrastructure:

1. Execute the configuration commands
2. Run verification commands (lint passes, app starts, etc.)
3. Claude confirms commands succeed with expected output
4. **Claude verifies behavior via tools** (screenshot in Waydroid, browser automation, etc.)
5. Human does UAT if needed (confirm setup meets intent)

**Example verification:**
```
- [ ] Run `npx expo start` → Metro bundler starts
- [ ] Run `npx tsc --noEmit` → Exit 0, no type errors
- [ ] Claude: Take screenshot in Waydroid, verify app renders
- [ ] Human UAT: Confirm setup meets requirements (if needed)
```

### Research/Investigation Tasks: Findings Review

For tasks that gather information or investigate problems:

1. Conduct research, document findings
2. Claude reviews for completeness (all questions addressed?)
3. Claude checks for internal consistency
4. Human validates conclusions and decides next steps

### Design Tasks: Pattern Verification

For tasks that produce designs, architectures, or plans:

1. Create the design artifact
2. Claude sanity-checks against known patterns, constraints, project conventions
3. Claude flags obvious issues or inconsistencies
4. Human judges appropriateness and makes final call

### When Verification Method is Unclear

If you cannot determine how to verify a task:

1. **STOP** - Do not generate an unverifiable task
2. **ASK** - Request clarification on what "done" looks like
3. **PROPOSE** - Suggest possible verification approaches for user to choose

---

## Task Scoping

### Each Task = One Verifiable Unit

- Clear acceptance criteria
- Can be verified independently
- Builds confidence before proceeding to dependent tasks
- No implementation details (WHAT not HOW)

### Task Identification

- Use consistent ID scheme (T001, T002, etc.)
- Group related tasks into phases
- Mark parallel opportunities
- Mark true dependencies only

---

## Dependencies & Parallelization

### Identify True Dependencies

- Task A produces something Task B needs = dependency
- Tasks A and B are independent = can parallelize
- Mark only actual blockers, not assumed sequences

### Parallel Work

- Group parallel tasks together
- Note task ranges: "T004-T006 can run in parallel"
- Setup tasks are often independent
- Integration tasks need their components complete

---

## Reference Documentation

### Link, Don't Duplicate

```markdown
**Ref:** spec.md:45-67
**Ref:** design.md:78-121
```

### Documentation Flow

```
Source Docs → Task List → Implementation
    ↓            ↓              ↓
 (WHAT)    (BREAKDOWN +     (CODE/CONFIG)
           VERIFICATION)
```

---

## Task Format

### Required Elements

Every task MUST have:

1. **Clear description** - What is being done
2. **Verification** - How Claude and human verify it
3. **Reference** - Link to source doc

### Optional Elements

- Dependencies (if any)
- Parallel indicators
- Risk notes
- Complexity estimate

### Format Template

```markdown
### T001: [Behavior/Outcome Name]

- [ ] [Acceptance criterion 1]
- [ ] [Acceptance criterion 2]
- **Claude verifies:** [What Claude checks]
- **Human verifies:** [What human checks, or "None" if fully automated]
- **Ref:** spec.md:XX-YY
- **Dependencies:** None | T00X
```

---

## Framework-Specific Patterns

### Rails API Endpoints

Routes + controller + view = ONE task (request specs need all three):

```markdown
### T009: Create engagements endpoint

- [ ] Route: GET /api/v2/engagements
- [ ] Controller: EngagementsController#index
- [ ] View: index.json.jbuilder
- **Claude verifies:** Request specs pass, rubocop clean
- **Human verifies:** None (tests cover it)
- **Ref:** spec.md:45-67
```

### Expo/React Native Setup

Configuration + verification commands = ONE task:

```markdown
### T002: Configure TypeScript path aliases

- [ ] Update tsconfig.json with path mappings
- [ ] Create test file using @/ import
- **Claude verifies:** `npx tsc --noEmit` exits 0
- **Human verifies:** Import resolves in editor (LSP)
- **Ref:** spec.md:30-45
```

---

## Common Patterns

### Greenfield Pattern

New implementation:
1. Start with simplest verifiable piece
2. Build incrementally
3. Each step verified before next
4. Integrate verified components

### Enhancement Pattern

Modifying existing code:
1. Understand current behavior (read, maybe add tests)
2. Protect against regression
3. Make changes
4. Verify compatibility

### Investigation Pattern

When requirements unclear:
1. Research/spike task first (verification = findings documented)
2. Human reviews findings
3. Then implementation tasks with clear verification

---

## Anti-Patterns

### Unverifiable Tasks

```markdown
# BAD - How do you verify "better"?
T001: Improve code quality

# GOOD - Specific and verifiable
T001: Extract duplicate validation logic
- **Claude verifies:** Tests pass, no code duplication in X, Y, Z
- **Human verifies:** None
```

### Missing Verification

```markdown
# BAD - No verification specified
T001: Set up authentication
- [ ] Configure auth

# GOOD - Clear verification
T001: Set up authentication
- [ ] Configure Supabase auth
- **Claude verifies:** Sign-up/sign-in functions callable, types correct
- **Human verifies:** Full flow works in emulator
```

### Over-Specification

- Implementation details in tasks (HOW not WHAT)
- Rigid phase structures that don't match reality
- Prescriptive file organization

### Under-Specification

- "Implement feature" (too vague)
- Missing verification points
- No references to source docs
- Hidden dependencies

---

## Phase Organization

### Flexible Structure

Phases group related work. Common patterns:

- **Setup/Prerequisites** - Often parallelizable
- **Core Implementation** - May have internal dependencies
- **Integration** - Needs components complete
- **Polish/Cleanup** - Often parallelizable

### Phase Principles

- Don't force phases if tasks are simple
- Match structure to actual dependencies
- Note parallel opportunities within phases
