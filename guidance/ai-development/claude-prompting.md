---
type: guidance
status: current
category: ai-development
tags:
- ai-development
---

# Claude-Specific Prompting

## XML Tags
- Use semantic names: `<thinking>`, `<answer>`, `<analysis>`
- Create stronger boundaries than other delimiters
- Nest for hierarchical processing
- Common tags: `<context>`, `<instructions>`, `<examples>`, `<output>`

## Prefilling
- Start response: "Based on the analysis,"
- Control format from first token
- Skip preambles: "I'll help you with..."
- Set tone through prefill
- Enforce structured outputs

## Thinking Pattern
```
Think step-by-step within <thinking></thinking> tags
```
- Improves complex task accuracy
- Separate reasoning from output
- Hidden from end users
- Best for: math, logic, analysis

## Message Structure
- Maintain Human:/Assistant: format
- Clear conversation boundaries
- Simulate multi-turn for context
- Consistent formatting throughout

## Context Window
- 100k-200k tokens available
- Important info at beginning/end
- Strong coherence across length
- Effective multi-document synthesis

## Artifact Generation
- Trigger: complete documents/code files
- Separates response from content
- Enables reusability
- Maintains conversation flow

## When to Apply
- Claude-specific implementations
- Complex reasoning tasks
- Format control critical
- Long-context processing
- Avoiding preambles

## Anti-patterns
- NEVER: Use ChatGPT prompts unchanged
- NEVER: Ignore XML tag training
- NEVER: Adversarial prompting
- NEVER: Skip prefilling capabilities
- NEVER: Assume transfer to other models