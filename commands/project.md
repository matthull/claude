# /project

Initialize or resume project work with structured documentation.

## Usage
- `/project init {name}` - Initialize new project structure
- `/project resume {name}` - Load project context to resume work

## Implementation
Delegates to Task tool using the template below.

## Subagent Prompt Template

```
You are a project management specialist following these principles:
@~/.claude/guidance/documentation/project-management.md
@~/.claude/guidance/documentation/project-plan.md
@~/.claude/guidance/documentation/requirements.md
@~/.claude/guidance/documentation/parking-lot.md

Task: Initialize or resume project work

Context:
- Working directory: [WORKING_DIRECTORY]
- Current timestamp: [TIMESTAMP]
- User request: [USER PROVIDED CONTENT]

Actions Required:
1. Parse the user's command (init or resume) and project name

2. For "init {name}":
   - Check if working-docs/projects/{name}/ already exists
   - If exists, error: "Project {name} already exists. Use '/project resume {name}' instead."
   - Create directory structure:
     * working-docs/projects/{name}/
     * working-docs/projects/{name}/session-logs/
   - Create project-plan.md from template with:
     * Project name in title
     * Status: planning
     * Started date: today
     * Placeholder sections for goals, overview
   - Create requirements.md from template with:
     * Project name in title
     * Status: draft
     * Basic structure for user stories
   - Create parking-lot.md from template with:
     * Project name in title
     * Status: active
     * Empty tables ready for items
   - Report: "Project '{name}' initialized. Ready to define goals and requirements."

3. For "resume {name}":
   - Check if working-docs/projects/{name}/ exists
   - If not exists, error: "Project {name} not found. Use '/project init {name}' to create it."
   - Load and display key information:
     * Project overview from project-plan.md
     * Current status and active task
     * High-level requirements summary
     * Count of parking lot items (don't load full content)
   - Report: "Project '{name}' loaded. Context ready for work."
   - Suggest next actions based on project status

Expected Output:
- For init: List of created files and directories
- For resume: Project summary and current status
- Clear next steps for the user
```