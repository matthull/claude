---
type: guidance
status: current
category: documentation
---

# Project File Organization

## Overview
A systematic approach to organizing project documentation that prevents sprawl and supports efficient AI collaboration.

## Core Principles

### Single Purpose Directories
- **`working-docs/projects/`** - ALL meaningful documentation (may differ per CLAUDE.local.md)
- **`.claude/`** - Project-specific configuration
- **`tmp/`** - Transient files only

### Documentation Hierarchy
```
working-docs/projects/
├── {project-name}/
│   ├── project-plan.md                  # Project overview
│   ├── requirements.md                  # What we're building
│   ├── architecture-decisions/          # ADRs
│   ├── {task-name}/                    # Task-specific docs
│   │   ├── task.md                     # Current status
│   │   ├── implementation-plan.md      # How to build
│   │   ├── session-logs/               # Work notes
│   │   └── handoff.md                  # Pause context
│   └── archive/                        # Completed work
```

## Document Naming Patterns

- **Tasks**: `{branch-name}-task.md`
- **Strategies**: `{descriptive-name}-strategy.md`
- **Handoffs**: `{branch-name}-handoff.md`
- **Plans**: `{feature}-implementation-plan.md`
- **Sessions**: `session-logs/YYYY-MM-DD-{topic}.md`

## Special Directories

### .claude/ Configuration
```
.claude/
├── CLAUDE.md           # Project-specific AI guidance
├── commands/           # Custom slash commands
└── agents/            # Specialized subagents
```

## Document Movement

### Task Completion
```bash
mv working-docs/projects/project/task-name/ working-docs/projects/project/archive/
```

## Anti-patterns

### Avoid
- Deeply nested structures (max 3 levels)
- Mixing docs with code
- Timestamps in permanent doc names
- "misc" or "other" directories
- Duplicate information

### Instead
- Use working-docs/projects/{project}/
- Separate docs from implementation
- Use descriptive permanent names
- Single source of truth
- Clear directory purposes

## Search Patterns

```bash
# Find task documents
find working-docs/projects -name "*-task.md"

# Find current work
ls working-docs/projects/*/[!archive]*

# Find handoffs
find working-docs/projects -name "*-handoff.md"
```

## Benefits

### For Humans
- Predictable locations
- Clear ownership
- Easy archival
- Controlled growth

### For AI Systems
- Efficient loading
- Clear context
- Relationship mapping
- Scope management

## Common Workflows

### Starting Task
```bash
mkdir -p working-docs/projects/my-project/new-feature/session-logs
touch working-docs/projects/my-project/new-feature/task.md
```

### Pausing Work
```bash
touch working-docs/projects/my-project/current-task/handoff.md
```

### Completing Task
```bash
mv working-docs/projects/my-project/current-task/ \
   working-docs/projects/my-project/archive/
```