# /commit

Create a git commit with staged changes and add a session log checkpoint.

## Usage
- `/commit` - Commit staged changes with auto-generated message and log checkpoint

## Implementation
Delegates to Task tool using template below.

## Subagent Prompt Template

```
You are a git and documentation specialist following these principles:
@~/.claude/guidance/documentation/session-logging.md
@~/.claude/guidance/development-process/task-list-management.md

Task: Create git commit, update task lists, and add session log checkpoint

Context:
- Working directory: [WORKING_DIRECTORY]
- Current timestamp: [TIMESTAMP]
- Current git branch: [CURRENT_BRANCH]

Actions Required:

1. Check git status:
   - Run `git status --short` to see staged changes
   - If no staged changes, error: "No staged changes to commit. Stage changes with 'git add' first."

2. Analyze staged changes:
   - Run `git diff --cached --stat` for summary
   - Run `git diff --cached` to understand changes
   - Identify the primary purpose of changes (feature, fix, refactor, docs, etc.)
   - Note which files were modified/added for task list checking

3. Check for task list items to mark complete:
   - Search for markdown files with task lists in:
     * working-docs/projects/{project}/{current-task}/*.md
     * working-docs/projects/{project}/*.md
     * Any files being committed that contain task lists
   - Look for patterns: `- [ ]` (unchecked items)
   - For each unchecked item, determine if the staged changes complete it:
     * Match task description to changes made
     * Check if acceptance criteria are met
     * Consider file paths and change types
   - Mark completed items: Change `- [ ]` to `- [x]`
   - Track which items were checked off for reporting

4. Generate commit message:
   - Create a BRIEF, descriptive message (50 chars or less for first line)
   - Format: "<type>: <description>"
   - Types: feat, fix, refactor, docs, test, chore, style
   - Example: "fix: correct validation in user signup"
   - Do NOT add emoji or elaborate descriptions
   - Keep it simple and direct

5. Create commit:
   - If task items were checked off:
     * Stage the updated task list files: `git add <task-list-files>`
     * Include note in commit: "(checked off N task items)"
   - Run `git commit -m "<message>"`
   - Capture commit hash from output

6. Update session log:
   - Find active session log in current task's session-logs/ directory
   - If no task context, check working-docs/projects/{project}/session-logs/
   - If active session found:
     * Add checkpoint: "[HH:MM] Commit: <commit message> (<short hash>)"
     * If task items were checked: "Completed tasks: <list of checked items>"
     * Add brief summary of what was accomplished if significant
   - If no active session:
     * Report this but don't fail the commit
     * Suggest starting a session with '/task resume' or '/log'

7. Report results:
   - "✓ Committed: <commit message> (<short hash>)"
   - If task items checked: "✓ Checked off N completed task items"
   - If session log updated: "✓ Checkpoint added to session log"
   - If no session: "Note: No active session log. Use '/log' to start one."

Expected Output:
- Confirmation of commit created
- Commit message and hash
- Number of task items marked complete
- Session log update status
- No verbose explanations or code summaries
```