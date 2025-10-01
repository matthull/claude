---
type: guidance
status: current
category: code-quality
tags:
- coding
---

# Immediately Runnable Code

## Core Principles

### Completeness Standards
- **Full implementations** - No placeholder functions
- **All imports included** - Every dependency declared
- **Error handling present** - Try/catch where needed
- **Edge cases covered** - Handle nulls and boundaries
- **Return values specified** - No undefined returns

### Working Code Requirements
- **Syntactically correct** - Parses without errors
- **Logically complete** - All branches implemented
- **Dependencies available** - Uses existing libraries
- **Data structures defined** - No assumed types
- **Configuration included** - Environment ready

## Implementation Rules

### Always Include
- Import statements
- Variable declarations
- Error handling
- Return statements
- Type definitions (when applicable)
- Required configuration

### Never Assume
- Available libraries without checking
- Existing helper functions
- Global variables
- Implicit type conversions
- Default parameters
- Environment setup

## Code Completeness Checklist

### Before Presenting Code
- ✓ Will it run as-is?
- ✓ Are all functions implemented?
- ✓ Is error handling present?
- ✓ Are edge cases handled?
- ✓ Would copy-paste work?

### Common Incompleteness Patterns
- `// TODO: implement this`
- `pass` or `...` as body
- Undefined function calls
- Missing import statements
- Hardcoded test values
- Incomplete conditionals

## Error Handling Standards

### Minimum Requirements
- Catch likely exceptions
- Validate inputs
- Check null/undefined
- Handle async failures
- Provide error context

### Error Response Patterns
- Return error objects
- Throw meaningful exceptions
- Log error details
- Graceful degradation
- User-friendly messages

## When Pseudocode Is Acceptable

### Only When
- User explicitly requests it
- Explaining an algorithm
- Showing high-level flow
- Comparing approaches
- Teaching concepts

### Mark Clearly
- Label as pseudocode
- Explain why not runnable
- Provide path to implementation
- Note missing pieces

## Quality Indicators

### Good: Immediately Runnable
```
Full working implementation with:
- All imports
- Error handling
- Complete logic
- Proper returns
```

### Bad: Incomplete Code
```
Partial implementation with:
- TODO comments
- Missing functions
- No error handling
- Assumed dependencies
```

## Testing Your Code

### Mental Execution
1. Trace through main path
2. Check error conditions
3. Verify edge cases
4. Confirm return values
5. Validate dependencies

### Completeness Verification
- No undefined references
- All paths return values
- Exceptions are caught
- Resources are cleaned up
- State is consistent

## Anti-patterns
- Placeholder implementations
- Commented-out logic
- Hardcoded test data
- Missing error handling
- Incomplete conditionals
- Assumed global state
- Undefined function calls
- Partial class definitions

