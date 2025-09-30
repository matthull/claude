---
type: guidance
status: current
category: documentation
---

# Parking Lot Pattern

## Purpose
Capture ideas, debt, questions during work without disrupting flow.

## Structure
```markdown
# Parking Lot: {Project}

## Future Enhancements
| Item | Context | Priority | Source |
|------|---------|----------|--------|

## Technical Debt
| Item | Impact | Effort | Source |
|------|--------|--------|--------|

## Open Questions
| Question | Context | Who | When |
|----------|---------|-----|------|

## Deferred Scope
| Feature | Reason | Revisit | Source |
|---------|--------|---------|--------|
```

## Priority Scale
- **High**: Blocks progress
- **Medium**: Important, not blocking
- **Low**: Nice to have

## Effort Scale
- **Large**: Multiple days
- **Medium**: Day or less
- **Small**: Few hours

## Workflow
1. **Add**: During any work session
2. **Review**: Weekly/bi-weekly
3. **Promote**: To requirements/tasks
4. **Archive**: Completed/obsolete

## Best Practices
- Include context for later understanding
- Reference source (task/session/discussion)
- Don't overthink initial priority
- Review before new task planning

## Anti-patterns
- NEVER: Let parking lot grow unchecked
- NEVER: Add without context
- NEVER: Ignore during planning
- NEVER: Mix with active tasks