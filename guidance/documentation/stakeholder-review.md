---
type: guidance
status: current
category: documentation
focus_levels:
- design
- implementation
tags:
- review
- documentation
---

# Stakeholder Review

## Process
1. Load project spec.md
2. Identify reviewers needed
3. Define decisions required
4. Select requirements slice
5. Choose review channel
6. Generate review document

## Review Document Structure
```markdown
# [Feature] Review for [Stakeholder]
**Decisions/Feedback Requested**: [bullet list of decisions or feedback we're requesting]
**Deadline**: [Date]

## Summary
[3-5 bullets of what matters to this stakeholder]

## Relevant Requirements
[Extracted spec sections they need to see]

## Decision Points
- [ ] [Specific decision needed]
```

## Requirements Slicing Rules
- Extract only sections relevant to decision
- Remove implementation details for non-technical reviewers
- Include mockups for UI changes
- Focus on impacts and outcomes

## Anti-patterns
- Sending entire spec
- Vague decision requests
- Technical jargon in business reviews
