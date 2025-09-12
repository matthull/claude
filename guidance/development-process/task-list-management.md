---
type: guidance
status: current
category: development-process
---

# Task List Management

## Overview
Structured approach to creating, tracking, and completing development tasks with clear acceptance criteria and dependencies.

## Task Structure

### Essential Elements
- **Title** - Action-oriented description
- **Scope** - Clear boundaries of work
- **Acceptance criteria** - Definition of done
- **Dependencies** - Prerequisite tasks
- **Priority** - Relative importance
- **Status** - Current progress state

### Task Title Format
- Start with verb (Create, Update, Fix, Add)
- Specify target (component, feature, bug)
- Be specific and measurable
- Keep under 10 words
- Examples:
  - "Add user authentication to API"
  - "Fix memory leak in image processor"
  - "Create unit tests for payment service"

### Acceptance Criteria Standards
- **Specific** - Exact requirements
- **Measurable** - Can verify completion
- **Achievable** - Realistic scope
- **Relevant** - Tied to goals
- **Testable** - Can validate success

## Task States

### State Progression
1. **Pending** - Not started
2. **In Progress** - Currently working
3. **Blocked** - Waiting on dependency
4. **Review** - Awaiting approval
5. **Completed** - Fully done

### State Rules
- Only one task in progress at a time
- Mark complete immediately when done
- Document blockers when stuck
- Update status in real-time
- Never skip states

## Dependency Management

### Dependency Types
- **Technical** - Code dependencies
- **Data** - Required information
- **External** - Third-party systems
- **Human** - Approvals or reviews
- **Sequential** - Order matters

### Handling Dependencies
1. Identify before starting
2. List explicitly in task
3. Check availability first
4. Track blocking status
5. Communicate delays

## Task Prioritization

### Priority Levels
1. **Critical** - Blocks everything
2. **High** - Core functionality
3. **Medium** - Important features
4. **Low** - Nice to have
5. **Defer** - Future consideration

### Ordering Principles
- Dependencies first
- Critical path items
- Risk reduction early
- User impact priority
- Quick wins when blocked

## Task Decomposition

### When to Break Down
- Task takes > 4 hours
- Multiple components involved
- Different skill sets needed
- Natural checkpoints exist
- Parallel work possible

### Decomposition Rules
- Each subtask independently valuable
- Clear completion criteria
- No overlapping scope
- Logical grouping
- Maintain context

## Progress Tracking

### Update Frequency
- Status: Real-time changes
- Progress: At milestones
- Blockers: Immediately
- Completion: When done
- Review: Before handoff

### Progress Indicators
- Not started (0%)
- Started (25%)
- Half done (50%)
- Nearly done (75%)
- Complete (100%)

## Communication Patterns

### Status Updates
- Current task and progress
- Next planned task
- Any blockers
- Estimated completion
- Help needed

### Handoff Information
- Tasks completed
- Tasks in progress
- Known issues
- Next priorities
- Context needed

## Common Patterns

### Daily Workflow
1. Review task list
2. Pick highest priority
3. Mark as in progress
4. Complete work
5. Mark as done
6. Update remaining tasks

### Complex Feature Pattern
1. Create epic task
2. Decompose to subtasks
3. Order by dependencies
4. Track progress on epic
5. Close epic when subtasks done

## Anti-patterns
- Multiple tasks in progress
- Vague task descriptions
- Missing acceptance criteria
- Ignored dependencies
- Stale status updates
- Batch status updates
- Skipping blocked state
- Incomplete tasks marked done

## Benefits
- Clear work visibility
- Better estimation
- Reduced context switching
- Improved collaboration
- Traceable progress
- Predictable delivery