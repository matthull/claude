---
type: guidance
status: current
category: ai-development
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

## TEST YOUR GUIDANCE
Can you remove 50% of words without losing meaning? If yes, DO IT.