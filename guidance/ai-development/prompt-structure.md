---
type: guidance
status: current
category: ai-development
tags:
- ai-development
focus_levels:
- design
- implementation
---

# Prompt Structure

## Component Order
1. **Role** → Define identity first
2. **Task** → Primary objective
3. **Context** → Supporting information
4. **Examples** → Input-output pairs
5. **Constraints** → Requirements/limits
6. **Output Format** → Expected structure

## Role Definition
- Start: "You are an expert [domain] specialist"
- Specify expertise: "senior", "expert", "specialist"
- Include traits: "detail-oriented", "analytical"
- Maintain consistency throughout

## Task Framing
- Use action verbs: "Analyze", "Generate", "Evaluate"
- Specify purpose: "in order to..."
- Define success criteria upfront
- Distinguish primary from secondary

## Context Positioning
- Place after task, before examples
- Order by relevance (most to least)
- Use headers for sections
- Trim irrelevant information

## Example Placement
- Label clearly: "Example:", "Good:", "Bad:"
- Show input-output pairs
- Order simple to complex
- Include edge cases

## Constraint Layering
- Hard constraints early (MUST/NEVER)
- Soft constraints next (should/prefer)
- Group by type: format, content, style
- Repeat critical constraints at end

## Information Hierarchy
- Primary instructions in main text
- Secondary in subsections
- Optional in parentheses
- Critical in CAPS/bold

## When to Apply
- Complex multi-component prompts
- High accuracy requirements
- Reusable/maintained prompts
- Production systems

## Anti-patterns
- NEVER: Bury important instructions mid-prompt
- NEVER: Mix examples with instructions
- NEVER: Define role after task
- NEVER: Scatter related information
- NEVER: Ignore primacy/recency effects