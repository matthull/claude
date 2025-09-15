---
type: guidance
status: current
category: ai-development
---

# Context Optimization for Prompts

## Overview
Every token costs time and money. Optimize for information density - maximum meaning in minimum tokens while preserving semantic integrity.

## Core Concepts

### Information Density Principles
- Remove filler words: "very", "really", "basically", "actually"
- Eliminate redundant phrases: "in order to" → "to"
- Use precise single words over wordy phrases
- Compress verbose expressions: "at this point in time" → "now"
- Remove unnecessary articles (the, a, an) where clarity permits

### Selective Context Inclusion
- Include only context directly relevant to the task
- Place most relevant information at beginning and end (primacy/recency)
- For multi-turn conversations, summarize rather than include full history
- Extract key facts rather than providing full documents
- Use references to external knowledge rather than explaining common concepts

### Compression Strategies
- Use abbreviations for repeated terms (define once, use throughout)
- Combine related instructions into single statements
- Replace examples with patterns when possible
- Use structured formats (JSON/CSV) over prose for data
- Leverage implicit understanding rather than explicit explanation

### Token-Aware Writing
- Prefer common words over rare synonyms (fewer tokens)
- Use contractions where appropriate
- Remove transitional phrases between sections
- Eliminate courtesy language: "please", "thank you", "if you could"
- Skip meta-commentary about the task

### Context Window Management
- Budget your tokens: instructions (20%), context (60%), examples (20%)
- Prioritize by importance when approaching limits
- Use retrieval-augmented generation (RAG) for large knowledge bases
- Implement sliding windows for long conversations
- Consider prompt chaining over single massive prompts

### Semantic Preservation
- Maintain critical distinctions and nuances
- Keep technical terms that affect meaning
- Preserve logical connectors that show relationships
- Retain quantifiers and constraints
- Don't compress at the expense of accuracy

## When to Apply
- Always - token optimization is always valuable
- Critical for high-volume production use
- When approaching context window limits
- For real-time applications requiring low latency
- When cost reduction is a priority

## Anti-patterns
- Over-compression that loses meaning
- Removing critical context to save tokens
- Using unclear abbreviations
- Compressing instructions more than examples
- Optimizing tokens before confirming prompt works
- Sacrificing clarity for brevity