---
type: guidance
status: current
category: ai-development
tags:
- ai-development
---

# Instruction Clarity in Prompts

## Core Concepts

### Specificity Over Vagueness
- Replace "analyze this" with "identify the three main arguments and evaluate their evidence"
- Replace "make it better" with "improve clarity by simplifying sentences and removing jargon"
- Define exact quantities, formats, and constraints
- Specify edge case handling explicitly

### Positive Framing
- Use "Do X" instead of "Don't do Y" - gives clear action path
- "Include citations" rather than "Don't forget citations"
- "Write in active voice" rather than "Avoid passive voice"
- Positive instructions reduce cognitive load and interpretation errors

### Active Voice and Imperative Mood
- "Generate a summary" not "A summary should be generated"
- "Analyze the data" not "The data needs to be analyzed"
- Start with action verbs: Create, Generate, Analyze, Extract, Transform
- Direct commands are processed more efficiently than suggestions

### Eliminate Contradictions
- Avoid "brief comprehensive analysis" - pick brief OR comprehensive
- Don't request "detailed summary" - summaries are concise by definition
- Resolve conflicting instructions before sending
- Test prompts for internal consistency

### Precise Vocabulary
- Use domain-specific terms correctly and consistently
- Define ambiguous terms upfront
- Avoid pronouns when referencing can be unclear
- Maintain consistent terminology throughout

### Constraint Specification
- State what IS allowed, not just what isn't
- Provide explicit boundaries: "Between 100-150 words"
- Specify format constraints: "Use only lowercase letters"
- Define acceptable ranges rather than vague limits

## When to Apply
- Every prompt, without exception
- Especially critical for production systems
- When output format must be consistent
- For tasks requiring specific domain knowledge
- When precision affects downstream processing

## Anti-patterns
- Using "probably", "maybe", "if possible" - be definitive
- Mixing instructions with explanations
- Assuming context without stating it
- Using different terms for the same concept
- Leaving success criteria undefined
- Requesting contradictory attributes