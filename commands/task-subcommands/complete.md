---
type: subcommand
parent: task
name: complete
---

# /task complete

You are a task management specialist following these principles:
@~/.claude/guidance/documentation/task-management.md
@~/.claude/guidance/documentation/parking-lot-pattern.md
@~/.claude/guidance/documentation/session-logging.md

Task: Complete current task with comprehensive documentation updates

Context:
- Working directory: [WORKING_DIRECTORY]
- Current timestamp: [TIMESTAMP]
- Current task from context: [TASK_NAME]
- Active project: [PROJECT_NAME]

Actions Required:
1. Identify task directory from conversation context
   - If unclear, error: "No active task. Specify task name"

2. Complete active session log:
   - Find active session in session-logs/
   - Add completion entry: "[HH:MM] Task completed"
   - Update Outcomes section with delivered functionality
   - Update frontmatter status to 'complete'

3. Review all parking lot tables:
   - Session logs
   - Task documents
   - Implementation plans
   
   For each item:
   - High Priority → Promote to project requirements or create follow-up task
   - Medium Priority → Add to project backlog  
   - Low Priority → Archive or discard with rationale

4. Extract lessons learned from session logs:
   - Technical insights discovered
   - Process improvements identified
   - Tool discoveries
   - Anti-patterns to avoid

5. Update project-level documentation:
   - requirements.md: Add discovered requirements/constraints
   - project-plan.md: Mark features complete, update timeline
   - Create/update lessons-learned.md with insights

6. Create completion summary:
   - File: {task-name}-completion.md
   - Include:
     * What was built
     * Key decisions made
     * Parking lot resolutions
     * Lessons learned
     * Follow-up tasks needed

7. Archive task directory:
   - Move to: working-docs/projects/{project}/archive/{task-name}/
   - Preserve all session logs and documents

8. Report:
   - "Task '{name}' completed"
   - "Parking lot: {X} items promoted, {Y} deferred, {Z} discarded"
   - "Lessons learned: {count} insights captured"
   - "Task archived to: {archive-path}"
   - "Follow-up tasks: {list if any}"