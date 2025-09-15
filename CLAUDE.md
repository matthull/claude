# Personal Claude Code Workflow

## CRITICAL: Git Commit Rules
**Claude MUST NEVER create git commits directly. Only the user creates commits via the `/commit` command.**
This is an absolute rule with no exceptions. Always show changes for review, then wait for the user to run `/commit`.

## Preferred Development Process

@~/.claude/guidance/development-process/tdd-human-review-cycle.md

**Step-by-Step Implementation (within phases):**
1. **Execute One Step at a Time** - Implement only one step from the plan at a time
2. **CRITICAL: All Tests MUST Pass** - Run tests after each change. If ANY test fails or there are issues running tests, STOP immediately and fix them. NEVER proceed to the next step with failing tests. No exceptions.
3. **Commit After Each Step** - After user reviews changes in their editor AND all tests pass, create a git commit for that step
4. **Repeat** - Continue with the next step only after the previous step is committed and all tests are green

**Key Principles:**
- **TEST DISCIPLINE IS NON-NEGOTIABLE:** If tests fail, fixing them is the ONLY priority. Do not move forward, do not pass go, do not collect $200. Fix the tests first.
- User reviews all changes in their code editor before committing
- Each step should be atomic and independently reviewable
- Always wait for user confirmation before proceeding to the next step
- Use descriptive commit messages that explain the "why" not just the "what"
- **Test failures block everything:** A failing test suite means development stops until it's green again

**Task Scope:**
- Prefer incremental improvements over large changes
- Break complex features into smaller, testable components
- Maintain backward compatibility when possible
- Focus on code quality and maintainability
- **Backend First:** When features involve both backend and frontend changes, work on backend first (unless explicitly specified otherwise)

**Communication:**
- Be explicit about what each step will accomplish
- Explain any trade-offs or decisions made during implementation
- Ask clarifying questions when requirements are ambiguous
- Provide context for why specific approaches were chosen
- **Always show color-coded diffs** when displaying git changes to user
- **Balanced Analysis:** Always provide pros/cons when user proposes new ideas - avoid being a "yes man"
- **Critical Thinking:** Challenge assumptions and identify potential issues with proposed changes

**Commit Process:**
- **NEVER CREATE COMMITS DIRECTLY** - Claude must NEVER run `git commit` commands
- **User controls all commits** - Only the user creates commits via `/commit` command
- **Review workflow**: Show changes → User reviews → User runs `/commit` → Commit created
- **Always show diffs first** - Use `git diff --color=always` to show what will be committed
- **Wait for explicit approval** - User must explicitly say to proceed or run `/commit`
- **No exceptions** - This applies to ALL commits, always, without exception

## Modular Guidance Library

Development principles are stored in two locations:
- **Global guidance** (`~/.claude/guidance/`): Universal, language-agnostic principles
- **Project guidance** (`.claude/guidance/`): Framework-specific patterns and team conventions

Use @-references to load only what's needed for the current task, reducing context usage by 60-80%. 

### Reference Syntax
- Global: `@~/.claude/guidance/category/module.md`
- Project: `@.claude/guidance/category/module.md`
- Bundles: `@~/.claude/guidance/bundles/layer/bundle-name.md`

### Loading Bundles Directly
Bundles aggregate related guidance in a 4-layer hierarchy. Load them directly with @-references:
```markdown
# For subagents or specific contexts
@~/.claude/guidance/bundles/technique/rails.md  # Loads Rails + all parent bundles
@~/.claude/guidance/bundles/domain/coding.md     # Loads coding domain + foundation
@~/.claude/guidance/bundles/foundation/software-dev.md  # Base software principles
```

Bundle layers cascade automatically:
- **Foundation** → Base contexts (software-dev, personal-assistant, therapeutic)
- **Domain** → Areas within foundations (coding, architecture, debugging)
- **Practice** → Methodologies (backend, frontend, testing)
- **Technique** → Specific tools (rails, ruby-dev)

### Understanding Frontmatter
All guidance and bundle files use YAML frontmatter to identify their type and context:
```yaml
---
type: guidance         # or 'bundle' for bundle files
status: current       # version status
category: testing     # for guidance files
layer: domain        # for bundle files (foundation/domain/practice/technique)
parent: foundation/software-dev.md  # for bundles (except foundation layer)
context: Active code writing        # when to use this bundle
estimated_lines: 200               # total context size estimate
---
```

When loading via @-references, the system uses this metadata to:
- Identify file type (guidance vs bundle)
- Trace parent relationships for bundles
- Understand appropriate usage context

### Resolution Order
1. When encountering `@.claude/guidance/...`, first check if project guidance exists
2. Project guidance takes precedence over global guidance for the same module name
3. Project guidance can reference global guidance modules

See `~/.claude/guidance/README.md` for global modules and `.claude/guidance/README.md` for project-specific modules.

**CRITICAL: @-Reference Loading Requirement**
When you encounter @-references in any markdown file (e.g., `@~/.claude/guidance/documentation/project-file-organization.md` or `@.claude/guidance/rails/service-objects.md`), you MUST **ALWAYS** immediately load and read the referenced file using the Read tool. These references are modular components that contain essential context and instructions. Never skip or ignore @-references - they are integral parts of the documentation that must be loaded to understand the complete guidance.

## File Organization and Directory Structure

@~/.claude/guidance/documentation/project-file-organization.md

## Clipboard Operations

**Protocol for wl-copy:** When user says "copy [something] to clipboard" or "ready to send", use wl-copy with `run_in_background: true` to avoid hanging. The content is copied immediately even though the command may appear to hang.

Example:
```bash
echo "content here" | wl-copy  # (with run_in_background: true)
```

## Git Workflow

- User handles all git commits and pushes unless Claude is explicitly asked to do so
- User creates branches for tasks and manages merging
- Claude can suggest commit messages and testing approaches
- Create handoff documents for major system changes

## Local Environment
Here are details on the local environment to help identify what tools and processes are available:
- Archlinux OS
- zshrc shell
- chruby to manage ruby versions, nvm for node versions
