---
type: guidance
status: current
category: code-quality
---

# Code Review Principles

## Overview
Code review is a systematic examination of source code intended to find bugs, improve code quality, and share knowledge across the team. These principles apply to both giving and receiving reviews.

## Core Philosophy

### Balanced Analysis
- **Always provide pros and cons** when evaluating approaches
- **Avoid being a "yes man"** - challenge ideas constructively
- **Identify potential issues** before they become problems
- **Acknowledge good decisions** not just problems

### Critical Thinking
- **Question assumptions** - "Why this approach?"
- **Consider alternatives** - "Have we considered X?"
- **Think about edge cases** - "What happens when...?"
- **Evaluate trade-offs** - "This improves X but complicates Y"

## Communication Style

### When Reviewing Code
- **Be Specific**: Not "This could be better" but "This nested loop is O(n²). Consider a hash map for O(n) lookup"
- **Be Constructive**: Not "Wrong way" but "This works, but a guard clause would reduce nesting"

#### Provide Context
- Explain **why** something is important
- Link to documentation or examples
- Share relevant experience

### When Receiving Feedback

#### Stay Open
- Reviews improve code quality
- Every comment is a learning opportunity
- Reviewer has different perspective

#### Ask Questions
- "Could you elaborate on the performance concern?"
- "What would be a better approach here?"
- "Is this a blocker or a suggestion?"

## What to Review

### Priority Order
1. **Correctness**: Does it solve the problem?
2. **Security**: Are there vulnerabilities?
3. **Performance**: Will it scale?
4. **Maintainability**: Can others understand/modify it?
5. **Style**: Does it follow conventions?

### Key Areas

#### Logic and Functionality
- Algorithm correctness
- Edge case handling
- Error conditions
- Business logic accuracy

#### Design and Architecture
- SOLID principles adherence
- Appropriate design patterns
- Module boundaries
- API contracts

#### Performance
- Time complexity
- Space complexity
- Database query efficiency
- Caching strategy

#### Security
- Input validation
- Authentication/authorization
- SQL injection prevention
- XSS protection

#### Maintainability
- Code clarity
- Documentation
- Test coverage
- Technical debt

## Review Checklist

### Before Approving
- [ ] Code accomplishes the stated goal
- [ ] Tests adequately cover changes
- [ ] No obvious security issues
- [ ] Performance impact considered
- [ ] Documentation updated if needed
- [ ] No code duplication introduced
- [ ] Error handling is appropriate
- [ ] Code follows project conventions

### Red Flags
- 🚩 No tests for new functionality
- 🚩 Commented-out code
- 🚩 TODO comments without tickets
- 🚩 Magic numbers/strings
- 🚩 Overly complex functions (>50 lines)
- 🚩 Duplicate code
- 🚩 Mixed concerns in single class/module

## Providing Feedback

### Feedback Categories

#### Blocking (Must Fix)
- Security vulnerabilities
- Data corruption risks
- Breaking changes
- Failed tests

#### Should Fix
- Performance problems
- Clear bugs
- Missing error handling
- Accessibility issues

#### Consider
- Better approaches
- Refactoring opportunities
- Documentation improvements
- Test enhancements

#### Nitpick
- Style preferences
- Minor naming issues
- Formatting
- Personal preferences

### Feedback Format
```markdown
**[BLOCKING]** SQL injection vulnerability in user input
**[SHOULD]** This query could use an index on `user_id`
**[CONSIDER]** Extract this to a service object for reusability
**[NIT]** Typo in comment: "retrive" -> "retrieve"
```

## Anti-Patterns to Avoid

### Review Anti-Patterns
- **Rubber Stamping**: Approving without real review
- **Nitpick Focus**: Only commenting on style
- **Design Changes**: Major refactoring requests in review
- **Delayed Reviews**: Letting PRs sit for days
- **Bulk Comments**: 50+ comments overwhelming author

### Communication Anti-Patterns
- Being dismissive or condescending
- Making it personal
- Arguing in comments (take it offline)
- Ignoring feedback without explanation
- Demanding perfection

## Best Practices

### For Authors
- **Small PRs**: Easier to review thoroughly
- **Clear descriptions**: Explain what and why
- **Self-review first**: Catch obvious issues
- **Respond to all comments**: Even if just acknowledging
- **Update promptly**: Don't let feedback go stale

### For Reviewers
- **Review promptly**: Within 24 hours ideally
- **Run the code**: Don't just read it
- **Check tests**: Run them, read them
- **Be thorough**: But know when good enough is enough
- **Follow up**: Ensure critical feedback is addressed

## Automation Support

### Tools to Use
- Linters for style issues
- Security scanners for vulnerabilities
- Coverage tools for test gaps
- Complexity analyzers for refactoring needs

### Human Focus
With automation handling mechanical issues, focus on:
- Design decisions
- Business logic correctness
- Edge case identification
- Knowledge sharing
- Architectural concerns

## Cultural Aspects

### Building Trust
- Assume positive intent
- Praise good code publicly
- Discuss concerns privately
- Share learning from mistakes
- Celebrate improvements

### Knowledge Sharing
- Link to relevant documentation
- Share similar past experiences
- Explain domain knowledge
- Teach, don't just correct

---

*Remember: Code review is about improving code AND growing developers. The code gets better, and so does the team.*