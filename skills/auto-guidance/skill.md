# Auto-Guidance Skill

## Purpose

Automatically load relevant guidance files when reading or editing files based on file patterns and directory locations defined in guidance frontmatter.

## When This Skill Activates

This skill is **always active** when enabled. It monitors file operations and automatically loads guidance when:
- You use the Read tool
- You use the Edit tool
- You use the Write tool
- The file path matches trigger patterns in guidance frontmatter

## Session State (Track in Your Working Memory)

You MUST track these throughout the conversation:

### `guidanceIndex` (built once per session)
A map of file patterns to guidance files:
```
{
  "*.rb": ["testing/test-driven-development.md", "code-quality/immediately-runnable-code.md"],
  "*_controller.rb": ["musashi/rails/crud-controllers.md"],
  "app/services/**": ["musashi/rails/service-objects.md"],
  ...
}
```

### `loadedGuidance` (tracked throughout session)
A set of guidance file paths already loaded this session:
```
Set {
  "testing/test-driven-development.md",
  "musashi/rails/crud-controllers.md"
}
```

### `perfMetrics` (optional, if performance_tracking enabled)
```
{
  indexBuildTime: 150,  // ms
  patternChecks: 45,
  guidanceLoaded: 3,
  avgMatchTime: 8       // ms
}
```

## First Invocation: Build Guidance Index

**On the very first file operation in this session**, you MUST build the guidance index:

### Step 1: Find All Guidance Files

```bash
# Find all guidance markdown files (both global and project-specific)
find ~/.claude/guidance -name "*.md" -type f ! -path "*/bundles/*"
find .claude/guidance -name "*.md" -type f ! -path "*/bundles/*" 2>/dev/null
```

### Step 2: Parse Frontmatter for Triggers

For each guidance file found, read the first 50 lines and extract YAML frontmatter:

```bash
# Extract frontmatter from a guidance file
head -50 ~/.claude/guidance/testing/test-driven-development.md |
  awk '/^---$/{if(++count==2) exit} count==1 && NR>1'
```

Look for these fields in the frontmatter:
- `file_triggers`: Array of file glob patterns
- `directory_triggers`: Array of directory glob patterns

### Step 3: Build Pattern Map

Create a mapping in your working memory:
- Pattern → List of guidance files that should load for that pattern
- Store both file_triggers and directory_triggers
- Handle both global (~/.claude/guidance/) and project (.claude/guidance/) files

### Step 4: Report Index Build

After building index, report:
```
🔍 Auto-guidance index built: {count} guidance files with triggers ({time}ms)
```

## Every File Operation: Check for Matches

**Before or after** using Read/Edit/Write tools, check if auto-guidance should load:

### Step 1: Extract File Path

From the tool call, extract the file path:
- Read tool: `file_path` parameter
- Edit tool: `file_path` parameter
- Write tool: `file_path` parameter

### Step 2: Check Loaded State

Check your `loadedGuidance` set in working memory:
- If this guidance was already loaded this session → **SKIP** (no action needed)
- Otherwise, proceed to pattern matching

### Step 3: Match Against Patterns

Check the file path against patterns in your `guidanceIndex`:

**File Pattern Matching:**
- Use bash pattern matching or simple string comparison
- Examples:
  - `*.rb` matches `user.rb`, `application_controller.rb`
  - `*_controller.rb` matches `users_controller.rb` but not `user.rb`
  - `*_spec.rb` matches `user_spec.rb`

**Directory Pattern Matching:**
- Match full path against directory patterns
- Examples:
  - `app/services/**` matches `app/services/user_service.rb`, `app/services/api/sync_service.rb`
  - `spec/**` matches `spec/models/user_spec.rb`, `spec/services/user_service_spec.rb`
  - `app/controllers/**` matches `app/controllers/users_controller.rb`, `app/controllers/api/v2/users_controller.rb`

**Implementation:**
```bash
# Check if file matches pattern
filepath="app/controllers/users_controller.rb"
pattern="*_controller.rb"

# Simple check
case "$filepath" in
  *$pattern) echo "matches" ;;
esac

# Or for directory patterns
case "$filepath" in
  app/controllers/*) echo "matches" ;;
esac
```

### Step 4: Load Matching Guidance

If matches found and not already loaded:

1. **Select guidance to load:**
   - If multiple matches, load up to 2 guidance files (prioritize project-specific over global)
   - Avoid overloading context window

2. **Load guidance content:**
   ```bash
   # Use Read tool to load the guidance file
   Read ~/.claude/guidance/testing/test-driven-development.md
   ```

3. **Update tracking:**
   - Add to `loadedGuidance` set in your working memory
   - Update performance metrics if tracking

4. **Notify user:**
   ```
   📚 Loaded {category} guidance ({filename})
   ```

   Examples:
   - `📚 Loaded testing guidance (test-driven-development.md)`
   - `📚 Loaded Rails controller guidance (crud-controllers.md)`

### Step 5: Performance Tracking (if enabled)

Track timing for each operation:
- Pattern matching time
- Guidance loading time
- Number of checks vs matches

Every 20 file operations, report summary:
```
📊 Auto-guidance: 20 checks, 3 loaded, avg 8ms
```

## Configuration

Read configuration from `~/.claude/skills/auto-guidance/config.yaml` (if exists):

```yaml
enabled: true               # Master switch
max_per_trigger: 2          # Max guidance files to load per trigger
notification: "brief"       # "brief" | "detailed" | "silent"
performance_tracking: false # Track and report performance
performance_log: "/tmp/claude-auto-guidance-perf.log"
report_interval: 20         # Report perf summary every N ops
```

**Default configuration** (if no config file):
- enabled: true
- max_per_trigger: 2
- notification: "brief"
- performance_tracking: false

## Example Flow

### First File Operation
```
User: [internally uses Read tool on app/controllers/users_controller.rb]

Claude (internal):
  1. Notice this is first file operation
  2. Build guidance index (find + parse frontmatter)
  3. Store index in working memory
  4. Check file path against patterns
  5. Match found: crud-controllers.md
  6. Load guidance via Read tool
  7. Add to loadedGuidance set
  8. Notify user

Claude: 🔍 Auto-guidance index built: 57 guidance files with triggers
📚 Loaded Rails controller guidance (crud-controllers.md)
```

### Subsequent File Operation (Match Found)
```
User: [internally uses Read tool on app/services/user_service.rb]

Claude (internal):
  1. Check guidanceIndex (already built)
  2. Match file path: *_service.rb → service-objects.md
  3. Check loadedGuidance: not loaded yet
  4. Load guidance
  5. Add to loadedGuidance
  6. Notify user

Claude: 📚 Loaded Rails service guidance (service-objects.md)
```

### Subsequent File Operation (Already Loaded)
```
User: [internally uses Edit tool on app/controllers/posts_controller.rb]

Claude (internal):
  1. Check guidanceIndex
  2. Match file path: *_controller.rb → crud-controllers.md
  3. Check loadedGuidance: already loaded
  4. SKIP (no action, no notification)

Claude: [proceeds with edit, no guidance notification]
```

### Subsequent File Operation (No Match)
```
User: [internally uses Read tool on README.md]

Claude (internal):
  1. Check guidanceIndex
  2. No patterns match README.md
  3. SKIP

Claude: [proceeds with read, no guidance notification]
```

## Pattern Matching Reference

### Common File Patterns
- `*.rb` - All Ruby files
- `*_spec.rb` - RSpec test files
- `*_controller.rb` - Rails controllers
- `*_service.rb` - Service objects
- `*.vue` - Vue components
- `*.spec.js` - JavaScript tests
- `*.css`, `*.scss` - Stylesheets

### Common Directory Patterns
- `app/controllers/**` - All controller files
- `app/services/**` - All service files
- `app/models/**` - All model files
- `spec/**` - All test files
- `src/components/**` - Frontend components
- `app/javascript/**` - JavaScript files in Rails

### Matching Logic
Use bash-style glob matching:
- `*` matches any characters (except path separator)
- `**` matches any characters (including path separators)
- Patterns are relative to project root

## Troubleshooting

### Guidance Not Loading
- Check if guidance file has `file_triggers` or `directory_triggers` in frontmatter
- Verify pattern syntax (use bash glob syntax)
- Check if guidance was already loaded this session

### Too Many Guidance Files Loading
- Reduce number of patterns in frontmatter
- Make patterns more specific
- Adjust `max_per_trigger` configuration

### Performance Issues
- Enable `performance_tracking: true` in config
- Check performance log for bottlenecks
- Consider reducing number of guidance files with triggers

## Anti-patterns to Avoid

- **Don't reload already-loaded guidance** - Always check `loadedGuidance` first
- **Don't rebuild index on every operation** - Build once per session only
- **Don't load too many files at once** - Respect `max_per_trigger` limit
- **Don't block file operations** - Guidance loading should be fast and non-blocking
- **Don't notify for skipped loads** - Only notify when actually loading new guidance

## Success Indicators

- Guidance loads automatically when working with relevant files
- No duplicate loading (session tracking works)
- Brief, non-intrusive notifications
- Performance overhead <25ms per file operation
- User finds guidance helpful and timely
