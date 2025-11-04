---
type: guidance
status: current
category: documentation
tags:
  - frontmatter
  - triggers
  - automation
focus_levels:
  - strategic
  - design
---

# Trigger Frontmatter Schema

## Overview
Guidance files can specify automatic loading triggers based on file patterns and directory locations. When Claude reads or edits files matching these patterns, the corresponding guidance will be automatically loaded (once per session).

## Schema Fields

### `file_triggers` (optional)
Array of glob patterns matching file names or extensions.

**Examples:**
```yaml
file_triggers:
  - "*.rb"           # All Ruby files
  - "*.rake"         # Rake files
  - "Gemfile"        # Specific filename
  - "*.spec.ts"      # TypeScript test files
  - "*.test.js"      # JavaScript test files
```

### `directory_triggers` (optional)
Array of glob patterns matching directory paths (supports `**` for recursive matching).

**Examples:**
```yaml
directory_triggers:
  - "app/controllers/**"     # All files in controllers directory
  - "spec/**"                # All files in spec directory
  - "test/**"                # All files in test directory
  - "src/components/**/*.tsx"  # React components
  - "app/services/**"        # Service objects
```

## Complete Example

```yaml
---
type: guidance
status: current
category: testing
tags:
  - ruby
  - rspec
  - testing
focus_levels:
  - implementation

# Automatic triggers
file_triggers:
  - "*.spec.rb"
  - "*_spec.rb"
directory_triggers:
  - "spec/**"
  - "test/**"
---

# Testing Guidance Content...
```

## Trigger Resolution Rules

1. **File triggers are checked first** - exact filename or extension match
2. **Directory triggers are checked second** - full path matching
3. **Both global and project triggers apply** - project triggers add to global, don't replace
4. **Session caching** - guidance loaded once per conversation, not reloaded on subsequent matches
5. **Max limit** - configurable max guidance files per trigger event (default: 2)

## Pattern Syntax

Uses standard glob syntax:
- `*` - matches any characters except path separator
- `**` - matches any characters including path separators (recursive)
- `?` - matches single character
- `[abc]` - matches any character in set
- `{a,b}` - matches either pattern

## Guidelines

### When to Add Triggers
- **Do add triggers** when guidance applies to specific file types or project areas
- **Don't add triggers** for guidance that's context-dependent or strategic-level

### Good Trigger Candidates
- Language-specific guidance (Ruby, JavaScript, etc.)
- Framework-specific guidance (Rails, React, etc.)
- Testing guidance (when in test directories)
- Domain-specific guidance (controllers, services, components)

### Poor Trigger Candidates
- Architecture decisions (too high-level)
- Communication guidelines (not file-specific)
- Project planning (manually loaded)
- Therapeutic guidance (context-dependent)

## Naming Conventions

**File patterns:**
- Use lowercase
- Include common variations (both `*.spec.rb` and `*_spec.rb`)
- Consider different naming styles in the ecosystem

**Directory patterns:**
- Use relative paths from project root
- End with `/**` for recursive matching
- Consider common project structures

## Testing Triggers

To test if triggers work correctly:

1. Create a test file matching the pattern
2. Use Claude Code to read the file
3. Check for guidance loading notification
4. Verify guidance was loaded via `@.claude/guidance/...` reference

## Migration Path

### Phase 1: High-Value Files (Week 1)
Enhance 15 most-used guidance files with triggers:
- Rails/Ruby guidance
- Testing guidance
- Frontend framework guidance

### Phase 2: Comprehensive Coverage (Ongoing)
Add triggers to remaining guidance files as patterns become clear.

### Phase 3: Project-Specific (As Needed)
Projects can add custom triggers in `.claude/guidance/` files.
