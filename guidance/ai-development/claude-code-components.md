---
type: guidance
status: current
category: ai-development
tags:
- claude-code
- architecture
focus_levels:
- design
---

# Claude Code Architecture Components

## Output Styles
**Role:** System prompt modification

**Use When:**
- Base personality change
- All interactions affected
- Behavior mode switching

**Location:** `.claude/output-styles/*.md`

**Characteristics:**
- Modifies system prompt
- Global scope
- Persistent across sessions
- Cannot stack

**Switch:** `/output-style [name]`
**Config:** Saved in `.claude/settings.local.json`

## Subagents
**Role:** Isolated task specialists

**Use When:**
- Complex specialized work
- Context preservation critical
- Different permissions needed
- Reusable patterns

**Location:** `.claude/agents/*.md`

**Config:**
```yaml
---
name: specialist
description: When to invoke
tools: Read, Grep, Bash
model: inherit
---
System prompt
```

**Invoke:** Task tool (automatic/manual)

**Characteristics:**
- Separate context window
- Specialized prompts
- Granular permissions
- Parallel capable
- Setup overhead

## Commands
**Role:** In-context workflows

**Use When:**
- Repetitive actions
- Bash execution
- Simple arguments
- File references

**Location:** `.claude/commands/*.md`

**Syntax:** `/command [args]`

**Features:**
- Arguments: `$1`, `$2`, `$ARGUMENTS`
- Files: `@path`
- Bash support

**Characteristics:**
- No context switch
- Discoverable
- Shared permissions
- Limited isolation

## Decision Matrix

| Need | Use |
|------|-----|
| Base behavior | Output Style |
| Complex isolation | Subagent |
| Quick workflow | Command |

## Architecture
```
Output Style (Base Layer)
  ↓
Main Conversation
  ├─→ Commands (Quick)
  └─→ Subagents (Specialists)
```
