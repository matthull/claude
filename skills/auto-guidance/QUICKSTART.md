# Auto-Guidance Skill - Quick Start

## TL;DR

The skill is ready to test! It will automatically load guidance when you work with files.

## Test Right Now

### 1. List What's Available
```bash
~/.claude/skills/auto-guidance/list-triggers.sh
```

You should see 15 guidance files with triggers.

### 2. Test Pattern Matching
```bash
~/.claude/skills/auto-guidance/test-patterns.sh
```

This shows which files match which patterns.

### 3. Try It Out

In a new conversation, invoke the skill and work with some files:

```
/auto-guidance

Then try:
- Read a Ruby controller file
- Read a spec file
- Read a Vue component

You should see guidance load automatically like:
📚 Loaded Rails controller guidance (crud-controllers.md)
```

## Expected Behavior

### First File Operation in Session
```
Read app/controllers/users_controller.rb

Expected output:
🔍 Auto-guidance index built: 57 guidance files with triggers
📚 Loaded Rails controller guidance (crud-controllers.md)
[file contents]
```

### Subsequent Matching File
```
Read app/services/user_service.rb

Expected output:
📚 Loaded Rails service guidance (service-objects.md)
[file contents]
```

### Already Loaded Guidance
```
Read app/controllers/posts_controller.rb

Expected output:
[file contents]
(no notification - already loaded controller guidance)
```

### Non-Matching File
```
Read README.md

Expected output:
[file contents]
(no notification - no pattern matches)
```

## Performance Testing

### Enable Tracking
```yaml
# Edit ~/.claude/skills/auto-guidance/config.yaml
performance_tracking: true
```

### Work Normally
Do your normal development work (read files, edit code, etc.)

### Analyze Results
```bash
~/.claude/skills/auto-guidance/analyze-perf.sh
```

### What to Look For
- Pattern matching: Should be <25ms average
- Guidance loading: Should be <100ms average
- No performance warnings

## Troubleshooting

### Skill Not Activating
**Check if skill is loaded:**
```
In Claude: "Am I currently using the auto-guidance skill?"
```

**Activate manually:**
```
/auto-guidance
```

### No Guidance Loading
**Check triggers exist:**
```bash
~/.claude/skills/auto-guidance/list-triggers.sh --verbose
```

**Test your file path:**
```bash
~/.claude/skills/auto-guidance/test-patterns.sh path/to/your/file.rb
```

### Too Many Notifications
**Use silent mode:**
```yaml
# Edit config.yaml
notification: "silent"
```

## Configuration Options

Quick tweaks in `~/.claude/skills/auto-guidance/config.yaml`:

```yaml
# Disable completely
enabled: false

# Silent mode (load but don't notify)
notification: "silent"

# Detailed notifications
notification: "detailed"

# Load more guidance per trigger
max_per_trigger: 3

# Enable performance tracking
performance_tracking: true
```

## Next Steps

1. **Test basic functionality** - Does guidance load automatically?
2. **Check session caching** - Does it avoid reloading?
3. **Measure performance** - Enable tracking and analyze
4. **Refine triggers** - Adjust patterns based on usage
5. **Add more guidance** - Enhance other files with triggers

## Getting Help

**View full documentation:**
```bash
cat ~/.claude/skills/auto-guidance/README.md
```

**Check implementation details:**
```bash
cat ~/.claude/skills/auto-guidance/IMPLEMENTATION_SUMMARY.md
```

**Performance design:**
```bash
cat ~/.claude/skills/auto-guidance/performance-design.md
```

## Ready to Test!

The skill is fully implemented and ready. Just start working with files and watch for guidance loading notifications.

Happy coding! 🚀
