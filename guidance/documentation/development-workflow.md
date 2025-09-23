---
type: guidance
status: current
category: documentation
---

# Development Workflow

## Core Principles

### Iterative Refinement
- Each phase builds on previous understanding
- User confirmation before phase transitions
- Documentation evolves with understanding

### Flexible Completion
- Tasks can complete at any phase
- Design-only tasks stop after planning
- Research tasks might only do phase 1
- Full implementation goes through all phases

### Quality Gates
- User reviews and approves each phase
- Tests defined before implementation
- Clear success criteria

## Development Phases

### Phase 1: Goal Definition
**Purpose**: Understand what needs to be built and why

**Activities**:
- Clarify requirements and constraints
- Identify success criteria
- Research existing code
- Define scope boundaries

**Deliverables**:
- Problem statement
- Success criteria
- Scope definition

### Phase 2: Implementation Planning
**Purpose**: Design technical approach

**Activities**:
- Map current vs desired state
- Design solution architecture
- Identify risks and dependencies
- Create test strategy

**Deliverables**:
- Technical design
- Test plan
- Risk assessment

### Phase 3: Development
**Purpose**: Build the solution

**Activities**:
- Implement in small increments
- Write tests first (TDD)
- Regular user reviews
- Refactor as needed

**Deliverables**:
- Working code
- Passing tests
- Updated documentation

### Phase 4: Verification
**Purpose**: Ensure quality and completeness

**Activities**:
- Run full test suite
- Code review
- Performance check
- Security validation

**Deliverables**:
- Test results
- Review feedback
- Performance metrics

### Phase 5: Deployment
**Purpose**: Release to production

**Activities**:
- Prepare deployment plan
- Stage changes
- Execute deployment
- Monitor results

**Deliverables**:
- Deployment checklist
- Release notes
- Monitoring alerts

## Phase Transitions

### Moving Forward
- User explicitly approves phase completion
- All deliverables documented
- Success criteria met
- No blocking issues

### Moving Backward
- New information changes requirements
- Technical blockers discovered
- Assumptions proven invalid
- Scope needs adjustment

## Work Patterns

### Research Tasks
- Focus on Phase 1
- Deep investigation
- Document findings
- Recommend next steps

### Design Tasks
- Phases 1-2
- Architecture focus
- Multiple solution options
- Trade-off analysis

### Implementation Tasks
- All phases
- Incremental delivery
- Continuous testing
- Regular checkpoints

### Bug Fixes
- Abbreviated Phase 1
- Jump to Phase 3
- Focus on regression tests
- Quick verification

## Documentation Requirements

### During Development
- Update task.md with progress
- Log decisions in session notes
- Track blockers and risks
- Document assumptions

### At Completion
- Final implementation summary
- Lessons learned
- Handoff documentation
- Archive completed work

## Anti-patterns

### Avoid
- Skipping phase gates
- Big-bang implementations
- Documentation after the fact
- Assuming requirements are fixed

### Instead
- Confirm at each phase
- Incremental progress
- Document as you go
- Validate assumptions early