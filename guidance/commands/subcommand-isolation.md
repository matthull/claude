---
type: guidance
status: current
category: commands
---

# Subcommand Isolation Pattern

## Problem
Commands with multiple subcommands (e.g., `/task init`, `/task resume`, `/task complete`) can waste significant context when all subcommand prompts are embedded in the main command file, even though only one subcommand is executed per invocation.

## Solution
Store each subcommand's prompt in a separate file and load only the relevant file when executing.

## Directory Structure
```
~/.claude/commands/
├── {command}.md                    # Main command file with usage and routing
└── {command}-subcommands/          # Directory for subcommand prompts
    ├── {subcommand1}.md            # Individual subcommand prompt
    ├── {subcommand2}.md            # Individual subcommand prompt
    └── {subcommand3}.md            # Individual subcommand prompt
```

## Main Command File Pattern
```markdown
# /{command}

Brief description of the command's purpose.

## Usage
- `/{command} {subcommand1}` - Description
- `/{command} {subcommand2}` - Description
- `/{command} {subcommand3}` - Description

## Implementation
This command delegates to the Task tool with subcommand-specific prompts. To minimize context usage, each subcommand prompt is stored in a separate file and loaded only when needed.

## Subcommand Files
- `{command}-subcommands/{subcommand1}.md` - Description
- `{command}-subcommands/{subcommand2}.md` - Description
- `{command}-subcommands/{subcommand3}.md` - Description

When executing a subcommand, load ONLY the corresponding file from `~/.claude/commands/{command}-subcommands/`.
```

## Subcommand File Pattern
```markdown
---
type: subcommand
parent: {command}
name: {subcommand}
---

# /{command} {subcommand}

[Full prompt for this specific subcommand]
```

## When to Apply
Use this pattern when:
- A command has 3+ subcommands
- Each subcommand has a substantial prompt (>30 lines)
- Subcommands are functionally independent
- Total command file would exceed 200 lines

## Example: /task Command
```
~/.claude/commands/
├── task.md                         # Main routing (25 lines)
└── task-subcommands/
    ├── init.md                     # Initialize task (50 lines)
    ├── resume.md                   # Resume task (50 lines)
    ├── pause.md                    # Pause task (45 lines)
    └── complete.md                 # Complete task (75 lines)
```

Result: Loading `/task complete` uses ~100 lines instead of ~245 lines.

## Implementation Notes
- The main command file should contain minimal logic - just usage documentation and routing instructions
- Each subcommand file should be self-contained with all necessary context
- Use YAML frontmatter in subcommand files to indicate parent command and type
- Reference guidance modules with @-syntax within subcommand files as needed