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

### Safe Removal Pattern (Two-Phase Deploy)

**Phase 1 (This PR):**
1. Remove ALL code usage of column
2. Add column to `ignored_columns`
3. Deploy (column stays in database)

**Phase 2 (Future PR - After Phase 1 deployed everywhere):**
4. Drop column (migration)
5. Remove from `ignored_columns`

**Why Two Phases?**
- Multi-tenant staging: Multiple PR branches run against same database
- Review apps with old code need column to exist
- Production rollback needs column to exist
- `ignored_columns` tells Rails "column doesn't exist" while keeping it in database

**Example:**
```ruby
# Phase 1: Stop using sync_on_tag_added column
class SeismicSettings < ApplicationRecord
  self.ignored_columns = %w[
    sync_on_tag_added
    selected_tags
  ]
end
```

**CRITICAL ORDER:**
1. Remove code that accesses column FIRST
2. Add to ignored_columns SECOND
3. If reversed: Rails errors when code tries to access ignored column

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
- Dropping column without `ignored_columns` first (breaks other staging PRs)
- Adding to `ignored_columns` before removing code usage (Rails errors)
- Dropping column in same PR as removing code usage (should be two PRs)
- Changing types in place
- Adding NOT NULL to existing column
- Adding unique constraint without data check

## Common Mistakes

**WRONG - Single PR with column drop:**
```ruby
# PR combines code changes + migration = breaks staging
class RemoveSyncColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :seismic_settings, :sync_on_tag_added
  end
end
```
→ Other staging PR branches crash when they query the missing column

**WRONG - ignored_columns before removing usage:**
```ruby
# Added ignored_columns but code still uses it
self.ignored_columns = %w[sync_on_tag_added]

def sync_enabled?
  sync_on_tag_added || sync_on_public  # Rails error!
end
```
→ Rails raises error when code tries to access ignored column

**CORRECT - Two-phase approach:**
```ruby
# PR 1: Remove usage, add ignored_columns
def sync_enabled?
  sync_on_public  # No longer uses sync_on_tag_added
end

self.ignored_columns = %w[sync_on_tag_added]

# PR 2 (weeks later, after PR 1 deployed): Drop column
class RemoveSyncColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :seismic_settings, :sync_on_tag_added
  end
end
```
