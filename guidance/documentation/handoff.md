---
type: guidance
status: current
category: documentation
tags:
- devops
---

# Task Handoff Document

## Document Structure

### Required Frontmatter
```yaml
---
type: handoff
status: current
project: {project-name}
task: {task-name}
created: YYYY-MM-DD HH:MM
---
```

### Required Sections
```markdown
# Task Handoff: {Task Name}

## Resume Instructions
**Session Log**: session-logs/YYYY-MM-DD-HHMM-{topic}.md
**Last Checkpoint**: [Time and summary from session log]

## Git State
**Branch**: {branch-name}
**Uncommitted Changes**: 
```bash
git status output here
```

## Quick Resume
1. Load session log: session-logs/YYYY-MM-DD-HHMM-{topic}.md
2. Review last checkpoint and extraction queue
3. Check git status matches above
4. Continue from "Next Steps" in session log

## Active Work
**File in progress**: {file:line if applicable}
**Test running**: {test command if applicable}
**Next action**: {immediate next step from session log}
```

## Writing Guidelines

### Keep It Minimal
- Point to session log for context
- Only capture git state and pointers
- Don't duplicate session log content
- Focus on resume mechanics only

### Git State
- Include full `git status` output
- Note any stashed changes
- Mention if branch is behind/ahead of remote
- Flag any uncommitted work

### Quick Resume
- Direct path to relevant session log
- One-line summary of stopping point
- Immediate next action only
- Verification command if needed

## When to Create Handoffs

### Always Create For
- End of work session on incomplete task
- Switching to different urgent work
- When uncommitted changes exist
- Natural pause points in work

### Optional For
- Work resuming immediately
- No uncommitted changes
- Clear stopping point in session log

## Handoff vs Session Logs

### Handoff (Temporary Pointer)
- Points to session log
- Captures git state
- Deleted after resume
- Minimal content

### Session Logs (Permanent Record)
- Full work context
- Decisions and discoveries
- Chronological timeline
- Primary source of truth

## Location and Lifecycle

### File Location
```
working-docs/projects/{project}/{task}/handoff.md
```

### Lifecycle
1. Create when pausing task
2. Load when resuming work
3. Delete after loading (it's served its purpose)
4. Create new one if pausing again

### Design Philosophy
- Handoff is a temporary bookmark
- Session log is the real context
- Git state is the only unique info
- Delete after use to avoid staleness

## Resume Workflow

### Using a Handoff
1. Load handoff.md
2. Note session log to load
3. Check git status matches
4. Delete handoff.md
5. Load referenced session log
6. Continue from last checkpoint

### After Resuming
- Start new session log
- Continue from session log next steps
- Create new handoff only when pausing again

## Quality Checklist

### Good Handoff
- [ ] Points to correct session log
- [ ] Git status captured completely
- [ ] Next action clearly stated
- [ ] Minimal and focused

### Poor Handoff
- Duplicates session log content
- Missing git state
- Vague pointers
- Stale information kept

