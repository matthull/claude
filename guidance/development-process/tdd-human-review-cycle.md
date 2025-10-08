---
type: guidance
status: current
category: development-process
tags:
- tdd
- review
- development-process
focus_levels:
- strategic
- design
---

# TDD with Mandatory Human Review

## Core Cycle Steps
1. **RED** - Write failing test that captures next requirement
2. **GREEN** - Write minimal code to make test pass
3. **STOP** - Mandatory human review before proceeding
4. **REFACTOR** - Only proceed if human approves
5. **COMMIT** - One complete cycle = one commit
6. **REPEAT** - Next cycle only after current cycle committed

## Human Review Requirements
- You **MUST ALWAYS** stop after GREEN phase
- You **MUST NEVER** proceed to refactor without explicit user approval
- You **MUST SHOW** current test status and minimal implementation to the user
- You **MUST WAIT** for user confirmation before refactoring
- You **MUST ASK** "Ready to refactor?" or "Proceed to next cycle?"

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
- You **MUST NEVER** skip human review after green
- You **MUST NEVER** refactor without user approval
- You **MUST NEVER** write multiple tests before going green
- You **MUST NEVER** implement beyond test requirements
- You **MUST NEVER** commit without completing full cycle

## When to Apply
- Feature development requiring test coverage
- Bug fixes that need regression tests
- Refactoring that must preserve behavior
- Learning new codebases through tests

## Communication Pattern
```
Claude: "✅ Test passing. Current implementation: [brief description]
Ready to refactor or proceed to next cycle?"