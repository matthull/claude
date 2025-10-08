---
type: guidance
status: current
category: ai-development
focus_levels:
- design
- implementation
tags:
- ai-development
---

# Ultra-Concise Guidance Enforcement

## DELETE ON SIGHT
- Any "Benefits" or "Why this matters" section
- Sentences starting with "This helps..." or "This improves..."
- Multiple examples showing same pattern
- Philosophical justifications
- Historical context or rationale
- Alternative approaches ("You could also...")
- Explanatory preambles ("It's important to understand...")
- Hedging language ("consider", "might", "could", "should think about")

## REWRITE FORMULAS

### Explanatory → Declarative
❌ "This approach helps improve code quality by reducing..."
✅ [DELETE ENTIRELY]

❌ "You should consider using mocks when testing external services"
✅ "Use mocks for external services"

❌ "It's important to validate input to prevent security issues"
✅ "Validate all input"

### Verbose → Direct
❌ "When you encounter a situation where..."
✅ "When"

❌ "Make sure to always remember to..."
✅ "Always"

❌ "You'll want to avoid..."
✅ "Never"

### Soft → Hard
❌ "Consider/might/could/should think about"
✅ "MUST/NEVER/ALWAYS"

❌ "It's recommended to..."
✅ "Do:"

❌ "Try to avoid..."
✅ "Don't:"

## CONCRETE PATTERNS

### Lists Over Paragraphs
❌ "First, you'll want to set up the environment. Then make sure to..."
✅ - Set up environment
   - Configure X
   - Run Y

### Commands Over Descriptions
❌ "To check the status, you can run the status command"
✅ `git status`

### Facts Over Explanations
❌ "Since the API might change, it's good practice to version your endpoints"
✅ "Version all endpoints"

## VALIDATION CHECKLIST
□ No benefits sections
□ No explanatory sentences
□ No hedging language
□ No philosophical justification
□ No alternative approaches
□ Direct commands only
□ Declarative statements only
□ Lists instead of paragraphs

## IRONCLAD DIRECTIVES (System Prompt Level)

When writing behavioral constraints for system prompts, use maximum strength:

### Directive Structure
```markdown
- You **MUST NEVER** [action] for any reason, under any circumstance
- You **MUST ALWAYS** [action]
- **IF [condition]:** You **MUST IMMEDIATELY STOP** and [protocol]
```

### Strength Keywords (Use in Order)
1. **Section Headers**: (ABSOLUTE), (NON-NEGOTIABLE), (CRITICAL)
2. **Actions**: MUST NEVER, MUST ALWAYS, MUST IMMEDIATELY STOP
3. **Emphasis**: NO EXCEPTIONS, ABSOLUTELY
4. **Conditions**: IF/WHEN [trigger], THEN [action]

### STOP Protocol Pattern
```markdown
**IF [condition]:** You **MUST IMMEDIATELY STOP** all work and:
1. HALT current task
2. State which mandate triggered
3. Explain exact blocker
4. Request specific user guidance
5. AWAIT explicit instruction
```

### One-Line Rationale (Exception to Conciseness)
After directive blocks, add:
```markdown
**RATIONALE:** [One sentence explaining consequence/risk]
```

This is the ONLY acceptable explanatory content in system prompts.

### Anti-Rationalization
Include meta-directive:
```markdown
You **MUST NOT** rationalize, reinterpret, or seek exceptions to these mandates.
```

## TEST YOUR GUIDANCE
Can you remove 50% of words without losing meaning? If yes, DO IT.

**Exception**: Behavioral directives require repetition and emphasis for maximum adherence.