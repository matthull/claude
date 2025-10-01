---
description: Create a task handoff document for pausing/transferring work on a feature
---

## Usage
```
/handoff <project-name> <task-range>
```

**Examples:**
- `/handoff 001-seismic-integration T006-T009`
- `/handoff 002-highspot-integration T015,T018,T020`
- `/handoff` (will prompt for project and tasks)

## Implementation

### 1. Load Guidance
```
@~/.claude/guidance/documentation/task-handoffs.md
```

### 2. Get Project and Task Info

**Arguments**: `$ARGUMENTS` format: `"<project-name> <task-range>"`

**If project missing**:
- `ls -1 specs/`
- Ask: "Which project? (e.g., 001-seismic-integration)"

**If task range missing**:
- Read `specs/{project}/tasks.md`
- Ask: "Which tasks? (e.g., T006-T009 or T006,T008,T012)"

### 3. Load Project Files

Read all from `specs/{project-name}/`:
- `plan.md` (required)
- `tasks.md` (required)
- `data-model.md` (if exists)
- `implementation-guidelines.md` (if exists)
- `research.md` (if exists)
- `quickstart.md` (if exists)

### 4. Generate Handoff

Follow template from task-handoffs guidance.

Extract from loaded files:
- Current branch: `git branch --show-current`
- Date: `date +%Y-%m-%d`
- Task details for specified range
- File paths, dependencies, [P] markers
- Completed tasks (marked [x] in tasks.md)

**Save to**: `specs/{project}/handoff-T###-T###-{date}.md`

### 5. Confirm

Print:
```
✅ Created: specs/{project}/handoff-T###-T###-{date}.md

Next: Load handoff and follow task-handoffs guidance
```

## Error Handling

**Missing project dir**:
```
Error: specs/{project}/ not found
Available: {ls -1 specs/}
```

**Missing tasks.md**:
```
Error: specs/{project}/tasks.md not found
Run /plan and /tasks first
```

**Invalid task format**:
```
Error: Invalid format: {input}
Valid: T006-T009 or T006,T008,T012 or T006
```
