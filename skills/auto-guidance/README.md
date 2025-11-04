# Auto-Guidance Skill

Automatically load relevant guidance files when Claude reads or edits files, based on file patterns and directory locations.

## What It Does

When you work with files in Claude Code, the auto-guidance skill:
1. Detects what type of file you're working with
2. Automatically loads relevant guidance from your guidance library
3. Applies that guidance to the current task
4. Loads each guidance file only once per conversation (session caching)

**Example:**
```
You: Read app/controllers/users_controller.rb

Claude: 📚 Loaded Rails controller guidance (crud-controllers.md)
[proceeds to read the file with controller patterns in mind]
```

## How It Works

### Trigger System

Guidance files can define automatic triggers in their frontmatter:

```yaml
---
type: guidance
category: rails

# Automatic triggers
file_triggers:
  - "*_controller.rb"
  - "*_controller_spec.rb"
directory_triggers:
  - "app/controllers/**"
  - "spec/requests/**"
---
```

When Claude reads/edits a file matching these patterns, that guidance automatically loads.

### Session Caching

- Guidance loads once per conversation
- Subsequent operations on similar files reuse already-loaded guidance
- No duplicate loading = faster, cleaner conversations

## Installation

The skill is already set up! It includes:
- `skill.md` - Main skill instructions
- `config.yaml` - Configuration options
- `list-triggers.sh` - List all guidance files with triggers
- `test-patterns.sh` - Test pattern matching logic
- `analyze-perf.sh` - Analyze performance logs

## Configuration

Edit `~/.claude/skills/auto-guidance/config.yaml`:

```yaml
# Enable/disable the skill
enabled: true

# Max guidance files to load per trigger
max_per_trigger: 2

# Notification style: "brief", "detailed", or "silent"
notification: "brief"

# Performance tracking (for debugging)
performance_tracking: false
```

## Usage

### Automatic (Default)

Just work normally! When you read/edit files, relevant guidance loads automatically:

```
Read app/services/user_service.rb
→ 📚 Loaded Rails service guidance (service-objects.md)

Edit spec/models/user_spec.rb
→ 📚 Loaded testing guidance (test-driven-development.md)

Read app/components/UserProfile.vue
→ 📚 Loaded Vue component guidance (component-patterns.md)
```

### Manual Control

**Disable temporarily:**
```
Edit config.yaml and set: enabled: false
```

**Silent mode (load but don't notify):**
```
Edit config.yaml and set: notification: "silent"
```

**Check what's loaded this session:**
Ask Claude: "What guidance files have you loaded this session?"

## Adding Triggers to Guidance

To make guidance files trigger automatically, add frontmatter:

### File Pattern Triggers

Trigger when filename matches a pattern:

```yaml
file_triggers:
  - "*.rb"              # All Ruby files
  - "*_controller.rb"   # Controllers only
  - "*_spec.rb"         # RSpec files
  - "*.vue"             # Vue components
```

### Directory Pattern Triggers

Trigger when file is in a specific directory:

```yaml
directory_triggers:
  - "app/controllers/**"    # All files in controllers
  - "spec/**"               # All files in spec directory
  - "src/components/**"     # Frontend components
```

### Example: Adding Triggers

```bash
# Edit a guidance file
vim ~/.claude/guidance/testing/test-driven-development.md

# Add to frontmatter:
---
type: guidance
status: current
category: testing

# Automatic triggers
file_triggers:
  - "*_spec.rb"
  - "*.spec.js"
directory_triggers:
  - "spec/**"
  - "test/**"
---
```

## Testing

### List Guidance with Triggers

```bash
~/.claude/skills/auto-guidance/list-triggers.sh

# Verbose mode (shows actual patterns)
~/.claude/skills/auto-guidance/list-triggers.sh --verbose
```

### Test Pattern Matching

```bash
# Test all common file paths
~/.claude/skills/auto-guidance/test-patterns.sh

# Test specific file
~/.claude/skills/auto-guidance/test-patterns.sh app/services/user_service.rb
```

### Performance Analysis

Enable performance tracking in `config.yaml`:
```yaml
performance_tracking: true
performance_log: "/tmp/claude-auto-guidance-perf.log"
```

Then analyze:
```bash
~/.claude/skills/auto-guidance/analyze-perf.sh
```

## Current Guidance with Triggers

15 guidance files currently have automatic triggers:

### Global Guidance
1. **testing/test-driven-development.md** - Test files (*.spec.rb, spec/**)
2. **development-process/tdd-human-review-cycle.md** - Test files
3. **frontend/css-architecture.md** - CSS files (*.css, *.scss)
4. **frontend/debugging-workflow.md** - Frontend files (*.js, *.vue)
5. **code-quality/immediately-runnable-code.md** - All code files (*.rb, *.js, etc.)
6. **code-quality/general-code-writing.md** - All code files

### Musashi Project Guidance
7. **rails/service-objects.md** - Service files (*_service.rb, app/services/**)
8. **rails/crud-controllers.md** - Controllers (*_controller.rb, app/controllers/**)
9. **rails/models.md** - Models (app/models/**)
10. **rails/backend-testing.md** - Test files (*_spec.rb, spec/**)
11. **rails/fixture-based-testing.md** - Test files and fixture_builder.rb
12. **vue/component-patterns.md** - Vue files (*.vue, src/components/**)
13. **vue/frontend-testing.md** - Frontend tests (*.spec.js)
14. **vue/styling-patterns.md** - Vue and styles (*.vue, *.scss)
15. **rails/api-patterns.md** - API controllers (app/controllers/api/**)

## Troubleshooting

### Guidance Not Loading

**Problem:** Expected guidance doesn't load when working with a file.

**Solutions:**
1. Check if guidance has triggers:
   ```bash
   ~/.claude/skills/auto-guidance/list-triggers.sh --verbose | grep "your-guidance-file"
   ```

2. Test if pattern matches your file:
   ```bash
   ~/.claude/skills/auto-guidance/test-patterns.sh path/to/your/file.rb
   ```

3. Check if already loaded this session:
   Ask Claude: "Have you loaded [guidance-name] this session?"

### Too Many Notifications

**Problem:** Guidance loading notifications are distracting.

**Solutions:**
1. Use silent mode:
   ```yaml
   notification: "silent"
   ```

2. Or reduce triggers by making patterns more specific

### Performance Concerns

**Problem:** File operations feel slower.

**Solutions:**
1. Enable performance tracking:
   ```yaml
   performance_tracking: true
   ```

2. Run analysis:
   ```bash
   ~/.claude/skills/auto-guidance/analyze-perf.sh
   ```

3. If pattern matching >50ms, reduce number of guidance files with triggers

4. Temporarily disable:
   ```yaml
   enabled: false
   ```

## Pattern Matching Reference

### File Patterns (glob syntax)
- `*.rb` - All Ruby files
- `*_controller.rb` - Controllers only
- `*_spec.rb` - RSpec test files
- `*.spec.js` - Jest test files
- `*.vue` - Vue components
- `Gemfile` - Specific filename

### Directory Patterns
- `app/controllers/**` - All files in controllers (recursive)
- `spec/**` - All files in spec directory
- `src/components/**/*.vue` - Vue files in components only

### Matching Rules
- File patterns match against filename only
- Directory patterns match against full path
- `**` matches recursively (multiple directory levels)
- `*` matches any characters (within single level)
- Patterns are case-sensitive

## Best Practices

### Writing Triggers

**Do:**
- Start with specific patterns (*_controller.rb, not *.rb)
- Use directory patterns for scoped guidance
- Test patterns before committing
- Add triggers to high-value guidance first

**Don't:**
- Make patterns too broad (avoid loading on every file)
- Add triggers to general/strategic guidance
- Create many similar patterns (consolidate)

### Managing Guidance

**Do:**
- Keep guidance focused and concise
- Use one guidance file per concept
- Review what's loading during actual work
- Remove/adjust triggers that aren't helpful

**Don't:**
- Load too much guidance at once
- Duplicate content across multiple guidance files
- Add triggers "just in case"

## FAQ

**Q: How do I know what guidance is loaded?**
A: Ask Claude: "What guidance have you loaded this session?"

**Q: Can I reload guidance that was already loaded?**
A: No - session caching prevents reloading. Start a new conversation to reset.

**Q: Does this work with project-specific guidance?**
A: Yes! Both `~/.claude/guidance/` and `.claude/guidance/` are scanned.

**Q: What's the performance impact?**
A: ~5-15ms per file operation for pattern matching, ~50-100ms when loading guidance.

**Q: Can I have guidance load on multiple patterns?**
A: Yes! Add multiple patterns to file_triggers or directory_triggers arrays.

**Q: What if multiple guidance files match?**
A: Up to `max_per_trigger` files load (default: 2). Priority: project-specific first.

**Q: Can I exclude certain files?**
A: Yes, use `exclude_patterns` in config.yaml.

## Support

For issues or questions:
1. Check this README
2. Run diagnostic scripts (list-triggers.sh, test-patterns.sh)
3. Enable verbose mode in config.yaml
4. Check guidance frontmatter syntax

## Related Documentation

- `~/.claude/guidance/documentation/trigger-frontmatter-schema.md` - Trigger syntax reference
- `~/.claude/guidance/documentation/trigger-enhancement-plan.md` - Implementation plan
- `performance-design.md` - Performance tracking design

## Version History

- **v1.0** - Initial release with file/directory triggers, session caching, performance tracking