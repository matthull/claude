---
type: guidance
status: current
category: ai-development
---

# Prompt Structure and Organization

## Overview
The sequence and organization of prompt components significantly affects comprehension and performance. Proper structure leverages cognitive patterns like primacy and recency effects.

## Core Concepts

### Component Ordering
- **Optimal sequence**: Role → Task → Context → Examples → Constraints → Output Format
- Place critical instructions at beginning (primacy effect)
- Reinforce key requirements at end (recency effect)
- Group related information together
- Separate meta-instructions from content

### Role Definition
- Start with clear role assignment: "You are an expert [domain] specialist"
- Activate relevant knowledge domains through role setting
- Specify expertise level: "senior", "expert", "specialist"
- Include relevant traits: "detail-oriented", "creative", "analytical"
- Maintain role consistency throughout conversation

### Task Framing
- State the primary objective immediately after role
- Use clear action verbs: "Analyze", "Generate", "Evaluate"
- Specify the purpose: "in order to..."
- Define success criteria upfront
- Distinguish primary from secondary tasks

### Context Positioning
- Place context after task definition but before examples
- Order context by relevance (most to least important)
- Use headers to label context sections
- Separate background from actionable information
- Trim context that doesn't directly support the task

### Example Placement
- Position examples after context but before output specification
- Label examples clearly: "Example 1:", "Good example:", "Bad example:"
- Show input-output pairs for clarity
- Order examples from simple to complex
- Include edge cases in examples when relevant

### Constraint Layering
- State hard constraints early (must/must not)
- Follow with soft constraints (should/prefer)
- Group constraints by type: format, content, style
- Place output format requirements last
- Repeat critical constraints at end for emphasis

### Information Hierarchy
- Use formatting to show importance levels
- Primary instructions in main text
- Secondary details in subsections
- Optional elements in parentheses
- Critical warnings in emphasis (bold/caps)

## When to Apply
- Every prompt benefits from intentional structure
- Essential for complex multi-component prompts
- Critical when accuracy requirements are high
- When prompts will be reused or maintained
- For production systems requiring consistency

## Anti-patterns
- Burying important instructions in the middle
- Mixing examples with instructions
- Defining role after giving task
- Scattering related information throughout
- Placing constraints only at the end
- Ignoring primacy and recency effects
- Random ordering of components