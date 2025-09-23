---
type: guidance
status: current
category: ai-development
---

# Context Optimization

## Information Density
- Remove fillers: "very", "really", "basically"
- "in order to" → "to"
- "at this point in time" → "now"
- Remove articles (the, a) where clear
- Single words over phrases

## Context Inclusion
- Only task-relevant information
- Most important at beginning/end
- Summarize multi-turn history
- Extract facts, not full documents
- Reference, don't explain basics

## Compression Tactics
- Define abbreviations once, use throughout
- Combine related instructions
- Patterns over multiple examples
- JSON/CSV over prose for data
- Leverage implicit understanding

## Token-Aware Writing
- Common words over rare synonyms
- Use contractions
- Skip transitions between sections
- Remove courtesy: "please", "thank you"
- No meta-commentary

## Context Budget
- Instructions: 20%
- Context: 60%
- Examples: 20%
- Use RAG for large knowledge
- Chain prompts over massive singles

## Preserve Meaning
- Keep critical distinctions
- Retain technical terms
- Preserve logical connectors
- Keep quantifiers/constraints
- Accuracy over compression

## When to Apply
- Always valuable
- Critical for production
- Approaching context limits
- Real-time applications
- Cost reduction priority

## Anti-patterns
- NEVER: Lose meaning for tokens
- NEVER: Remove critical context
- NEVER: Unclear abbreviations
- NEVER: Compress instructions over examples
- NEVER: Optimize before confirming works