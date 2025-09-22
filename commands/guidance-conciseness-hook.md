# Guidance Conciseness Hook

Automatically validates guidance files for conciseness when created or edited.

## Hook Configuration

Add to `.claude/settings.local.json`:

```json
{
  "hooks": {
    "file-write": "~/.claude/commands/check-guidance-conciseness.sh",
    "file-edit": "~/.claude/commands/check-guidance-conciseness.sh"
  }
}
```

## Hook Script

The script checks if:
1. File is in a `guidance/` directory
2. File has `.md` extension
3. Validation fails

If all conditions met, provides specific directives to fix the issues.