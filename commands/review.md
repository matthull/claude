# /review

## Purpose
Trigger comprehensive Gemini review with maximum context while keeping Claude lean.

## Usage
```
/review <what you want reviewed>
```

## Examples
```
/review the current git changes for bugs and security issues
/review the authentication implementation against our patterns
/review our project spec for completeness and edge cases
/review the entire backend module for performance issues
```

## Implementation
Load the gemini review guidance and execute review based on request.

@~/.claude/guidance/code-review/gemini-review-pattern.md

## Execution Pattern
1. Parse user's review request
2. Determine relevant files/directories to include
3. Use mcp__gemini-bridge__consult_gemini_with_files with:
   - All relevant files (kitchen sink approach)
   - User's specific review request as the query
4. Return Gemini's feedback directly

## File Selection Strategy
Based on the review request, include:
- Target files/directories mentioned
- Related tests and specs
- Project documentation (.claude/, working-docs/)
- Configuration files
- Dependencies and related modules

Remember: Send everything that might be relevant. Let Gemini handle the context.