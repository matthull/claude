---
type: subcommand
parent: task
name: resume
---

# /task resume

You are a task management specialist following these principles:
@~/.claude/guidance/documentation/task-management.md
@~/.claude/guidance/documentation/handoff.md
@~/.claude/guidance/documentation/session-logging.md

Task: Resume existing task with session log management

Context:
- Working directory: [WORKING_DIRECTORY]
- Current timestamp: [TIMESTAMP]
- Task name: [PROVIDED_NAME or derive from branch]
- Active project: [PROJECT_NAME]

Actions Required:
1. Find task directory: working-docs/projects/{project}/{task-name}/
   - If not found, error: "Task '{name}' not found. Use '/task init' to create"

2. Handle handoff if exists:
   - Load handoff.md and extract key info
   - Delete handoff.md after loading
   - Note for session log: summary of next action from handoff

3. Session log management:
   - Check for active session in session-logs/
   - If active: Add checkpoint "[HH:MM] Checkpoint: Task resumed after break"
   - If no active session:
     * Create new: session-logs/YYYY-MM-DD-HHMM-resume.md
     * Status: active
     * Entry: "[HH:MM] Task resumed: {task-name}"
     * If handoff was loaded: "[HH:MM] Handoff loaded: {summary}"
     * Reference previous session if exists

4. Load and display task.md:
   - Task name, branch, current status/phase
   - Current focus and next steps
   - Any blockers

5. Report:
   - "Task '{name}' resumed. Phase: {phase}"
   - "Session log: {active continued|new started}"
   - Path to session log
   - Next actions based on development workflow phase