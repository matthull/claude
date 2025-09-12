# /task

Initialize, resume, pause, or complete task work within a project with automatic session logging.

## Usage
- `/task init` - Initialize task using current git branch as name and start session log
- `/task init {name}` - Initialize task with specific name and start session log
- `/task resume` - Resume task using current branch name and continue/start session log
- `/task resume {name}` - Resume specific task by name and continue/start session log
- `/task pause` - Create minimal handoff and complete current session log
- `/task complete` - Complete task with parking lot review and documentation updates

## Implementation
This command delegates to the Task tool with subcommand-specific prompts. To minimize context usage, each subcommand prompt is stored in a separate file and loaded only when needed.

## Subcommand Files
- `task-subcommands/init.md` - Initialize new task
- `task-subcommands/resume.md` - Resume existing task
- `task-subcommands/pause.md` - Pause with handoff
- `task-subcommands/complete.md` - Complete with documentation updates

When executing a subcommand, load ONLY the corresponding file from `~/.claude/commands/task-subcommands/`.

## Error Handling
If prerequisites aren't met (e.g., no active project), report:
"No active project. Use '/project init {name}' or '/project resume {name}' first"