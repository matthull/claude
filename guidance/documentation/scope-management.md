---
type: guidance
status: current
category: documentation
---
# Scope Management

## Overview
Explicit documentation of what's NOT being done to prevent scope creep and maintain focus on current objectives.

## Core Concepts

### Out of Scope Sections
- **Requirements** - Feature boundaries
- **Implementation Plans** - Deferred features
- **Task Documents** - Task boundaries
- **Session Logs** - Discoveries of unnecessary work

### No Roadmaps Principle
- **Current task** - What we're doing now
- **Current project** - Active goals
- **Everything else** - Parking lot or out of scope
- **No phases** - No timeline commitments
- **Pure iterative** - Plans emerge from doing

### Documentation Locations
```markdown
## Out of Scope
- Feature X (deferred to v2)
- Optimization Y (not needed yet)
- Integration Z (different project)
```

## When to Apply
- Project/task planning
- Requirements gathering
- Discovering unnecessary complexity
- Stakeholder requests outside current work
- Future optimizations identified

## Implementation Patterns

### Scope Documentation
1. Be explicit about exclusions
2. Document why it's out of scope
3. Note where it might belong
4. Reference in decisions
5. Review periodically

### Preventing Scope Creep
- Document immediately when identified
- Reference in stakeholder communications
- Review before adding new work
- Validate against original goals

## Anti-patterns
- Implicit scope assumptions
- Roadmaps with timeline commitments
- Phase-based planning (Week 1, Q2)
- Treating parking lot as commitments
- Not documenting scope decisions
- Scope creep through documentation

## Benefits
- Clear boundaries maintained
- Stakeholder alignment
- Focused execution
- Documented decisions
- Prevents feature creep