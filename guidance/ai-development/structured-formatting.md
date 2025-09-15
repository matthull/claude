---
type: guidance
status: current
category: ai-development
---

# Structured Formatting for Prompts

## Overview
Structured formatting using delimiters, tags, and consistent patterns dramatically improves prompt clarity and LLM comprehension. Research shows 15-30% reduction in misinterpretation errors through proper structure.

## Core Concepts

### XML Tags
- Use XML tags to clearly delineate sections: `<context>`, `<instructions>`, `<examples>`, `<output>`
- Tags create unambiguous boundaries that LLMs recognize as high-priority markers
- Nest tags for hierarchical information: `<task><subtask>content</subtask></task>`
- Close all tags properly - unclosed tags can confuse parsing

### JSON Structures
- Use JSON for structured data inputs and output specifications
- Provides type clarity and hierarchical relationships
- Enables consistent parsing and validation
- Prefer JSON over free-form text for complex data structures

### Markdown Formatting
- Use headers (##) to organize major sections
- Bullet points for lists of related items
- Numbered lists for sequential steps or priorities
- Code blocks (```) for examples or literal text
- Bold (**text**) for emphasis on critical instructions

### Delimiters and Separators
- Triple dashes (---) for major section breaks
- Triple backticks (```) for code or literal content
- Quotation marks for exact phrases to match or generate
- Brackets [placeholder] for variable content
- Parentheses for optional or clarifying information

### Section Organization
- Place instructions first, context second, examples third
- Group related information within clear boundaries
- Use consistent formatting throughout the prompt
- Separate meta-instructions from content using delimiters

## When to Apply
- Complex prompts with multiple components
- When precision is critical for task execution
- Multi-step processes requiring clear delineation
- Any prompt over 3-4 sentences
- When outputting structured data

## Anti-patterns
- Mixing formatting styles inconsistently
- Over-nesting structures beyond 3 levels
- Using ambiguous delimiters that appear in content
- Leaving tags or brackets unclosed
- Relying on whitespace alone for structure