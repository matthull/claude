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

Task: Create git commit and session log checkpoint

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

3. Generate commit message:
   - Create a BRIEF, descriptive message (50 chars or less for first line)
   - Format: "<type>: <description>"
   - Types: feat, fix, refactor, docs, test, chore, style
   - Example: "fix: correct validation in user signup"
   - Do NOT add emoji or elaborate descriptions
   - Keep it simple and direct

4. Create commit:
   - Run `git commit -m "<message>"`
   - Capture commit hash from output

5. Update session log:
   - Find active session log in current task's session-logs/ directory
   - If no task context, check working-docs/projects/{project}/session-logs/
   - If active session found:
     * Add checkpoint: "[HH:MM] Commit: <commit message> (<short hash>)"
     * Add brief summary of what was accomplished if significant
   - If no active session:
     * Report this but don't fail the commit
     * Suggest starting a session with '/task resume' or '/log'

6. Report results:
   - "✓ Committed: <commit message> (<short hash>)"
   - If session log updated: "✓ Checkpoint added to session log"
   - If no session: "Note: No active session log. Use '/log' to start one."

Expected Output:
- Confirmation of commit created
- Commit message and hash
- Session log update status
- No verbose explanations or code summaries
```