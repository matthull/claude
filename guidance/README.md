# Claude Guidance Library

## Module Limits
- Frequently loaded: <50 lines
- Standard modules: 50-100 lines
- Complex topics: 100-150 lines
- Never exceed: 200 lines

## Requirements
- Language-agnostic
- Framework-independent
- Immediately actionable
- Pass @~/.claude/guidance/ai-development/ultra-concise-enforcement.md

## Global vs Project
- **Global** (`~/.claude/guidance/`): Works across projects
- **Project** (`.claude/guidance/`): Single codebase only

## @-Reference Syntax
- Global: `@~/.claude/guidance/category/module.md`
- Project: `@.claude/guidance/category/module.md`
- Bundles: `@~/.claude/guidance/bundles/layer/bundle-name.md`

## Bundle Layers
1. **Foundation**: software-dev, personal-assistant, creative
2. **Domain**: coding, architecture, devops, debugging
3. **Practice**: backend, frontend, testing, database
4. **Technique**: rails, ruby-dev, spec-kit

## Module Template
```markdown
---
type: guidance
status: current
category: [category-name]
---
# [Principle Name]

## Core Concepts
- Key principle 1
- Key principle 2

## When to Apply
Specific triggers

## Anti-patterns
What to avoid
```

## Discovery Commands
```bash
find ~/.claude/guidance -name "*.md" -type f | sort
find .claude/guidance -name "*.md" -type f | sort
```