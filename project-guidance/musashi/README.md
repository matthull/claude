# Project-Specific Guidance for Musashi

This directory contains project-specific guidance modules that supplement the global guidance library.

## Purpose

While global guidance (`~/.claude/guidance/`) contains universal, language-agnostic principles,
project guidance contains:
- Rails-specific patterns and conventions
- Team workflow standards
- Domain-specific business logic patterns
- Framework-specific best practices

## Categories

- `rails/` - Rails framework patterns and conventions
- `testing/` - Project-specific testing approaches (RSpec, fixtures, etc.)
- `frontend/` - Vue.js and frontend patterns specific to this app
- `workflow/` - Team processes and conventions

## Usage

Reference project guidance in CLAUDE.md or subagents:
```markdown
@.claude/guidance/rails/service-objects.md
@.claude/guidance/testing/fixture-usage.md
```

## Adding New Guidance

Use the `/add-guidance project` command:
```
/add-guidance project rails-service-objects "Service object patterns for Rails..."
```

## Relationship to Global Guidance

- Global: Universal principles that apply across all projects
- Project: Specific implementations of those principles for this Rails app
- Project guidance can reference global guidance
- When conflicts arise, project guidance takes precedence

## Quality Standards

Project guidance can be more lenient than global:
- Up to 300 lines (vs 150 for global)
- Can include code examples in Ruby/JavaScript
- Can reference specific gems, libraries, or frameworks
- Should still be concise and actionable