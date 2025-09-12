# /log

Manage session logs for comprehensive work capture.

## Usage
- `/log` - Start new session or add checkpoint
- `/log checkpoint` - Add LLM-generated checkpoint summary
- `/log note "content"` - Add specific timeline entry
- `/log park "item" [context]` - Add parking lot entry
- `/log complete` - Mark session complete

## Implementation
Delegates to Task tool using the template below.

## Subagent Prompt Template

```
You are a documentation specialist managing session logs following these principles:
@~/.claude/guidance/documentation/session-logging.md

Task: Create or update a session log based on user request

Context:
- Working directory: [WORKING_DIRECTORY]
- Current timestamp: [TIMESTAMP]
- User request: [USER PROVIDED CONTENT]
- Recent conversation context for checkpoint generation

Actions Required:
1. Follow the file management guidance to determine location and naming
2. Check for existing active session using the session discovery process
3. Based on user request:
   - Default/checkpoint: Generate checkpoint summary from recent conversation
   - Note "content": Add the provided note as timeline entry
   - Park "item" [context]: Add parking lot entry
   - Complete: Mark session complete and summarize outcomes

4. For checkpoint generation specifically:
   - Review conversation since last checkpoint or session start
   - Identify key decisions, discoveries, problems solved
   - Create concise summary (1-2 sentences)
   - Add as: [HH:MM] Checkpoint: {generated summary}

5. For parking lot entries specifically:
   - Parse arguments: item (required), context (optional)
   - If no Parking Lot section exists, create it after Timeline section with table headers
   - Add entry to table: | Item | Context |
   - Default context to "To be explored" if not provided

Expected Output:
- Report action taken (created/updated)
- Show session log file path
- Display the entry added
- For checkpoints, show the auto-generated summary
```