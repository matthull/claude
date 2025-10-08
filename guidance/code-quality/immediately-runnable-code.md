---
type: guidance
status: current
category: code-quality
tags:
- code-quality
- code
focus_levels:
- implementation
---

# Immediately Runnable Code

## Core Principles for Implementation

- You **MUST ALWAYS** provide full, complete implementations
- You **MUST ALWAYS** ensure all necessary imports are present and declared
- You **MUST ALWAYS** implement appropriate error handling (e.g., try/catch where needed)
- You **MUST ALWAYS** cover edge cases and handle nulls/boundaries
- You **MUST ALWAYS** specify return values; you **MUST NEVER** have undefined returns
- You **MUST ALWAYS** ensure code is syntactically correct and logically complete
- You **MUST NEVER** assume libraries, helper functions, global variables, implicit type conversions, or default parameters are available without explicit verification
- You **MUST ALWAYS** include required configuration for the environment

## Code Completeness Checklist (Before Presenting Code)

- ✓ Will it run as-is?
- ✓ Are all functions implemented?
- ✓ Is error handling present?
- ✓ Are edge cases handled?
- ✓ Would copy-paste work?

## Common Incompleteness Anti-Patterns (You MUST NEVER submit code with these)

- `// TODO: implement this` or similar placeholder comments
- `pass` or `...` as function/method body
- Undefined function calls or references
- Missing import statements
- Hardcoded test values in production code
- Incomplete conditionals or logic branches
- Commented-out logic
- Assumed global state
- Partial class definitions

## Error Handling Standards

- You **MUST ALWAYS** catch likely exceptions
- You **MUST ALWAYS** validate all inputs
- You **MUST ALWAYS** check for null/undefined values
- You **MUST ALWAYS** handle asynchronous failures
- You **MUST ALWAYS** provide clear error context
- You **MUST ALWAYS** return error objects or throw meaningful exceptions
- You **MUST ALWAYS** log error details appropriately
- You **MUST ALWAYS** ensure graceful degradation and user-friendly messages where applicable

## When Pseudocode Is Acceptable

- **Only When:**
    - User explicitly requests it
    - Explaining an algorithm or showing high-level flow
    - Comparing approaches or teaching concepts
- **You MUST ALWAYS Mark Clearly:**
    - Label it explicitly as pseudocode
    - Explain why it is not runnable
    - Provide the path to the full implementation
    - Note any missing pieces
