---
type: guidance
status: current
category: code-quality
focus_levels:
- implementation
tags:
- code-quality
- review
- code
---

# Code Review Principles

## Review Stance
- You **MUST ALWAYS** provide pros and cons for suggested changes
- You **MUST NEVER** be a "yes man"; you **MUST ALWAYS** identify issues and challenge assumptions
- You **MUST ALWAYS** consider alternatives and evaluate trade-offs

## Reviewer Actions
- You **MUST ALWAYS** be specific: "This loop is O(n²). Use hash map for O(n)."
- You **MUST ALWAYS** be constructive: "Guard clause reduces nesting."
- You **MUST ALWAYS** explain WHY a change is suggested
- You **MUST ALWAYS** link to relevant documentation
- You **MUST ALWAYS** share relevant experience

## Author Actions
- You **MUST ALWAYS** stay open to feedback
- You **MUST ALWAYS** ask clarifying questions: "Can you elaborate?" "Is there a better approach?" "Is this a blocker or a suggestion?"

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

## Red Flags (You MUST address these before approval)
🚩 No tests for new functionality
🚩 Commented-out code
🚩 TODO without an associated ticket/plan
🚩 Magic numbers/strings
🚩 Functions >50 lines
🚩 Duplicate code
🚩 Mixed concerns

## Feedback Categories
**[BLOCKING]**: Security, data corruption, breaking changes (You **MUST** address these immediately)
**[SHOULD]**: Performance, bugs, missing error handling (You **SHOULD** address these before merging)
**[CONSIDER]**: Better approaches, refactoring, documentation (You **MAY** consider these for future improvements)
**[NIT]**: Style, naming, formatting (You **MAY** address these at your discretion)

## Format
```
[BLOCKING] SQL injection in user input
[SHOULD] Query needs index on user_id
[CONSIDER] Extract to service object
[NIT] Typo: "retrive" -> "retrieve"
```

## DON'T (You MUST NEVER do these)
- Rubber stamp reviews
- Focus solely on nitpicks
- Request major architectural or design changes during a code review; these **MUST** be discussed and approved by the user beforehand
- Delay reviews
- Provide bulk comments without specific context
- Be dismissive of feedback
- Make feedback personal
- Argue in comments; resolve disagreements offline or escalate
- Ignore feedback
- Demand perfection

## DO (You MUST ALWAYS do these)
**Authors:**
- Submit small, focused Pull Requests (PRs)
- Provide clear PR descriptions
- Self-review your code before submitting
- Respond to all comments

**Reviewers:**
- Review within 24 hours
- Run the code locally
- Check tests thoroughly
- Be thorough in your review
- Follow up on comments

## Automate (You MUST ALWAYS leverage automation for these)
- Linters
- Security scanners
- Coverage tools
- Complexity analyzers

## Human Focus (You MUST ALWAYS focus human review on these areas)
- Design decisions
- Business logic
- Edge cases
- Knowledge sharing
- Architecture
