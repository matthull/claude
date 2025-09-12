---
type: guidance
status: current
category: documentation
---

# Project Plan Document

## Overview
The project plan is the master coordination document for a project, tracking status, goals, task history, and lessons learned. Always loaded alongside requirements.md in main context.

## Context
@~/.claude/guidance/documentation/project-management.md

## Document Structure

### Required Frontmatter
```yaml
---
type: project-plan
status: planning|active|complete|archived
project: {project-name}
started: YYYY-MM-DD
---
```

### Required Sections
```markdown
# Project: {Project Name}

## Overview
What we're building and why (10-15 lines max).
Clear problem statement and intended solution.

## Current Status
**Last Updated**: YYYY-MM-DD

## Goals
Primary objectives for this project:
- Goal 1 - measurable outcome
- Goal 2 - specific deliverable  
- Goal 3 - business value

## Architecture Overview
High-level technical approach (15-20 lines max):
- Key patterns/frameworks
- Major components
- Critical dependencies
- Integration points

## Task History
| Task | Status | Summary |
|------|--------|---------|
| {task-1} | Complete | One-line outcome |
| {task-2} | Archived | Why abandoned |
| {task-3} | Active | Current focus |

## Lessons Learned
Key insights from completed tasks:
- Discovery that affects approach
- Pattern that works well
- Pitfall to avoid

## Dependencies
- External service/team
- Prerequisite project
- Required infrastructure
```

### Optional Sections
```markdown
## Success Metrics
- Metric 1: target value
- Metric 2: measurement method

## Risk Register
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Risk 1 | High/Med/Low | High/Med/Low | Strategy |
```

## Writing Guidelines

### Overview Section
- Concise problem statement
- Clear solution approach
- Business value proposition
- Keep under 15 lines

### Current Status
- Update after significant changes
- Include blockers if any
- Date of last significant update

### Goals
- 3-5 measurable objectives
- Link to business value
- Achievable in 1-2 weeks
- Clear definition of success

### Architecture Overview
- High-level only (details in ADRs)
- Focus on integration points
- Identify key dependencies
- Note critical technical decisions

### Task History
- One line summaries only
- Link to task directories
- Include failed/archived tasks
- Learn from all attempts

### Lessons Learned
- Extract from task completions
- Update as insights emerge
- Include both successes and failures
- Actionable for future work

## Update Triggers

### When to Update
- Task completion or archival
- Significant discoveries
- Architecture decisions made
- Scope or goals change

### Update Process
1. Complete task work
2. Extract key outcomes
3. Update task history table
4. Add lessons learned
5. Refresh current status
6. Update last modified date

## Relationship to Other Documents

### Peer Documents (Always Loaded Together)
- **requirements.md** - Defines what we're building
- Both loaded in main context for all project work

### Referenced Documents
- **parking-lot.md** - Accumulates deferred items
- **architecture-decisions/*.md** - Detailed technical decisions
- **{task}/task.md** - Individual task details

### Information Flow
```
Tasks complete → Update task history
Discoveries made → Add lessons learned  
Scope changes → Update goals
Technical decisions → Reference in architecture
```

## Size Management

### Target Size
- Keep under 150 lines total
- Overview: 10-15 lines
- Architecture: 15-20 lines
- Task history: As needed (archive old tasks)

### When Too Large
- Archive completed task history periodically
- Move detailed architecture to ADRs
- Extract lessons to separate retrospective doc
- Keep only current/relevant information

## Status Values

### Project Status
- **planning** - Requirements being defined
- **active** - Tasks in progress
- **complete** - All goals achieved
- **archived** - No longer active


## Benefits
- **Central coordination** - Single source of project truth
- **Quick orientation** - Current status at a glance
- **Historical context** - Learn from past tasks
- **Efficient updates** - Structured format for changes
- **Clear progress** - Task history shows momentum