---
type: guidance
status: current
category: documentation
---

# Implementation Plan Document

## Overview
Implementation plans detail HOW to build a feature through concrete steps, testing strategy, and rollout approach. Created for complex tasks that need structured execution.

## Context
@~/.claude/guidance/documentation/task-management.md

## Document Structure

### Canonical Implementation File
**CRITICAL**: Always maintain `implementation.md` as the single source of truth for the current implementation plan. Draft versions (e.g., `implementation-v2.md`, `implementation-parallel.md`) may be created for exploration, but all final decisions MUST flow back to `implementation.md`.

### File Management Rules
- **implementation.md** - The canonical, current plan (always keep updated)
- **implementation-{variant}.md** - Draft explorations (temporary)
- **Archive draft versions** after decisions are made
- **Never maintain multiple "active" plans** - consolidate to implementation.md

### Required Frontmatter
Type: implementation-plan, status (draft/approved/in-progress/complete), project, task, and created date.

### Required Sections
- **Overview**: What and why (10 lines max), link to requirements
- **Technical Approach**: Key decisions, patterns, technology choices, trade-offs (20 lines max)
- **Implementation Phases**: 1-3 day chunks with goals, success criteria, and specific steps
- **Testing Strategy**: Unit, integration, manual, and performance test approaches
- **Rollout Plan**: Deployment approach, feature flags, migrations, rollback strategy

### Optional Sections
Risk Mitigation table, Dependencies list, Performance Considerations, and Security Considerations as needed.

## What NOT to Include in Plans

### Never Pre-Plan
- Service objects (emerge from refactoring)
- Helper classes (create when needed)
- Utility modules (extract when complex)
- Internal organization details

### Planning vs Implementation Decisions

**Include in Planning:**
- Data model structure
- API endpoints/contracts
- User flows
- Integration points

**Defer to Implementation:**
- Service extraction
- Helper methods
- Class organization
- Refactoring decisions

## Writing Guidelines

### Technical Approach
- Document WHY not WHAT
- Include rejected alternatives
- Reference existing patterns

### Implementation Phases
- Phase = Deployable unit
- 1-3 days max
- Clear success criteria

### Testing Strategy
- Coverage per phase
- Regression tests
- Manual QA points

## When to Create

### Create Implementation Plan For
- Complex multi-phase features
- High-risk changes
- Cross-system integrations
- Performance-critical code
- Security-sensitive features

### Skip Implementation Plan For
- Simple bug fixes
- Straightforward features
- Well-understood patterns
- Single-file changes
- Routine maintenance

## Relationship to Other Documents

### Inputs
- **requirements.md** - What to build
- **task.md** - Context and goals
- **project-plan.md** - Architecture context

### Outputs
- **session-logs** - Execution record
- **handoff.md** - Pause points
- **project-plan.md** - Lessons learned

### Updates During Implementation
- Mark phases complete
- Note deviations from plan
- Document discovered complexity
- Update estimates if needed
- **Consolidate draft versions** into implementation.md when decisions are made

### Draft Version Workflow
1. **Create draft** for exploration (e.g., `implementation-parallel.md`)
2. **Compare approaches** side-by-side if needed
3. **Make decision** based on analysis
4. **Merge into implementation.md** - incorporate chosen approach
5. **Archive draft** to `archive/` directory or delete if not valuable

## Phase Management

### Phase Principles
- **Incremental value** - Each phase delivers something
- **Independent deployment** - Could stop after any phase
- **Risk reduction** - Hardest/riskiest first
- **Learning incorporation** - Adjust later phases

### Phase Execution
1. Complete all steps in phase
2. Run phase tests
3. Review against success criteria
4. Update plan status
5. Decide on next phase

### Phase Interruption
- Complete current step if possible
- Document progress in handoff
- Note any uncommitted work
- Mark phase as partially complete

## Common Patterns
- **Backend-First**: Data layer → Business logic → API → Frontend
- **Feature Flag**: Implement → Test with flag → Gradual rollout → Remove flag
- **Migration**: Parallel implementation → Migration scripts → Cutover → Cleanup

## Quality Checklist

### Good Implementation Plan
- [ ] Phases are independently valuable
- [ ] Steps are concrete and specific
- [ ] Tests included in each step
- [ ] Rollback strategy defined
- [ ] Risks identified and mitigated

### Poor Implementation Plan
- Vague steps like "implement feature"
- Missing test strategy
- Phases too large (>3 days)
- No success criteria
- Ignoring known risks

