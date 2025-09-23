---
type: guidance
status: current
category: development-process
---

# Incremental Implementation Principles

## Core Principles

### Step-by-Step Execution
1. **One step at a time** - Implement only one logical change per iteration
2. **User review after each step** - Allow review in editor before proceeding
3. **Commit after verification** - Create atomic commits for each verified step
4. **Continue only after confirmation** - Wait for explicit approval before next step

### Task Decomposition
- **Small over large** - Prefer incremental improvements over massive changes
- **Testable components** - Break features into independently verifiable units
- **Backward compatibility** - Maintain system stability throughout changes
- **Quality focus** - Prioritize maintainability over speed

### Implementation Order
- **Backend first** - When features span backend/frontend, implement backend first
- **Foundation before features** - Build infrastructure before user-facing elements
- **Dependencies first** - Resolve prerequisites before dependent features
- **Critical path priority** - Focus on blocking items before nice-to-haves

## When to Apply
- New feature development requiring multiple changes
- Refactoring existing code while maintaining functionality
- Bug fixes that touch multiple system components
- Any change spanning more than one file or module

## Implementation Process

### Phase 1: Pattern Discovery (Brownfield)
- Search for existing patterns
- Check how similar problems solved
- Find models/concerns to extend
- Ask user before new patterns

### Phase 2: Goal Definition
- Requirements and constraints
- Success criteria
- Out-of-scope items

### Phase 3: Implementation Planning
- Step-by-step plan
- Testing strategy per step
- Verification points

### Phase 4: Incremental Implementation
- Execute one step
- Run tests
- Get user review
- Commit
- Repeat

## User Consultation Points

### Always Ask About
- New architectural patterns
- Suspected infrastructure issues
- Creating new models/tables
- Deviating from conventions

### Check First, Ask Second
- Search codebase for patterns
- Test specific usage
- Find working examples
- Then consult if needed

## Verification Standards

### Each Step Must Be:
- **Atomic** - Complete logical unit of change
- **Reviewable** - User can understand impact
- **Testable** - Can verify correctness
- **Test-verified** - Tests must pass after changes
- **Reversible** - Can rollback if issues found

### Test Verification Requirements
- Run tests after EVERY file modification
- This includes: code, documentation, formatting, linting
- Never proceed to next step with failing tests
- Fix test failures immediately before continuing

### Communication During Implementation
- Explain what each step will accomplish
- Describe trade-offs in technical decisions
- Ask clarifying questions when ambiguous
- Provide context for approach chosen

## Anti-patterns to Avoid
- Implementing multiple steps before review
- Making changes without user verification
- Creating commits without showing diffs
- Proceeding despite uncertainty or errors
- Batching unrelated changes together

## References
- Continuous Delivery principles
- Trunk-based development practices
- Agile incremental delivery