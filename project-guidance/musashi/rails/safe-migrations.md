---
type: guidance
status: current
category: rails
tags:
- backend
- database
- migrations
focus_levels:
- strategic
- design
- implementation
---

# Safe Database Migrations (NON-NEGOTIABLE)

## ABSOLUTE RULES

### Breaking Migration Detection
You **MUST IMMEDIATELY STOP** if a migration:
- Adds column and uses it in same deploy
- Removes column without `ignored_columns` first
- Changes column type used by running code
- Adds constraint on existing data
- Renames column used by running code

**RATIONALE:** Breaking migrations cause production downtime.

### Safe Addition Pattern
1. Add column (migration only)
2. Deploy
3. Use column (code in next PR)

### Safe Removal Pattern
1. Remove code usage
2. Add to `ignored_columns`
3. Deploy
4. Drop column (migration in next PR)

### Safe Column Rename
1. Add new column
2. Deploy
3. Dual-write to both columns
4. Backfill old → new
5. Deploy
6. Remove old column (safe removal pattern)

### Safe Type Change
1. Add new column with new type
2. Deploy
3. Dual-write to both columns
4. Backfill old → new
5. Deploy
6. Remove old column (safe removal pattern)

## Migration Checklist
- [ ] Migration deployable without code changes
- [ ] No column additions used immediately
- [ ] Column removals preceded by `ignored_columns`
- [ ] No type changes on active columns
- [ ] No constraints on existing data
- [ ] Tested against production-sized dataset
- [ ] Rollback plan documented

## Anti-patterns (CRITICAL)
- Adding column and using in same PR
- Removing column without ignoring first
- Changing types in place
- Adding NOT NULL to existing column
- Adding unique constraint without data check
