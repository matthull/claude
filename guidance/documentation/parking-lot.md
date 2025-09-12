---
type: guidance
status: current
category: documentation
---

# Parking Lot Document

## Overview
The parking lot accumulates ideas, questions, and deferred items discovered during work. Kept separate from core documents to avoid loading into context until needed for review.

## Document Structure

### Required Frontmatter
```yaml
---
type: parking-lot
status: active|reviewed
project: {project-name}
last-reviewed: YYYY-MM-DD
---
```

### Required Sections
```markdown
# Parking Lot: {Project Name}

## Future Enhancements
| Item | Context | Priority | Source |
|------|---------|----------|--------|
| Feature idea | Why valuable | High/Med/Low | task-1 |
| Optimization | Performance impact | Medium | session-log |

## Technical Debt
| Item | Impact | Effort | Source |
|------|--------|--------|--------|
| Refactoring needed | Maintainability | Large/Med/Small | task-2 |
| Deprecated usage | Security risk | Small | code-review |

## Open Questions
| Question | Context | Who Can Answer | When Needed |
|----------|---------|---------------|-------------|
| Design decision | Affects architecture | Tech lead | Before task-3 |
| Business rule | Requirements unclear | Product owner | Next sprint |

## Deferred Scope
| Feature | Reason Deferred | Revisit When | Source |
|---------|----------------|--------------|--------|
| Nice-to-have | Time constraint | Phase 2 | requirements |
| Complex integration | Needs research | Next quarter | task-1 |
```

### Optional Sections
```markdown
## Research Topics
| Topic | Purpose | Priority | Resources |
|-------|---------|----------|-----------|
| New library | Could simplify X | Low | {link} |

## Process Improvements
| Improvement | Current Pain | Proposed Solution |
|------------|-------------|------------------|
| Testing gap | Manual QA heavy | Add E2E tests |
```

## Table Column Guidelines

### Priority Values
- **High** - Blocks progress or critical value
- **Medium** - Important but not blocking
- **Low** - Nice to have, consider later

### Effort Estimates
- **Large** - Multiple days or complex
- **Medium** - Day or less, moderate complexity
- **Small** - Few hours, straightforward

### Source Tracking
- Reference where item originated
- Links to task, session log, or discussion
- Helps understand context when reviewing

## Management Workflow

### Adding Items
- Add during any work session
- Include enough context to understand later
- Note the source for traceability
- Don't overthink priority initially

### Review Process
1. **Periodic Review** (weekly or bi-weekly)
   - Load parking lot document
   - Assess accumulated items
   - Promote urgent items to requirements
   - Archive completed or obsolete items

2. **Project Planning**
   - Review before starting new tasks
   - Convert items to requirements or tasks
   - Update priorities based on current needs

3. **Project Completion**
   - Final review of all items
   - Transfer valuable items to next project
   - Document why items weren't addressed

### Item Lifecycle
```
Discovery → Parking Lot → Review → Action/Archive

Actions:
- Promote to requirements.md
- Create new task
- Add to project plan
- Archive as not needed
```

## Location and Loading

### File Location
```
working-docs/projects/{project}/parking-lot.md
```

### Loading Strategy
- NOT loaded by default (saves context)
- Load explicitly for reviews
- Load when planning new work
- Reference specific items when relevant

### Context Management
- Keep separate from always-loaded docs
- Only load when actively reviewing
- Extract actionable items to other docs
- Archive completed sections

## Item Promotion Patterns

### To Requirements
```markdown
Parking Lot Item: "Add batch processing"
→ Requirements: "User Story: As a user, I want batch operations..."
```

### To Project Plan
```markdown
Parking Lot Item: "Consider microservices"
→ Project Plan Architecture: "Evaluate service decomposition"
```

### To New Task
```markdown
Parking Lot Item: "Fix performance issue"
→ Create task: "optimize-query-performance"
```

## Anti-patterns

### What to Avoid
- Letting parking lot grow indefinitely
- Never reviewing accumulated items
- Adding implementation details (keep high-level)
- Using as a task list (tasks go in task.md)
- Loading by default (wastes context)

### Regular Maintenance
- Review at natural breakpoints
- Archive obsolete items
- Consolidate duplicate ideas
- Keep descriptions concise
- Update priorities as context changes

## Benefits
- **Context preservation** - Nothing gets lost
- **Deferred decision making** - Decide when ready
- **Reduced cognitive load** - Park it and continue
- **Efficient context usage** - Load only when needed
- **Traceable ideas** - Know where items originated