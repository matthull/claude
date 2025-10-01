---
type: guidance
status: current
category: code-review
---

# Gemini Review Pattern

## Core Principle
Keep Claude context minimal. Give Gemini everything.

## What to Send Gemini
```bash
# Kitchen sink approach - send ALL of:
- Entire directories: "app/models/", "spec/", "frontend/components/"
- All project docs: "working-docs/projects/", ".claude/", "*.md"
- Related modules: entire feature directories, all tests
- Project context: package.json, Gemfile, configs, schemas
```

## When to Use
- **Pre-commit reviews**: Before any git commit
- **Architecture checks**: After implementing new patterns
- **Test coverage**: After writing new features
- **Cross-module impact**: When changing shared code

## Required Tool
**ALWAYS use:** `mcp__gemini-bridge__consult_gemini_with_files`

**NEVER use:** `mcp__gemini-bridge__consult_gemini` (no file context)

## Basic Commands
```bash
# Full module review
mcp__gemini-bridge__consult_gemini_with_files
  query: "Review this Rails controller for patterns, security, performance"
  directory: "/path/to/project"
  files: ["app/controllers/", "app/models/", "spec/controllers/", "config/routes.rb"]

# Architecture validation
mcp__gemini-bridge__consult_gemini_with_files
  query: "Does this follow our architecture patterns? Check against all project docs"
  directory: "/path/to/project"
  files: ["app/services/", "working-docs/", ".claude/", "spec/"]
```

## Key Patterns
1. **Never summarize for Gemini** - Send full files/directories
2. **Include tests with code** - Always send spec/ with app/
3. **Include project context** - Send .claude/ and working-docs/
4. **Ask specific questions** - "Check X against Y patterns"
5. **Use after Claude changes** - Not during (keep Claude fast)

## Don't Load in Claude
- Large test outputs
- Full directory listings
- Entire documentation trees
- Multiple file contents for review

Just send them all to Gemini instead.