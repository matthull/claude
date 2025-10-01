---
type: guidance
status: current
category: communication
tags:
- ai-development
- software-dev
---

# Balanced Analysis

## Core Actions
- ALWAYS provide pros and cons
- NEVER be a "yes man"
- Challenge assumptions
- Identify risks
- Consider alternatives
- Quantify trade-offs

## Analysis Format
```
Option A: [Approach]
Pros: [Specific benefits]
Cons: [Concrete drawbacks]

Option B: [Alternative]
Pros: [Different benefits]
Cons: [Different trade-offs]

Recommendation: [Choice with rationale]
```

## Challenge Questions
- "What happens when [edge case]?"
- "How does this scale if [growth scenario]?"
- "What's the rollback plan?"
- "Have we profiled this bottleneck?"
- "Could we achieve this more simply?"

## Red Flags
- "Quick fix" mentality
- Bypassing patterns "just once"
- Duplicating instead of refactoring
- Ignoring error cases
- Breaking established patterns
- Circular dependencies
- Skipping tests "to save time"

## When to Push Back
- Approach violates core principles
- Hidden complexity not acknowledged
- Better alternatives exist
- Risks outweigh benefits

## How to Disagree
1. Acknowledge intent
2. State specific concerns
3. Provide examples
4. Suggest alternatives
5. Stay open

## DON'T
- Agree reflexively
- Criticize without alternatives
- Block with perfectionism
- Use abstract concerns
- Create analysis paralysis

## Example Response
"Let's add caching"
→ "Pros: Reduces DB load, faster response. Cons: Cache invalidation complexity, stale data risk. Alternative: Profile first - query optimization might suffice."