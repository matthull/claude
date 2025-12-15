---
name: supabase-migrations
description: Guidance for writing Supabase database migrations with idempotent patterns. This skill should be used when creating or modifying database objects (tables, functions, RLS policies, triggers, indexes) or any SQL committed as a migration file.
---

# Supabase Migrations

Supabase uses timestamped SQL migrations in `supabase/migrations/`. Migrations run once, in order, and cannot be rolled back. This requires idempotent patterns.

## Key Constraints

1. **No rollback** - Migrations only go forward
2. **No repeatable migrations** - Cannot re-run modified files (unlike Flyway's `R__` prefix)
3. **No checksum validation** - System won't detect edits to already-run migrations

**Critical rule:** Never edit a migration that has already run in any environment. Create a new migration instead.

## Pattern Selection

| Object Type | Pattern | Rationale |
|-------------|---------|-----------|
| Tables | `CREATE TABLE` | One-time DDL, never modified after creation |
| Functions | `CREATE OR REPLACE FUNCTION` | Idempotent, can be updated in new migrations |
| RLS Policies | `DROP POLICY IF EXISTS` + `CREATE POLICY` | Policies cannot be replaced, must drop first |
| Triggers | `DROP TRIGGER IF EXISTS` + `CREATE TRIGGER` | Same as policies |
| Indexes | `CREATE INDEX CONCURRENTLY IF NOT EXISTS` | Non-blocking, **separate file per index** |

## Workflow

```bash
# Create new migration
npx supabase migration new <name>

# Apply locally (drops everything, runs all migrations + seed)
npx supabase db reset

# Apply pending only (preserves data)
npx supabase db push

# Check status
npx supabase migration list
```

## Naming Convention

```
YYYYMMDDHHMMSS_<action>_<object>.sql
```

Examples:
- `20251215100000_create_businesses.sql`
- `20251215100001_add_rls_policies.sql`
- `20251220100000_update_auth_hook_v2.sql`

## Checklist Before Completing Migration

1. **New table?** Add to PowerSync publication: `ALTER PUBLICATION powersync ADD TABLE new_table;`
2. **Auth hook function?** Grant/revoke permissions appropriately
3. **RLS on table?** Both `ENABLE ROW LEVEL SECURITY` and `FORCE ROW LEVEL SECURITY` required
4. **Modifying existing function?** Use `CREATE OR REPLACE` in a new migration file
5. **Adding index?** Use `CREATE INDEX CONCURRENTLY` in its own separate migration file (one index per file)

## Detailed Patterns

For structural examples, read `references/patterns.md` in this skill directory.

**Note:** Examples show idempotent *structure*, not business logic. Actual SQL implementation should come from your feature specs and research docs.
