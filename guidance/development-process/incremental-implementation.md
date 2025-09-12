---
type: guidance
status: current
category: development-process
---

# Incremental Implementation Principles

## Overview
A disciplined approach to implementing features through small, reviewable steps that maintain system stability while making steady progress.

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

### Phase 1: Goal Definition
- Clarify requirements and constraints
- Identify pain points to address
- Define clear success criteria
- Document out-of-scope items

### Phase 2: Strategy Refinement
- Design technical approach
- Provide balanced pros/cons analysis
- Identify potential risks
- Choose optimal path forward

### Phase 3: Implementation Planning
- Create detailed step-by-step plan
- Define testing strategy for each step
- Identify verification points
- Plan rollback procedures if needed

### Phase 4: Incremental Implementation
- Execute one step from plan
- Verify step completion
- Get user review and approval
- Commit with descriptive message
- Repeat until complete

## Verification Standards

### Each Step Must Be:
- **Atomic** - Complete logical unit of change
- **Reviewable** - User can understand impact
- **Testable** - Can verify correctness
- **Reversible** - Can rollback if issues found

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

## Benefits
- **Reduced risk** - Small changes easier to debug
- **Better review** - Focused changes easier to understand
- **Clean history** - Atomic commits tell clear story
- **Faster recovery** - Easy to identify problem commits
- **Continuous progress** - Steady advancement without big breaks

## References
- Continuous Delivery principles
- Trunk-based development practices
- Agile incremental delivery