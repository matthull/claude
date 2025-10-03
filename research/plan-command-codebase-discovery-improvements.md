# Plan Command Improvements: Codebase Discovery in Phase 0

**Date**: 2025-10-02
**Context**: Enhance /plan command to enforce discovery of existing code patterns before creating new code

## Problem Statement

Existing context and guidelines get missed even when we state "follow existing patterns." We need an explicit process (gate, research step) for:
- Researching existing patterns in the codebase
- Finding existing classes/methods/components that already solve a problem
- Identifying code that should be modified rather than creating something new
- Finding existing code to use as templates for new implementations

**Core Principle**: Never assume you should create anything new without searching first, and checking with user for confirmation.

## Proposed Solution

### Enhance Phase 0 with Mandatory Codebase Discovery

Make Phase 0 a two-part research phase:
1. **Part 1: Codebase Discovery** (NEW - mandatory first step with user approval gate)
2. **Part 2: External Research** (existing - resolve Technical Context unknowns)

### Part 1: Codebase Discovery Guidelines

**Required Searches** (adapt per project/feature):
- API clients for external services (e.g., if you need Stripe integration, search for existing Stripe client)
- Models/entities handling similar data (e.g., if feature needs Asset tracking, search existing Asset models)
- Services performing similar operations (e.g., if you need notifications, search for existing notification services)
- Background jobs with similar patterns (e.g., if you need async processing, find existing async job patterns)
- UI components with similar behavior (e.g., if you need a modal, search for existing modal components)
- Shared concerns/mixins for cross-cutting functionality (e.g., search for Syncable, Trackable, Timestampable concerns)
- Utility classes/helpers for common operations (e.g., formatters, validators, parsers)

**Discovery Decision Framework:**
- **EXTEND**: Existing code handles 70%+ of requirements → modify/enhance existing code
- **FORK**: Existing code has similar structure but different purpose → use as template
- **CREATE**: No existing solution or template found → document justification for new code

**Documentation Format** (in research.md):
```markdown
## Codebase Discovery

### Existing Solutions Analysis
| Requirement | Existing Code Found | Decision | Rationale |
|-------------|-------------------|----------|-----------|
| API client for Seismic | Seismic::Client | EXTEND | Add folder methods |
| Sync status tracking | ThirdPartySync concern | EXTEND | Add properties support |
| Sync button UI | None found | CREATE | New user-facing feature |

### Templates for New Code
| New File Needed | Template Identified | Pattern Match |
|-----------------|-------------------|---------------|
| SeismicSyncJob | ExportMediaAssetJob | Async external API pattern |
| SyncStatusCard.vue | PublishingStatusCard.vue | Status display pattern |
```

**GATE**: User must approve discovery findings before proceeding to Part 2 (external research).

### Part 2: External Research

(Existing Phase 0 behavior - now labeled as Part 2):
1. Extract unknowns from Technical Context section
2. Research external dependencies, best practices, integration patterns
3. Document decisions with rationale and alternatives considered
4. Resolve all NEEDS CLARIFICATION items

## Implementation Changes

### 1. plan-template.md - Rewrite Phase 0 Section

Replace existing Phase 0 (lines ~144-163) with two-part structure:
- Part 1: Codebase Discovery (mandatory, user approval gate)
- Part 2: External Research (existing behavior)

### 2. plan-template.md - Update Constitution Check

Add new gate check:
```markdown
### Codebase Discovery Gate
- [ ] Systematic search performed for all required functionality
- [ ] EXTEND vs CREATE decisions documented with rationale
- [ ] Templates identified for all new file creations (or justification for none)
- [ ] User approved codebase discovery findings
```

### 3. plan-template.md - Update Execution Flow

Update step 7 in Execution Flow:
```
7. Execute Phase 0 → research.md
   → Part 1: Codebase discovery (search existing code, identify templates)
   → GATE: User approval on EXTEND/CREATE decisions
   → Part 2: External research (resolve Technical Context unknowns)
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
```

## Key Benefits

1. **Discovery integrated naturally**: Research phase already exists, now includes codebase search as mandatory first step
2. **Principle-based**: Guidelines not prescriptive commands - adapt search approach per project
3. **User oversight**: Explicit approval gate prevents premature creation
4. **Prevents duplication**: Enforces "search first, create last" mindset
5. **Better documentation**: Discovery findings captured in research.md alongside external research
6. **Pattern consistency**: Using templates ensures new code follows established patterns

## Example: Before vs After

### Before (Current)
Phase 0 focuses only on external research:
- "What's the best practice for file uploads?"
- "Which library should we use for X?"
- No systematic codebase search

Result: Often creates duplicate functionality or misses reuse opportunities.

### After (Improved)
Phase 0 Part 1 forces codebase discovery:
- "Does an upload service already exist?" → Found `FileUploadService`
- "Are there sync concerns?" → Found `ThirdPartySync` concern
- "Similar background jobs?" → Found `ExportMediaAssetJob` as template

Phase 0 Part 2 then handles external research:
- "Best practices for Seismic API integration"
- "Rate limiting strategies"

Result: Extends existing code, follows established patterns, creates only when necessary.
