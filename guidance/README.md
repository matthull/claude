# Claude Guidance Library

## Guidance Types

### 1. Behavioral Constraints (System Prompt)
- **Location**: `~/.claude/prompts/core-mandates.md`
- **Loaded via**: Shell alias with `--append-system-prompt`
- **Purpose**: Non-negotiable behavioral rules
- **Use for**: Testing discipline, verification requirements, permission gates
- **Keywords**: MUST, NEVER, ALWAYS, ABSOLUTE, CRITICAL

### 2. Context Guidance (This Library)
- **Location**: `~/.claude/guidance/` or `.claude/guidance/`
- **Loaded via**: @-references in CLAUDE.md or explicit loading
- **Purpose**: Informational principles, patterns, best practices
- **Use for**: Implementation details, framework patterns, code quality standards

### 3. Project Context (CLAUDE.md)
- **Location**: `~/.claude/CLAUDE.md` (global) or `./.claude/CLAUDE.md` (project)
- **Loaded**: Automatically at startup
- **Purpose**: Project-specific workflows, environment details
- **Use for**: Conventions, preferences, modular guidance loading

**Decision Test**: Does this constrain behavior (→ System Prompt) or provide information (→ Guidance)?

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

### Standard Guidance
```markdown
---
type: guidance
status: current
category: [category-name]
focus_levels:
- strategic | design | implementation
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

### Behavioral Directive (for System Prompt)
```markdown
## [SECTION NAME] (ABSOLUTE)

- You **MUST NEVER** [prohibited action]
- You **MUST ALWAYS** [required action]
- **IF [trigger condition]:** You **MUST IMMEDIATELY STOP** and initiate STOP-and-Ask

**RATIONALE:** [One sentence why this matters]
```

**Directive Keywords (by strength):**
- ABSOLUTE, CRITICAL, NON-NEGOTIABLE (highest priority)
- MUST, NEVER, ALWAYS (core requirements)
- IMMEDIATELY STOP (trigger actions)
- NO EXCEPTIONS (prevent rationalization)

## Validation Strategies

### 1. Behavioral Constraint Tests
- **Bypass Test**: Can you rationalize an exception? (Should be NO)
- **Ambiguity Test**: Can this be misinterpreted? (Should be NO)
- **Trigger Test**: Is it clear when this applies? (Should be YES)
- **Consequence Test**: What happens if violated? (Should be explicit)

### 2. Context Guidance Tests
- **Conciseness Test**: Can you remove 50% of words? (If yes, DO IT)
- **Actionability Test**: Can someone immediately apply this? (Should be YES)
- **Specificity Test**: Are examples concrete? (Should be YES)
- **Universality Test**: Works across projects/languages? (For global guidance: YES)

### 3. Red-Team Testing
Attempt to bypass directives with:
- "Just this once..."
- "It's faster if I..."
- "The user probably wants..."
- "Standard practice is..."

If directive can be rationalized away, strengthen it.

## Discovery Commands
```bash
# Find guidance modules
find ~/.claude/guidance -name "*.md" -type f | sort
find .claude/guidance -name "*.md" -type f | sort

# View system prompt mandates
cat ~/.claude/prompts/core-mandates.md
```