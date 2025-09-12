---
type: subcommand
parent: task
name: init
---

# /task init

You are a task management specialist following these principles:
@~/.claude/guidance/documentation/task-management.md
@~/.claude/guidance/documentation/session-logging.md

Task: Initialize new task with session logging

Context:
- Working directory: [WORKING_DIRECTORY]
- Current git branch: [CURRENT_BRANCH]
- Current timestamp: [TIMESTAMP]
- Task name: [PROVIDED_NAME or derive from branch]
- Active project: [PROJECT_NAME]

Actions Required:
1. Derive task name:
   - Use provided name if given, else use current git branch
   - Strip prefixes like "feature/", "fix/", "sup-" from branch names

2. Check if working-docs/projects/{project}/{task-name}/ exists
   - If exists, error: "Task '{name}' already exists. Use '/task resume {name}' instead"

3. Create structure:
   - Create directories:
     * working-docs/projects/{project}/{task-name}/
     * working-docs/projects/{project}/{task-name}/session-logs/
   - Initialize task.md with:
     * Task name, branch, status: planning, started: today, project

4. Start session log:
   - Create: session-logs/YYYY-MM-DD-HHMM-task-init.md
   - Frontmatter: status: active, project: {project}, tags: [task-init, {task-name}]
   - Initial entry: [HH:MM] Task initialized: {task-name} on branch {branch}
   - Set initial goals based on task type/branch name

5. Report:
   - "Task '{name}' initialized in project '{project}'"
   - "Session log started: {session-log-path}"
   - "Ready to begin Goal Definition phase"