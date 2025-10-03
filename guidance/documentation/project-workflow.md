---
type: guidance
status: current
category: documentation
tags:
- documentation
focus_levels:
- design
- implementation
---

# Project Workflow

## Directory Structure
```
working-docs/projects/
├── {project-name}/
│   ├── project-plan.md           # Overview & goals
│   ├── requirements.md           # What we're building
│   ├── architecture-decisions/   # ADRs
│   ├── {task-name}/             # Task-specific docs
│   │   ├── task.md              # Current status
│   │   ├── implementation-plan.md
│   │   ├── session-logs/        # Work notes
│   │   └── handoff.md           # Pause context
│   └── archive/                 # Completed work
```

## Project Plan Structure
```markdown
# Project: [Name]
Status: planning | active | completed
Branch: [branch-name]

## Goals
- Primary objective
- Success criteria

## Architecture
- Key decisions
- Component relationships

## Implementation
- [ ] Phase 1
- [ ] Phase 2
```

## Task Workflow
1. Create task directory: `working-docs/projects/{project}/{task}/`
2. Document task in `task.md`
3. Work on feature branch
4. Create handoff when pausing
5. Archive when complete: `mv {task}/ archive/`

## Handoff Structure
```markdown
# Handoff: [Task]
Branch: [branch-name]
Status: [current state]

## What was done
- Completed items

## Next steps
- Immediate tasks

## Context
- Key decisions
- Open questions
```

## Naming Conventions
- Tasks: `{branch-name}-task.md`
- Handoffs: `{branch-name}-handoff.md`
- Sessions: `session-logs/YYYY-MM-DD-{topic}.md`
- Plans: `{feature}-implementation-plan.md`

## Commands
```bash
# Find current work
ls working-docs/projects/*/[!archive]*

# Find handoffs
find working-docs/projects -name "*-handoff.md"

# Archive completed
mv working-docs/projects/project/task/ working-docs/projects/project/archive/
```

## Anti-patterns
- NEVER: Nested folders beyond 3 levels
- NEVER: Mix docs with code
- NEVER: Create "misc" directories
- NEVER: Duplicate information