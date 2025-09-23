# Compress Guidance with LLMLingua

Compress guidance files using LLMLingua to reduce token usage.

## Usage
```
/compress-guidance [arguments]
```

## Examples
```bash
/compress-guidance --large                    # Files >200 lines
/compress-guidance --large --min 300          # Files >300 lines
/compress-guidance file1.md file2.md          # Specific files
/compress-guidance --dir documentation        # All in directory
/compress-guidance --unstaged                 # Git unstaged files
/compress-guidance --ratio 0.3 --large        # Custom compression
/compress-guidance --dry-run --large          # Preview without compressing
```

## Implementation

Runs the CLI tool directly with passed arguments.

## Subagent Prompt Template

You are running the compress-guidance CLI tool.

User Request: [USER PROVIDED CONTENT]

Execute this command:
```bash
~/.claude/python-env/bin/python ~/.claude/commands/compress-guidance-cli.py [USER PROVIDED CONTENT]
```

Report the output directly. The tool will:
- Find files matching criteria
- Compress them with LLMLingua
- Create .original.md and .compressed.md files
- Show statistics and next steps

DO NOT create any Python files or implement compression logic.
Just run the existing CLI tool and report results.