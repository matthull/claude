---
type: guidance
status: current
category: development-process
---

# TDD with Mandatory Human Review

## Overview
Test-driven development cycle with mandatory human review after green phase, before any refactoring or proceeding to next cycle.

## Core Cycle Steps
1. **RED** - Write failing test that captures next requirement
2. **GREEN** - Write minimal code to make test pass
3. **STOP** - Mandatory human review before proceeding
4. **REFACTOR** - Only proceed if human approves
5. **COMMIT** - One complete cycle = one commit
6. **REPEAT** - Next cycle only after current cycle committed

## Human Review Requirements
- **ALWAYS** stop after GREEN phase
- **NEVER** proceed to refactor without explicit human approval
- **SHOW** current test status and minimal implementation
- **WAIT** for human confirmation before refactoring
- **ASK** "Ready to refactor?" or "Proceed to next cycle?"

## Review Points
- Test correctly captures requirement
- Minimal implementation passes test
- No accidental over-implementation
- Test quality and coverage
- Implementation approach alignment

## Commit Strategy
- One TDD cycle = one commit
- Include both test and implementation
- Descriptive commit message explaining the cycle's goal
- Never commit partial cycles

## Anti-patterns
- **NEVER** skip human review after green
- **NEVER** refactor without approval
- **NEVER** write multiple tests before going green
- **NEVER** implement beyond test requirements
- **NEVER** commit without completing full cycle

## When to Apply
- Feature development requiring test coverage
- Bug fixes that need regression tests
- Refactoring that must preserve behavior
- Learning new codebases through tests

## Communication Pattern
```
Claude: "✅ Test passing. Current implementation: [brief description]
Ready to refactor or proceed to next cycle?"