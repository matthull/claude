---
type: guidance
status: current
category: code-quality
---

# Code Review Principles

## Review Stance
- ALWAYS provide pros and cons
- NEVER be a "yes man"
- Identify issues
- Challenge assumptions
- Consider alternatives
- Evaluate trade-offs

## Reviewer Actions
- Be specific: "This loop is O(n²). Use hash map for O(n)."
- Be constructive: "Guard clause reduces nesting."
- Explain WHY
- Link documentation
- Share experience

## Author Actions
- Stay open to feedback
- Ask: "Can you elaborate?" "Better approach?" "Blocker or suggestion?"

## Review Priority
1. Correctness
2. Security
3. Performance
4. Maintainability
5. Style

## Approval Checklist
□ Code accomplishes goal
□ Tests cover changes
□ No security issues
□ Performance considered
□ Documentation updated
□ No duplication
□ Error handling appropriate
□ Follows conventions

## Red Flags
🚩 No tests for new functionality
🚩 Commented-out code
🚩 TODO without ticket
🚩 Magic numbers/strings
🚩 Functions >50 lines
🚩 Duplicate code
🚩 Mixed concerns

## Feedback Categories
**[BLOCKING]**: Security, data corruption, breaking changes
**[SHOULD]**: Performance, bugs, missing error handling
**[CONSIDER]**: Better approaches, refactoring, documentation
**[NIT]**: Style, naming, formatting

## Format
```
[BLOCKING] SQL injection in user input
[SHOULD] Query needs index on user_id
[CONSIDER] Extract to service object
[NIT] Typo: "retrive" -> "retrieve"
```

## DON'T
- Rubber stamp
- Nitpick focus
- Request design changes in review
- Delay reviews
- Bulk comments
- Be dismissive
- Make it personal
- Argue in comments
- Ignore feedback
- Demand perfection

## DO
**Authors:**
- Small PRs
- Clear descriptions
- Self-review first
- Respond to all comments

**Reviewers:**
- Review within 24 hours
- Run the code
- Check tests
- Be thorough
- Follow up

## Automate
- Linters
- Security scanners
- Coverage tools
- Complexity analyzers

## Human Focus
- Design decisions
- Business logic
- Edge cases
- Knowledge sharing
- Architecture
