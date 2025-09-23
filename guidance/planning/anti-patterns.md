---
type: guidance
status: current
category: planning
---

# Planning Anti-Patterns

## Over-Specification
❌ Planning service objects before complexity exists
❌ Defining helper classes upfront
❌ Specifying internal file organization
✅ Let these emerge during implementation

## Premature Abstraction
❌ ContentUploader service in plan
✅ Inline code first, extract when complex

❌ FolderManager class in design
✅ Simple methods until proven need

## Brownfield Mistakes
❌ Creating IntegrationSettings when SeismicIntegration exists
✅ Extend existing models

❌ Assuming global breakage ("encryption is broken")
✅ Test your specific case first

## Planning Creep
❌ HOW details (class structure, file organization)
✅ WHAT goals (data model, API surface)

❌ Implementation tactics
✅ Business requirements

## Pattern Invention
❌ New patterns without checking existing code
✅ Search for existing patterns first

❌ Creating parallel structures
✅ Use what exists

## Examples from Real Projects

### Seismic Integration
**Wrong in Plan:**
- New IntegrationSettings model
- ContentUploader service
- FolderManager service
- Contract tests first

**Should Have Been:**
- Extend SeismicIntegration
- Use ThirdPartySync concern
- Let services emerge
- Normal TDD

## Checklist
- [ ] Focused on WHAT not HOW?
- [ ] Avoided pre-planning services?
- [ ] Used existing models/patterns?
- [ ] Deferred implementation details?