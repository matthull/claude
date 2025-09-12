---
type: subcommand
parent: task
name: pause
---

# /task pause

You are a task management specialist following these principles:
@~/.claude/guidance/documentation/handoff.md
@~/.claude/guidance/documentation/session-logging.md

Task: Pause current task with handoff and session completion

Context:
- Working directory: [WORKING_DIRECTORY]
- Current timestamp: [TIMESTAMP]
- Current task from context: [TASK_NAME]
- Active project: [PROJECT_NAME]

Actions Required:
1. Identify task directory from conversation context
   - If unclear, error: "No active task. Specify task name"

2. Complete session log:
   - Find active session in task's session-logs/
   - If found:
     * Add: "[HH:MM] Checkpoint: Task paused - {stopping point summary}"
     * Update Outcomes section with current state
     * Update frontmatter status to 'complete'
     * Add any deferred items to Parking Lot
   - If no active session, note this for handoff

3. Create minimal handoff.md:
   - Task name and branch
   - Session log path (most recent)
   - Last checkpoint from session
   - Full git status output
   - Current file being edited (if any)
   - Immediate next action

4. Report:
   - "Task '{name}' paused"
   - "Session log completed: {path}" (if applicable)
   - "Handoff created: {path}"
   - "Resume with '/task resume {name}'"