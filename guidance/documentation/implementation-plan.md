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
```yaml
---
type: implementation-plan
status: draft|approved|in-progress|complete
project: {project-name}
task: {task-name}
created: YYYY-MM-DD
---
```

### Required Sections
```markdown
# Implementation Plan: {Feature Name}

## Overview
What we're implementing and why (10 lines max).
Link to requirements being addressed.

## Technical Approach
Key technical decisions (20 lines max):
- Architecture pattern chosen
- Technology/library selections
- Integration approach
- Trade-offs accepted

## Implementation Phases
Break into manageable phases (1-3 day chunks):

### Phase 1: {Foundation}
**Goal**: What this phase accomplishes
**Success Criteria**: How we know it's done

Steps:
1. **Step Name**
   - What: Specific action
   - Outcome: Expected result
   - Tests: How to verify
   
2. **Next Step**
   - What: Action
   - Outcome: Result
   - Tests: Verification

### Phase 2: {Core Feature}
[Similar structure]

## Testing Strategy
How we'll verify correctness:
- Unit tests: What to test
- Integration tests: Key scenarios
- Manual testing: UI/UX verification
- Performance testing: If applicable

## Rollout Plan
How this gets deployed:
- Feature flags: Yes/No and approach
- Database migrations: Required changes
- Rollback strategy: How to undo
- Monitoring: What to watch
```

### Optional Sections
```markdown
## Risk Mitigation
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Risk 1 | High/Med/Low | High/Med/Low | Strategy |

## Dependencies
- External services needed
- Team coordination required
- Infrastructure changes

## Performance Considerations
- Expected load
- Optimization opportunities
- Caching strategy

## Security Considerations
- Authentication/authorization
- Data validation
- Audit requirements
```

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

### Backend-First Pattern
```markdown
Phase 1: Data layer and models
Phase 2: Business logic and services
Phase 3: API endpoints
Phase 4: Frontend integration
```

### Feature Flag Pattern
```markdown
Phase 1: Implementation behind flag
Phase 2: Testing with flag enabled
Phase 3: Gradual rollout
Phase 4: Flag removal
```

### Migration Pattern
```markdown
Phase 1: Parallel implementation
Phase 2: Data migration scripts
Phase 3: Cutover and verification
Phase 4: Cleanup old code
```

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