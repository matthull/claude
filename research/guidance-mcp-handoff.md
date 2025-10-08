# Guidance MCP Server - Handoff Document

**Date**: 2025-10-03
**Status**: Production Ready
**Tests**: 379 passing (0 failing)

## Summary

Built and debugged a Model Context Protocol (MCP) server that provides guidance file search and loading capabilities through two tools:
1. `guidance_load` - Search-based guidance file loading with focus level filtering
2. `guidance_bundle_load` - Direct bundle loading by name

## Current State

### ✅ Production Ready
- All 379 tests passing
- End-to-end testing completed
- Performance: 20-40ms typical search time
- Both tools working correctly

### What Works

**guidance_load tool:**
- ✓ Search by keyword across guidance files
- ✓ Filter by focus level (strategic/design/implementation)
- ✓ Relevance scoring (filename: 1000, tags: 100, category: 50, content: 10)
- ✓ Auto-load top 2-3 matches, list additional options
- ✓ Supports both guidance files AND bundles
- ✓ Performance metrics in output

**guidance_bundle_load tool:**
- ✓ Direct bundle loading by name (e.g., "rails", "testing")
- ✓ Project bundle priority over global bundles
- ✓ Layer-aware search (foundation → domain → practice → technique)
- ✓ Clear "not found" messages
- ✓ Fast (<50ms discovery, <100ms loading)

### Key Files

**MCP Server:**
- `~/.claude/mcp-servers/guidance/src/mcp-server/tools/definitions/guidance-load.tool.ts`
- `~/.claude/mcp-servers/guidance/src/mcp-server/tools/definitions/guidance-bundle-load.tool.ts`

**Services:**
- `src/services/guidance/guidance-search.service.ts` - Search and scoring
- `src/services/guidance/ripgrep.service.ts` - Fast file filtering
- `src/services/guidance/metadata-extractor.service.ts` - YAML frontmatter parsing
- `src/services/guidance/guidance-loader.service.ts` - File content loading

**Tests:**
- `tests/integration/guidance-load.tool.test.ts`
- `tests/integration/guidance-bundle-load.tool.test.ts`
- `tests/services/ripgrep.service.test.ts`
- `tests/services/guidance-search.service.test.ts`

## Major Bugs Fixed

### Bug 1: Bundle Metadata Validation Failure
**Problem:** Searching for "rails" returned wrong files (tmux-sidecar.md, debugging-workflow.md) instead of bundles/technique/rails.md

**Root Cause:** Metadata extractor required `category` field, but bundles have `layer` instead
- Line 49-57 in `metadata-extractor.service.ts` rejected bundles
- Bundle metadata extraction returned `null`
- Bundles filtered out during scoring phase

**Fix:** Changed validation to accept either `category` OR `layer`:
```typescript
if (
  !metadata ||
  !metadata.type ||
  (!metadata.category && !metadata.layer) ||  // Accept either
  !metadata.focus_levels
) {
  return null;
}
```

### Bug 2: Ripgrep YAML List Matching
**Problem:** Focus level and tag searches only found items as first list element

**Root Cause:** Pattern `^- implementation$` only matched at line start, not within YAML lists

**Fix:** Use multiline mode with proper pattern:
```typescript
const { stdout } = await execa('rg', [
  '-l',
  '-U',                                    // Multiline mode
  '--multiline-dotall',                    // . matches newlines
  '--type', 'md',
  `focus_levels:[\\s\\S]*?^- ${level}$`,  // Match anywhere in list
  searchPath,
]);
```

### Bug 3: Scoring Weights Too Small
**Problem:** Incidental content mentions scored too close to actual matches

**Original:** filename: 100, category: 80, tags: 60, content: 40
**Fixed:** filename: 1000, tags: 100, category: 50, content: 10

**Result:** Rails bundle (score 1110) now dominates incidental mentions (score 10)

## Optional Enhancements (Not Critical)

### Low Priority
1. **@-reference resolution** - Recursively load referenced files (~2-3 hours)
   - Currently loads bundle file only, not @-referenced guidance
   - Could enhance `GuidanceLoaderService` to follow @-references
   
2. **Load-by-number feature** - `/guidance load 1,3,5` from search results
   - Would need to store search results in session state
   - MCP is stateless, so requires workaround

3. **Project-specific guidance path** - Currently hardcoded
   - Hardcoded: `~/.claude/project-guidance`
   - Could auto-detect from CWD or config

4. **Manual review of focus levels** - Auto-assigned in 15+ files
   - Review auto-assigned focus_levels for accuracy
   - Update if needed

### Won't Do
- Complex fuzzy matching (keep it simple - ripgrep is fast enough)
- Full-text search across all content (too slow, defeats focus level filtering)
- Caching (files change, invalidation complex)

## Testing Protocol

**Quick Smoke Test:**
```bash
cd ~/.claude/mcp-servers/guidance

# Run all tests
bun test

# Rebuild
bun run build

# Kill old instances
pkill -f "guidance/dist/index.js"

# Reconnect in Claude Code
/mcp
```

**Test Cases:**
1. Search for "rails" at implementation level → Should return bundles/technique/rails.md first
2. Load bundle "rails" → Should load directly without search
3. Load bundle "nonexistent" → Should return clear "not found" message
4. Search for "testing" → Should return test-driven-development.md high-scored

## Performance Characteristics

**Search (guidance_load):**
- Phase 1 (focus filter): ~10-15ms for 36 files
- Phase 2 (keyword search): ~5-10ms
- Phase 3-5 (scoring): ~5-10ms
- **Total: 20-40ms typical**

**Bundle Load (guidance_bundle_load):**
- Discovery: <5ms (filesystem checks)
- Loading: ~10-20ms (single file read)
- **Total: <50ms typical**

## Key Learnings

### 1. TDD Violation Cost
Didn't follow TDD for `guidance_bundle_load` → hit runtime error (`loadFiles` vs `loadMultiple`)
- Lesson: Always write failing test first, even for "simple" tools
- Cost: Extra rebuild/restart cycle

### 2. Debug Logging Strategy
File-based debug logging (`/tmp/guidance-search-debug.log`) was crucial
- Console.error didn't work (MCP stdio transport)
- Logger debug level too high in production
- Temp file writes bypassed all that

### 3. Multiline Regex in Ripgrep
YAML list matching requires specific flags:
- `-U` for multiline
- `--multiline-dotall` for . matching newlines
- Pattern: `focus_levels:[\s\S]*?^- level$`
- Without these: only matches first list item

### 4. Metadata Type Flexibility
Don't assume uniform structure - guidance files have `category`, bundles have `layer`
- Use optional fields in TypeScript types
- Validate for "at least one of" not "all required"

## Build & Deployment

**Build:**
```bash
cd ~/.claude/mcp-servers/guidance
bun run build
```

**Restart MCP Server:**
```bash
pkill -f "guidance/dist/index.js"
# Then in Claude Code: /mcp
```

**Configuration:**
- MCP config: `~/.claude/mcp-servers.json`
- Guidance path: `~/.claude/guidance/`
- Bundles path: `~/.claude/guidance/bundles/`
- Project bundles: `~/.claude/project-guidance/bundles/` (optional override)

## Next Steps (If Resuming)

1. **Optional: Implement @-reference resolution**
   - Modify `GuidanceLoaderService.loadFile()` to parse and recursively load @-references
   - Update tests to verify recursive loading
   - Add cycle detection

2. **Optional: Add bundle listing tool**
   - New tool: `guidance_bundle_list`
   - Returns all available bundles with descriptions
   - Helps with discovery

3. **Optional: Add focus level validation script**
   - Review 15+ files with auto-assigned focus_levels
   - Create script to check for inconsistencies

## Links
- Original plan: `~/.claude/research/guidance-mcp-plan.md`
- MCP server: `~/.claude/mcp-servers/guidance/`
- Global guidance: `~/.claude/guidance/`
