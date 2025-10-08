---
type: guidance
status: current
category: development-process
tags:
- development-process
focus_levels:
- strategic
- design
---

# Brownfield Development

## Core Rules
- Assume existing code works
- Search for patterns before creating
- Extend existing models, don't create new

## Pattern Discovery
```bash
rg "ClassName" --type ruby
find app/ -name "*service*"
ls app/models/concerns/
find spec/ -name "*similar*_spec.rb"
```

## Investigation Protocol
1. Test specific usage
2. Find working examples
3. Create minimal reproduction

## Planning Anti-Patterns

### Over-Specification
❌ Planning service objects before complexity exists
❌ Defining helper classes upfront
❌ Specifying internal file organization
✅ Let these emerge during implementation

### Premature Abstraction
❌ Service class in plan
✅ Inline code first, extract when complex

### Creating Parallel Structures
❌ New model when existing serves purpose
✅ Extend existing model with fields

### Assuming Global Breakage
❌ "Infrastructure is broken globally"
✅ Test your specific case first

### Planning Creep
❌ HOW details (class structure, file organization)
✅ WHAT goals (data model, API surface)

## Checklist
□ Focused on WHAT not HOW?
□ Searched for existing solutions?
□ Can extend existing models?
□ Avoided pre-planning services?
□ Verified issue isn't just your code?