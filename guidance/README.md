# Claude Guidance Library

Concise, universal development principles for AI-assisted development.

## Philosophy

**Context is precious.** Even modular guidance counts against context limits. Each module should be:
- **Aim for <200 lines** (ideally 50-150)
- **Language-agnostic** (no code samples)
- **Framework-independent** (patterns, not implementations)
- **Immediately actionable** (what to do, what to avoid)

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

Bundles aggregate related guidance through a 4-layer hierarchy for loading common sets of principles together:

### Layer Structure
1. **Foundation** - Top-level contexts (software-dev, personal-assistant, therapeutic, creative)
2. **Domain** - Broad areas within foundations (coding, architecture, devops, debugging, data-analysis)
3. **Practice** - Specific methodologies (backend, frontend, testing, database)
4. **Technique** - Specific tools/approaches (rails, ruby-dev)

### Bundle Files
Bundles aggregate related guidance through @-references:
- Located in: `bundles/foundation/`, `bundles/domain/`, `bundles/practice/`, `bundles/technique/`
- Inherit from parent layers automatically
- Include relevant individual guidance modules
- Load with: `/guidance bundle <descriptor>` or direct @-reference

### Examples
- `/guidance bundle rails` → Loads full Rails stack (technique → practice → domain → foundation)
- `@~/.claude/guidance/bundles/domain/coding.md` → Loads coding domain + foundation
- `/guidance bundle therapy` → Loads therapeutic foundation

## Creating Effective Guidance Modules

### What to Include
- **Universal principles** - Apply across multiple tech stacks
- **Clear patterns** - What to do and what to avoid
- **Concise guidance** - Every line counts against context
- **Single focus** - One principle per module
- **Direct instructions** - Tell Claude WHAT to do, not why
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

## Benefits (3-5 lines)
Why this matters.
```

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

### Quick Reference (Key Modules)

#### Core Development
- `development-process/incremental-implementation.md` - Step-by-step workflow
- `development-process/tdd-human-review-cycle.md` - TDD with review gates
- `testing/testing-strategy.md` - Comprehensive testing approach
- `communication/balanced-analysis.md` - Critical thinking & pros/cons

#### Quality & Safety
- `git/commit-verification-workflow.md` - Commit quality standards
- `code-quality/error-handling.md` - Error handling principles
- `security/validation-and-authorization.md` - Input validation & access
- `security/code-security-boundaries.md` - Security boundaries

#### Architecture & Documentation
- `documentation/project-file-organization.md` - Directory structure
- `documentation/requirements.md` - Requirements documentation
- `frontend/css-architecture.md` - CSS best practices
- `ai-development/command-task-isolation.md` - Task delegation patterns

---
*Remember: Every line counts against context. Be ruthlessly concise.*