# Claude Guidance Library

Concise, universal development principles for AI-assisted development.

## Philosophy

**Context is precious.** Even modular guidance counts against context limits. Each module should be:
- **Frequently loaded**: <50 lines (gemini-review, commit patterns)
- **Standard modules**: 50-100 lines
- **Complex topics**: 100-150 lines max
- **Never exceed**: 200 lines
- **Language-agnostic** (no code samples)
- **Framework-independent** (patterns, not implementations)
- **Immediately actionable** (what to do, what to avoid)
- **Grouped by usage** - Related guidance that gets loaded together should live in the same file

### Writing Priorities
1. **WHAT to do** - Direct actions (80% of content)
2. **WHEN to use** - Clear triggers (15%)
3. **WHY it matters** - Only if non-obvious (5%)

### What to Cut
- Edge cases (handle as they arise)
- Explanations of obvious benefits
- Multiple examples of the same pattern
- Alternative approaches (pick one way)
- Historical context or rationale

### MANDATORY Enforcement
**CRITICAL: All guidance MUST pass enforcement validation. No exceptions.**
@~/.claude/guidance/ai-development/ultra-concise-enforcement.md

## Global vs Project Guidance

### Global Guidance (`~/.claude/guidance/`)
**Definition**: Principles that apply across all projects
- Test-Driven Development principles
- Code review best practices
- API design patterns
- Documentation standards

### Project Guidance (`.claude/guidance/`)
**Definition**: Specific to a single codebase
- Docker commands for this project
- Local development URLs
- Project-specific conventions
- Business domain logic

### Decision Rule
Ask: "Would this guidance be useful in my next project?"
- Yes → Global guidance
- No → Project-specific

## Composing Guidance: The @-Reference Pattern

The `@-reference` pattern enables modular guidance composition and reusability.

### Basic Syntax
- Global: `@~/.claude/guidance/category/module.md`
- Project: `@.claude/guidance/category/module.md`
- Bundles: `@~/.claude/guidance/bundles/layer/bundle-name.md`

### Composition Patterns

#### For Subagents
```markdown
You are a developer following:
@~/.claude/guidance/development-process/incremental-implementation.md
@~/.claude/guidance/testing/testing-strategy.md
```

#### For Specific Tasks
```markdown
When creating migrations, follow:
@~/.claude/guidance/architecture/database-patterns.md
@~/.claude/guidance/testing/migration-testing.md
```

#### In CLAUDE.md
```markdown
## Testing Approach
@~/.claude/guidance/testing/testing-strategy.md
```

## Bundle System

Bundles are **lightweight aggregators** that collect related guidance modules - they contain minimal content themselves, just @-references to actual guidance files.

### Layer Structure
1. **Foundation** - Top-level contexts (software-dev, personal-assistant, therapeutic, creative)
2. **Domain** - Broad areas within foundations (coding, architecture, devops, debugging, data-analysis)
3. **Practice** - Specific methodologies (backend, frontend, testing, database)
4. **Technique** - Specific tools/approaches (rails, ruby-dev, spec-kit)

### Bundle Files vs Guidance Modules
**Bundle files** (~20 lines):
- Located in `bundles/{layer}/{name}.md`
- Contain only @-references to modules
- Include parent bundle reference
- No detailed guidance content
- Just aggregate and organize

**Guidance modules** (50-150 lines):
- Located in `{category}/{topic}.md`
- Contain actual principles and patterns
- Self-contained, actionable guidance
- Where the real content lives

### Bundle Location
- **Global bundles**: `~/.claude/guidance/bundles/{layer}/`
- **Project bundles**: `.claude/guidance/bundles/{layer}/`
- Load with: `/guidance bundle <descriptor>` or direct @-reference

### Bundle Resolution (Project Override)
When loading a bundle, the system checks in this order:
1. **Project bundle first**: `.claude/guidance/bundles/{layer}/{name}.md`
2. **Global bundle fallback**: `~/.claude/guidance/bundles/{layer}/{name}.md`
3. **Project bundles override global**: If both exist, only the project bundle loads

Project bundles can reference their global counterpart as a parent:
```markdown
# .claude/guidance/bundles/practice/architecture.md
---
type: bundle
layer: practice
parent: domain/coding.md
---

## Global Architecture Principles
@~/.claude/guidance/bundles/practice/architecture.md

## Project-Specific Architecture
@.claude/guidance/architecture/service-patterns.md
```

### Examples
- `/guidance bundle rails` → Checks project first, then global
- `/guidance bundle architecture` → Loads project version if exists (which can include global)
- `@.claude/guidance/bundles/practice/architecture.md` → Direct project bundle reference
- `/guidance bundle therapy` → Loads therapeutic foundation

## Creating Effective Guidance Modules

### What to Include
- **Universal principles** - Apply across multiple tech stacks
- **Clear patterns** - What to do and what to avoid
- **Concise guidance** - Every line counts against context
- **Single focus** - One principle per module
- **Grouped by usage** - Guidance loaded together should live together
- **Direct instructions** - See @~/.claude/guidance/ai-development/instruction-clarity.md
- **Action-oriented** - Focus on specific actions and stop points

### What NOT to Include
- Code snippets in specific languages (Ruby, JavaScript, Python, etc.)
- Framework-specific patterns (Rails, React, Vue)
- Verbose explanations or tutorials
- Redundant examples that don't add value
- Implementation details - focus on concepts
- Benefits sections - assume Claude understands why
- Philosophical justifications - just state what to do

### Module Quality Checklist
- [ ] Aim for <200 lines total
- [ ] No language-specific code
- [ ] Would apply to multiple tech stacks
- [ ] Focused on single principle
- [ ] Provides clear value over inline guidance

## Module Template

All guidance modules should include YAML frontmatter per the yaml-frontmatter.md guidance:

```markdown
---
type: guidance
status: current
category: [category-name]
---
# [Principle Name] (< 10 words)

## Overview (2-3 sentences)
Brief summary of the principle.

## Core Concepts (10-20 lines)
- Key principle 1
- Key principle 2

## When to Apply (5-10 lines)
Specific situations.

## Anti-patterns (5-10 lines)
What to avoid.
```

### Template Update (2025-01-15)
Removed Benefits section from template. Claude inherently understands why patterns matter. Every line counts against context.

## Best Practices

### Do's
- ✅ Extract when you find yourself copy-pasting guidance
- ✅ Create modules for cross-cutting concerns
- ✅ Keep modules focused and composable
- ✅ Version control your ~/.claude directory
- ✅ Document why, not just what

### Don'ts
- ❌ Don't create modules for one-time guidance
- ❌ Don't nest @-references (keep it flat)
- ❌ Don't duplicate between global and project
- ❌ Don't create modules smaller than 20 lines
- ❌ Don't include project-specific examples in global modules

## Quality Standards

✅ **Good Module:**
- Single, focused principle
- Universal across tech stacks
- Clear do's and don'ts
- Aim for <200 lines

❌ **Bad Module:**
- Language-specific code examples
- Framework-specific patterns
- Verbose explanations
- Over 200 lines without justification

## Discovering Available Modules

### List All Modules
```bash
# Global modules
find ~/.claude/guidance -name "*.md" -type f | sort

# Project modules
find .claude/guidance -name "*.md" -type f 2>/dev/null | sort

# Bundles
find ~/.claude/guidance/bundles -name "*.md" -type f | sort
```

---
*Remember: Every line counts against context. Be ruthlessly concise.*
