---
type: guidance
status: current
category: documentation
---

# Task Management

## Overview
Tasks are discrete units of work within a project, typically tied to a git branch. A task represents hours to a few days of effort toward implementing specific requirements or fixes.

## Context
@~/.claude/guidance/documentation/project-management.md

## What Constitutes a Task

### Task Characteristics
- **Specific deliverable**: Clear output or change
- **Branch-based**: Usually tied to a git branch
- **Time-bounded**: Hours to few days
- **Testable**: Clear completion criteria
- **Project-scoped**: Part of a larger project

### When to Create Tasks
- Implementing a specific feature from requirements
- Fixing a complex bug requiring investigation
- Refactoring a component or module
- Creating new functionality
- Major configuration changes

### When NOT to Create Tasks
- Trivial fixes (just do them directly)
- Pure research (use session logs)
- Simple documentation updates
- One-line bug fixes

## Task Structure

### Task Directory
```
working-docs/projects/{project}/{task-name}/
├── task.md                  # Task status and goals
├── implementation-plan.md   # How to build it (optional)
├── session-logs/           # Work progress
│   └── YYYY-MM-DD-HHMM-topic.md
└── handoff.md              # Created when pausing
```

### Task Naming
- Use branch name as task directory name
- Examples: `sup-43-seismic-button`, `fix-auth-bug`, `add-search-feature`
- Keeps git branch and documentation aligned

## Document Structure

### Required Frontmatter
```yaml
---
type: task
status: planning|implementing|testing|complete
project: {project-name}
branch: {branch-name}
started: YYYY-MM-DD
---
```

### Required Sections
```markdown
# Task: {Task Name}

## Status
- Branch: {branch-name}
- Phase: Planning|Implementation|Testing|Complete
- Started: YYYY-MM-DD

## Goals
- Primary objective
- Success criteria
- Deliverables

## Scope
### In Scope
- What we ARE doing
- Specific changes

### Out of Scope  
- What we're NOT doing
- Explicitly deferred items

## Current Focus
- What we're working on right now
- Next immediate step

## Blockers
- Current impediments
- Dependencies waiting on

## Next Steps
- Immediate actions
- Clear sequence
```

### Optional Sections
```markdown
## Parking Lot
| Item | Notes |
|------|-------|
| Idea | Context |

## Technical Notes
- Implementation details
- Key decisions made
- Gotchas discovered

## Test Plan
- How to verify completion
- Test cases to run
```

## Task Lifecycle

### 1. Task Creation
- Create task directory in project
- Initialize task.md from template
- Link to project requirements
- Define clear goals and scope

### 2. Planning Phase (Optional)
- Research and investigation
- Create implementation-plan.md if complex
- Identify technical approach
- Define test strategy

### 3. Implementation Phase
- Work captured in session logs
- Update task.md current focus
- Track blockers as they arise
- Reference project requirements

### 4. Testing Phase
- Execute test plan
- Document results
- Fix issues found
- Verify acceptance criteria

### 5. Task Completion
- Update task status to complete
- Extract lessons to project-plan.md
- Update project task history
- Archive or continue with next task

## Development Workflow

### Phase-Based Approach
Tasks can follow structured phases or be more fluid:

1. **Goal Definition** - Clarify what needs to be built
2. **Strategy Refinement** - Design approach with pros/cons
3. **Implementation Planning** - Detailed steps if needed
4. **Implementation** - Build incrementally
5. **Verification** - Test and validate

### Flexible Completion
- Tasks may complete at any phase
- Design tasks might end after planning
- Simple tasks might skip planning entirely
- Partial implementation is valid

## Relationship to Other Documents

### Parent Context
- **project-plan.md** - Task updates project status
- **requirements.md** - Task implements specific requirements
- **parking-lot.md** - Task contributes deferred items

### Child Documents
- **implementation-plan.md** - Detailed build steps
- **session-logs/*.md** - Chronological work record
- **handoff.md** - Pause/resume context

### Information Flow
```
Requirements → Task goals
Task completion → Project plan update
Session insights → Task technical notes
Task blockers → Project blockers
```

## Context Management

### Task Work Context
- Load project-plan.md and requirements.md
- Load task.md
- Load implementation-plan.md if exists
- Reference recent session logs

### Handoff Preparation
- Create handoff.md when pausing
- Document current state
- List next steps clearly
- Note any blockers

## Task vs Project Scope

### Task Scope
- Single feature or fix
- One branch of work
- Clear completion criteria
- Hours to few days

### Project Scope
- Multiple related tasks
- Overall feature set
- Business objective
- Days to 1-2 weeks

## Benefits
- **Clear focus** - One deliverable at a time
- **Branch alignment** - Git and docs stay synchronized
- **Flexible workflow** - Phases adapt to task needs
- **Context preservation** - Complete handoff capability
- **Project integration** - Tasks feed project learning