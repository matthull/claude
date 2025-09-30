---
type: guidance
status: current
category: development-process
---

# Incremental Implementation

## Step-by-Step Rules
1. One logical change per iteration
2. User review after each step
3. Commit after verification
4. Continue only with approval

## Task Decomposition
- Small over large changes
- Testable components
- Maintain backward compatibility
- Quality over speed

## Implementation Order
- Backend before frontend
- Foundation before features
- Dependencies first
- Critical path priority

## Process Phases

### 1. Pattern Discovery
- Search existing patterns
- Check similar solutions
- Find models to extend
- Ask before new patterns

### 2. Goal Definition
- Requirements/constraints
- Success criteria
- Out-of-scope items

### 3. Planning
- Step-by-step plan
- Testing strategy
- Verification points

### 4. Implementation
- Execute one step
- Run tests
- Get review
- Commit
- Repeat

## Always Consult For
- New architectural patterns
- Infrastructure issues
- New models/tables
- Convention deviations

## Step Requirements
- **Atomic**: Complete logical unit
- **Reviewable**: Clear impact
- **Testable**: Verifiable
- **Test-verified**: All pass
- **Reversible**: Can rollback

## Test Discipline
- Run after EVERY change
- Including docs/formatting
- NEVER proceed with failures
- Fix immediately

## Communication
- Explain each step
- Describe trade-offs
- Ask when ambiguous
- Provide context

## Anti-patterns
- NEVER: Multiple steps before review
- NEVER: Changes without verification
- NEVER: Commits without diffs
- NEVER: Proceed with errors
- NEVER: Batch unrelated changes
