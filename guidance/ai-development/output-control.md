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

# Output Control in Prompts

## Core Concepts

### Format Specification
- State the exact format upfront: "Output as JSON with keys: name, age, summary"
- Provide template structures for complex outputs
- Specify data types explicitly: "age as integer, name as string"
- Define separators for list outputs: "comma-separated", "one per line"
- Include encoding requirements: "UTF-8", "ASCII only"

### Output Templates
- Provide fill-in-the-blank templates for consistent structure
- Use placeholders clearly: `[VARIABLE_NAME]` or `{{variable}}`
- Show complete example outputs, not just fragments
- Template complex outputs to ensure all fields are included
- Mark optional vs required sections explicitly

### Length Control
- Specify exact constraints: "exactly 3 bullet points" not "a few bullet points"
- Use word/character/token counts: "100-150 words"
- Define paragraph or sentence counts for prose
- Set limits for each section in multi-part outputs
- Prefer maximum limits over minimum to prevent verbosity

### Style Directives
- Specify tone explicitly: "professional", "conversational", "technical"
- Define audience: "explain for a 5-year-old", "for domain experts"
- Set formality level: "formal academic writing", "casual blog post"
- Specify perspective: "first person", "third person", "imperative"
- Include domain conventions: "APA citations", "legal terminology"

### Response Prefilling
- Start the response to guide format: "Based on the analysis, the three key points are:\n1."
- Use prefilling to prevent chatty preambles
- Set the tone and structure through initial words
- Establish format patterns that the model continues
- Control output trajectory from the start

### Validation Criteria
- Define what constitutes a complete response
- Specify required elements: "must include pros and cons"
- Set quality thresholds: "confidence score above 0.8"
- Include format validation: "valid JSON", "well-formed XML"
- State exclusion criteria: "no speculation", "only verified facts"

## When to Apply
- Integration with downstream systems requiring specific formats
- When consistency across multiple outputs is critical
- For automated parsing or processing of responses
- When output will be user-facing without modification
- For maintaining style guides or brand voice

## Anti-patterns
- Vague length specifications: "short", "not too long"
- Assuming format without stating it
- Contradictory style directives
- Over-constraining creative tasks
- Providing format examples that don't match requirements
- Forgetting to specify edge case handling