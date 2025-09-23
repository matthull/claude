---
type: guidance
status: current
category: development-process
---

# Brownfield Development

## Core Rules
- Assume existing code works
- Search for patterns before creating
- Extend existing models, don't create new
- Ask user before new patterns

## Pattern Discovery
```bash
# Find similar code
rg "ClassName" --type ruby
find app/ -name "*service*"

# Check existing patterns
ls app/models/concerns/
find spec/ -name "*similar*_spec.rb"
```

## Investigation Before Assuming
1. Test your specific usage
2. Find working examples
3. Create minimal reproduction
4. Ask user if infrastructure seems broken

## Common Mistakes

### Creating Parallel Models
❌ New model when existing serves purpose
✅ Extend existing model with fields

### Assuming Global Breakage
❌ "Encryption is broken globally"
✅ Check your usage first

### Pre-Planning Services
❌ Plan services before complexity exists
✅ Extract services during refactoring

## Real Example: Seismic Integration

**Wrong:**
- Created IntegrationSettings model
- Ignored existing SeismicIntegration
- Pre-planned ContentUploader service

**Right:**
- Extended SeismicIntegration
- Used existing ThirdPartySync concern
- Let services emerge from refactoring

## When to Ask User
- New architectural patterns
- Infrastructure-wide issues
- New models/tables
- Deviating from conventions

## Checklist
- [ ] Searched for existing solutions?
- [ ] Can extend existing models?
- [ ] Found pattern examples?
- [ ] Verified issue isn't just your code?