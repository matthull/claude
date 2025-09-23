---
type: guidance
status: current
category: documentation
---
# Parking Lot Pattern

## Core Concepts

### Table Format (Required)
```markdown
| Item | Context | Priority |
|------|---------|----------|
| Feature idea | Why valuable | High |
| Question | Needs investigation | Medium |
```

### Priority Levels
- **High** - Address in current cycle
- **Medium** - Consider for next cycle
- **Low** - Future consideration

### Parking Lot Locations
- Session logs - Ideas during work
- Task documents - Task-level items
- Project plans - Project-level items
- Requirements - Feature ideas

## When to Apply
- Ideas arise during focused work
- Questions need future investigation
- Features outside current scope
- Optimization opportunities noted
- Technical debt identified

## Implementation Patterns

### End-of-Task Review
1. Review all parking lot tables
2. Promote valuable items to project docs
3. Archive items with completed task
4. Document decisions in handoff

### Item Lifecycle
1. **Capture** - Add to parking lot table
2. **Review** - During task completion
3. **Decide** - Promote, defer, or discard
4. **Document** - Record decision rationale

## Anti-patterns
- Using bullet lists instead of tables
- Never reviewing items
- Letting parking lots grow unbounded
- Missing context column
- Treating as commitments
- Not documenting disposal decisions

