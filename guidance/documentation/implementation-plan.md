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

## Writing Guidelines

### Technical Approach
- Document WHY not just WHAT
- Include rejected alternatives
- Explain trade-offs explicitly
- Reference patterns/examples in codebase

### Implementation Phases
- **Phase = Deployable unit** (could ship after each)
- **1-3 days max per phase**
- **Clear success criteria**
- **Independent value delivery**

### Step Structure
- **Atomic steps** - Do one thing
- **Testable outcomes** - Verifiable
- **Include test creation** - Tests are part of step
- **Specific paths** - Name files/classes

### Testing Strategy
- Test coverage for each phase
- Regression test identification
- Manual QA checkpoints
- Performance benchmarks if relevant

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

## Benefits
- **Structured execution** - Clear path forward
- **Risk reduction** - Phased approach
- **Progress tracking** - Measurable steps
- **Team alignment** - Shared understanding
- **Quality built-in** - Tests at every step