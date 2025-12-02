# Claude Code Configuration

Personal Claude Code configuration for `~/.claude/`.

## Core Development Workflow

The primary workflow for feature development:

```
/spec → /taskout → /handoff → /implement
```

### 1. `/spec <feature-description>`
Create a technical specification defining WHAT to build.
- Brownfield discovery (search existing patterns first)
- API contracts and data shapes
- Third-party API research if applicable
- Generates `verify-specs.sh` for backend work

**Output:** `specs/<feature>/spec.md` (+ `api-reference.md`, `verify-specs.sh`)

### 2. `/taskout <spec-file>`
Generate TDD-focused task list from specification.
- Breaks spec into verifiable tasks
- Identifies dependencies and parallel opportunities
- Links tasks to spec line numbers

**Output:** `specs/<feature>/tasks.md`

### 3. `/handoff <tasks-file> <task-numbers>`
Generate detailed handoff documents for implementation.
- Reads prerequisite docs (spec, design docs)
- Discovers reusable code patterns
- Composes from modular templates
- Supports parallel generation: `/handoff @tasks.md task 1.1 1.2 1.3`

**Output:** `specs/<feature>/task-handoffs/T001-description.md`

### 4. `/implement <tasks-file-or-directory>`
Coordinate implementation using subagents.
- Lean coordination mode (minimal context usage)
- Launches implementation subagents per task
- Mandatory verification after each task
- Switches to debug mode on blockers

---

## Directory Structure

```
~/.claude/
├── commands/           # Slash commands (/spec, /taskout, etc.)
├── guidance/           # Modular principles (load with @-references)
│   ├── development-process/
│   ├── testing/
│   ├── api-development/
│   └── bundles/        # Aggregated guidance bundles
├── templates/          # Task handoff templates
│   └── task/
│       ├── core-task-template.md
│       └── sections/   # Composable template sections
└── plans/              # Plan mode working files
```

## Key Commands Reference

| Command | Purpose |
|---------|---------|
| `/spec` | Create technical specification |
| `/taskout` | Generate task list from spec |
| `/handoff` | Create implementation handoff docs |
| `/implement` | Coordinate task implementation |
| `/commit` | Create git commit (user-controlled) |
| `/task-review` | Review uncommitted code against handoff |
| `/validate-and-fix` | Run quality checks and fix issues |

## Guidance System

Load guidance modules with `@`-references:

```markdown
# Global guidance
@~/.claude/guidance/testing/test-driven-development.md

# Project guidance (takes precedence)
@.claude/guidance/rails/service-objects.md

# Bundles (aggregate related modules)
@~/.claude/guidance/bundles/technique/rails.md
```

## Key Principles

These are embedded throughout commands and guidance:

1. **WHAT, Not HOW** - Specs define outcomes, not implementations
2. **Brownfield First** - Search existing patterns before creating new
3. **TDD Cycle** - RED → GREEN → REFACTOR with human review
4. **Verification Principle** - Never guess APIs, verify from docs/code
5. **Testing Discipline** - Never skip tests, never proceed with failures
