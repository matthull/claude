---
type: guidance
status: current
category: ai-development
---

# Claude-Specific Prompting Techniques

## Overview
Claude has specific training optimizations and preferences that, when leveraged correctly, significantly improve response quality and efficiency. These techniques are Claude-specific and may not transfer to other LLMs.

## Core Concepts

### XML Tag Optimization
- Claude is specifically trained to pay attention to XML tags
- Use semantic tag names: `<thinking>`, `<answer>`, `<analysis>`
- Tags create stronger boundaries than other delimiters
- Nest tags for hierarchical information processing
- Common effective tags: `<context>`, `<instructions>`, `<examples>`, `<output>`

### Prefilling Technique
- Start Claude's response to prevent preambles: "Based on the analysis,"
- Control output format from first token
- Prevent conversational fillers: skip "I'll help you with..."
- Set tone and style through prefill text
- Use prefilling to enforce structured outputs

### Thinking Tags Pattern
- Use `<thinking>` tags for complex reasoning: "Think step-by-step within `<thinking></thinking>` tags"
- Thinking tags improve accuracy on complex tasks
- Separate reasoning from output: thinking first, answer second
- Can be hidden from end users while improving quality
- Particularly effective for math, logic, and analysis tasks

### Human/Assistant Formatting
- Claude expects Human:/Assistant: message structure
- Maintain clear conversation boundaries
- Can simulate multi-turn context for better understanding
- Use consistent formatting throughout conversation
- Leverage conversation history for context

### Constitutional AI Alignment
- Claude responds well to positive, helpful framing
- Avoid adversarial or tricky prompting
- Frame requests constructively
- Claude is trained to be helpful, harmless, and honest
- Align prompts with these training objectives

### Claude's Context Window
- 100k token context window (Claude 2.1: 200k)
- Place most important info at beginning and end
- Claude maintains strong coherence across long contexts
- Can handle extensive document analysis
- Effective for multi-document synthesis

### Artifact Generation
- Claude can generate "artifacts" for substantial content
- Trigger with requests for complete documents, code files
- Artifacts separate main response from generated content
- Useful for maintaining conversation flow with large outputs
- Enable reusability and modification of generated content

## When to Apply
- Always when using Claude specifically
- For maximum performance on complex reasoning
- When output format control is critical
- For long-context document processing
- When avoiding preambles is important

## Anti-patterns
- Using ChatGPT-optimized prompts without modification
- Ignoring Claude's XML tag training
- Adversarial or deceptive prompting approaches
- Not leveraging prefilling capabilities
- Assuming techniques transfer to other models
- Fighting against Claude's training (helpful, harmless, honest)