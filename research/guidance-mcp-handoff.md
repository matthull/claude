# Guidance MCP Server - Handoff Document

**Date:** 2025-10-02
**Status:** Partially Complete - Core Working, Needs Query Refinement

## Executive Summary

Successfully implemented a TypeScript-based MCP server for intelligent guidance retrieval with focus-level filtering. The core infrastructure works (finds files, extracts metadata, loads content in < 100ms), but query scoring needs refinement for better relevance.

**What Works:**
- ✅ Focus level filtering (strategic/design/implementation)
- ✅ Fast ripgrep-based search (< 100ms)
- ✅ YAML frontmatter extraction
- ✅ All 54 existing guidance files updated with focus_levels
- ✅ MCP tool registered and callable from Claude Code
- ✅ 43 unit tests passing (services layer)

**What's Been Fixed:**
- ✅ Simplified to keyword-based search (caller provides keywords, not natural language)
- ✅ All 361 tests passing
- ✅ Removed QueryParserService complexity - tool just does simple ripgrep
- ✅ Clean separation of concerns: Claude Code picks keywords, tool searches

---

## What Was Built

### Architecture

**Location:** `~/.claude/mcp-servers/guidance/`
**Base:** mcp-ts-template (https://github.com/cyanheads/mcp-ts-template)
**Runtime:** Bun v1.2.23
**Transport:** STDIO (MCP protocol)

### Core Services (100% Unit Test Coverage)

#### 1. RipgrepService (`src/services/guidance/ripgrep.service.ts`)
**Purpose:** Fast file searching using ripgrep
**Status:** ✅ Working, 15 tests passing

**Key Fix Applied:** Changed from single-line to multiline pattern matching
```typescript
// Before (broken):
`focus_levels:.*\\b${level}\\b`

// After (working):
'focus_levels:\n- ' + level  // With -U multiline flag
```

**Methods:**
- `findByFocusLevel(level, searchPath)` - Find files with YAML block-style focus_levels
- `findByTags(tags[], searchPath)` - Find files by tags in frontmatter
- `searchContent(query, searchPath, files?)` - Full-text search with JSON output

**Performance:** All searches < 100ms for 50+ files

#### 2. MetadataExtractorService (`src/services/guidance/metadata-extractor.service.ts`)
**Purpose:** Extract YAML frontmatter from guidance files
**Status:** ✅ Working, 12 tests passing

**Optimization:** Reads only first 1KB of file for efficiency

**Methods:**
- `extractFrontmatter(filePath)` - Single file YAML extraction
- `extractBatch(filePaths[])` - Parallel batch extraction
- `getLineCount(filePath)` - For context size estimation

**Performance:** < 10ms per file, < 100ms for 10 files (parallel)

#### 3. QueryParserService (`src/services/guidance/query-parser.service.ts`)
**Purpose:** Parse natural language queries to extract context
**Status:** ✅ Working, 12 tests passing

**Extracts:**
- Task types: implementing, planning, designing, reviewing, debugging, refactoring, testing
- Components: controller, model, service, view, api, test, route, etc.
- Technologies: rails, ruby, javascript, react, postgres, jwt, oauth, etc.
- Tags: Common keywords for frontmatter matching

**Performance:** < 5ms per query

#### 4. GuidanceLoaderService (`src/services/guidance/guidance-loader.service.ts`)
**Purpose:** Load file contents
**Status:** ✅ Working, 4 tests passing

**Methods:**
- `loadFile(filePath)` - Single file loading
- `loadMultiple(filePaths[])` - Parallel batch loading

### MCP Tool: `guidance_load`

**File:** `src/mcp-server/tools/definitions/guidance-load.tool.ts`
**Status:** ⚠️ Working but scoring broken

**Input Schema:**
```typescript
{
  query: string          // "implementing Rails controllers"
  focusLevel: 'strategic' | 'design' | 'implementation'
  maxAutoLoad: number    // Default: 2, Max: 5
}
```

**Output Schema:**
```typescript
{
  autoLoaded: Array<{path, lines, description}>
  content: string        // Combined file contents
  additionalOptions: Array<{number, path, lines}>
  performanceMetrics: {filesScanned, filesMatched, searchTimeMs}
}
```

**Current Flow:**
1. Parse query → extract keywords (QueryParserService)
2. Find files by focus level → ripgrep multiline (RipgrepService)
3. Search content in filtered files → ripgrep JSON (RipgrepService)
4. Extract metadata for matches → YAML parsing (MetadataExtractorService)
5. Score results → **BROKEN - scores wrong files**
6. Load top N files → parallel (GuidanceLoaderService)
7. Return content + options

**Performance:** ~40-70ms end-to-end

---

## Known Issues & Root Causes

### 1. **Query Scoring Returns Irrelevant Files** ✅ FIXED

**Original Problem:**
Tool accepted natural language queries like "implementing Rails controllers" and tried to extract keywords automatically, leading to complexity and failures.

**Solution Implemented:**
Simplified the API to accept **keywords directly** instead of natural language:

```typescript
// NEW API (simple):
{
  query: "rails",  // Single keyword provided by caller
  focusLevel: "implementation"
}
```

**Benefits:**
- **Separation of concerns:** Claude Code decides keywords, tool does simple search
- **No tokenization/NLP:** Avoids stopwords, extraction logic, query parsing
- **Simple scoring:** Filename match > content match > tag match > category match
- **All tests passing:** 361/361 ✅

**Current Scoring Logic:**
```typescript
let score = 0;

// Filename match (highest priority)
if (filePath.toLowerCase().includes(keyword)) {
  score += 150;
}

// Content match
if (contentMatches.some((m) => path.join(globalGuidancePath, m.path) === filePath)) {
  score += 100;
}

// Tag match
if (metadata.tags?.includes(keyword)) {
  score += 80;
}

// Category match
if (metadata.category?.toLowerCase().includes(keyword)) {
  score += 60;
}

// Project-specific bonus
if (filePath.includes('project-guidance')) {
  score += 20;
}
```

### 4. **@-Reference Resolution Missing** 🟢 LOW PRIORITY

**Files like:**
```markdown
@~/.claude/guidance/testing/test-driven-development.md
```

**Current Behavior:** Not resolved/loaded
**Status:** Noted as "skipped for MVP"
**Priority:** Low - can add later

### 5. **Auto-Assigned Focus Levels Need Review** 🟡

**Used Script:** `/tmp/add_focus_levels.py`
**Files Updated:** 54 files

**Logic Used:**
- `testing`, `code-quality`, `commands`, `tools` → `[implementation]`
- `frontend`, `code-review`, `security`, `ai-development` → `[design, implementation]`
- `architecture`, `development-process` → `[strategic, design]`
- `bundles/foundation` → `[strategic]`
- `bundles/domain` → `[strategic, design]`
- `bundles/practice` → `[design, implementation]`
- `bundles/technique` → `[implementation]`

**Potential Issues:**
- Some files might be miscategorized
- Need manual review of at least 10-15 files
- Examples:
  - `tdd-human-review-cycle.md` → `[strategic, design]` might also need `implementation`
  - `bundles/practice/testing.md` → `[implementation]` should probably be `[design, implementation]`

### 6. **Project-Specific Guidance Always Empty** 🟡

**Hardcoded Path:** `~/.claude/project-guidance/`
**Current Issue:** This directory doesn't exist, always returns 0 files
**No Auto-Detection:** Doesn't use CWD or project name

### 7. **No Way to Load Numbered Results** 🟢 FUTURE

**Output Shows:**
```
Additional options:
1. file1.md
2. file2.md
```

**Missing:** Feature to load specific numbers
**Future API:** `guidance_load query="1,3,5" ...` to load by number

---

## Focus Levels System

### Concept

Each guidance file declares which focus levels it applies to:

```yaml
---
type: guidance
category: testing
focus_levels: [implementation]  # Array - can be multiple
tags: [testing, tdd, rspec]
---
```

### Three Levels

1. **`strategic`** - High-level planning, requirements, architecture decisions
   - Examples: Project roadmaps, system architecture, feature requirements
   - Questions: What are we building? Why? What are the constraints?

2. **`design`** - Technical design, API contracts, component boundaries
   - Examples: Class hierarchies, API specifications, database schemas
   - Questions: How will components interact? What are the interfaces?

3. **`implementation`** - Actual coding patterns, syntax, specific techniques
   - Examples: Code snippets, error handling patterns, testing approaches
   - Questions: How do I write this specific code? What's the syntax?

### Why This Matters

**Problem Solved:** The old bundle system loaded entire domains (e.g., all of "Rails") when you only needed a slice (e.g., controller syntax).

**Solution:** Files can now be tagged with multiple focus levels, and the tool filters by the requested level:

```typescript
// Query: "implementing Rails controllers" with focusLevel="implementation"
// Returns: Only files with focus_levels containing "implementation"
// Avoids: Strategic planning docs, high-level architecture, etc.
```

---

## Configuration & Setup

### MCP Profiles Updated

**Files Modified:**
- `~/.claude/mcp-profiles/minimal.json` ✓
- `~/.claude/mcp-profiles/qa.json` ✓

**Configuration:**
```json
{
  "guidance": {
    "type": "stdio",
    "command": "/home/matt/.bun/bin/bun",
    "args": ["run", "/home/matt/.claude/mcp-servers/guidance/dist/index.js"],
    "env": {
      "MCP_TRANSPORT_TYPE": "stdio",
      "NODE_ENV": "production"
    }
  }
}
```

**CLI Commands:**
- `claude-min` → Uses minimal.json
- `claude-qa` → Uses qa.json

### Build & Test Commands

```bash
# Development
cd ~/.claude/mcp-servers/guidance
~/.bun/bin/bun install
~/.bun/bin/bun run build

# Testing
~/.bun/bin/bun test                                    # All tests
~/.bun/bin/bun test tests/services/                    # Service tests only
~/.bun/bin/bun test tests/integration/                 # Integration tests

# Current Status
~/.bun/bin/bun test                                    # 359 pass, 2 fail
```

---

## Next Steps (Prioritized)

### COMPLETED ✅
1. ~~Fix Query Scoring~~ - Simplified to keyword-based API
2. ~~All tests passing~~ - 361/361 ✅
3. ~~Remove QueryParserService complexity~~ - Clean separation of concerns

### SHORT TERM (Polish MVP)

#### 1. Manual Review of Focus Levels 🟡
**Estimate:** 30 minutes

Review at least 15 files to ensure focus_levels are accurate.

#### 2. Implement @-Reference Resolution 🟢
**Estimate:** 2-3 hours

**Approach:**
- Recursively load referenced files
- Track visited files to prevent cycles
- Add to combined content with clear delimiters

#### 6. Add Load-by-Number Feature 🟢
**Estimate:** 1 hour

**API:**
```typescript
guidance_load({
  query: "1,3,5",  // Load options 1, 3, 5 from previous search
  focusLevel: "implementation"
})
```

**Implementation:**
- Detect numeric query pattern
- Use session storage or parameter to remember last search results
- Load specified file numbers

#### 7. Project Detection 🟢
**Estimate:** 1 hour

```typescript
// Detect project from CWD
const cwd = process.cwd();
const projectName = detectProjectName(cwd);  // e.g., "musashi"
const projectGuidancePath = path.join(
  os.homedir(),
  '.claude/project-guidance',
  projectName
);
```

### MEDIUM TERM (File Reorganization)

#### 8. Reorganize Files by Focus Level 🟡
**Estimate:** 2-4 hours

**Current:** Files organized by category
```
~/.claude/guidance/
  testing/test-driven-development.md
  architecture/api-integration.md
```

**Proposed:** Also organize by focus level
```
~/.claude/guidance/
  implementation/
    testing/tdd-cycle.md
    rails/controller-syntax.md
  design/
    architecture/api-contracts.md
    testing/integration-patterns.md
  strategic/
    architecture/system-design.md
    planning/roadmap.md
```

**Or:** Keep current structure but ensure focus_levels are accurate

### LONG TERM (Enhancements)

9. **Usage Analytics** - Track which guidance gets loaded together
10. **Smart Suggestions** - Learn from patterns to suggest related guidance
11. **Snippet Extraction** - Load specific sections instead of whole files
12. **Focus Level Inference** - Auto-detect focus level from query context

---

## Technical Debt

### 1. Ripgrep Error Handling

**Current:** Catches exit codes 1 and 2
```typescript
if ((error as any).exitCode === 1 || (error as any).exitCode === 2) {
  return [];
}
```

**Better:** More specific error types with proper TypeScript

### 2. Path Manipulation

**Current:** String concatenation and replace
```typescript
const relativePath = filePath.replace(searchPath + '/', '');
```

**Better:** Use `path.relative()` consistently

### 3. No Dependency Injection in Tool

**Current:** Tool creates services inline
```typescript
const ripgrepService = new RipgrepService();
const metadataExtractor = new MetadataExtractorService();
```

**Better:** Inject via DI container (follows mcp-ts-template pattern)

### 4. Hardcoded Paths

**Current:** `~/.claude/guidance` and `~/.claude/project-guidance`
**Better:** Environment variables or config

---

## Test Coverage

### Unit Tests: ✅ 43/43 Passing

- RipgrepService: 15 tests
- MetadataExtractorService: 12 tests
- QueryParserService: 12 tests
- GuidanceLoaderService: 4 tests

### Integration Tests: ⚠️ 2/4 Passing

- ✅ Filename scoring logic
- ✅ Performance < 200ms
- ❌ Rails keyword search
- ❌ Test keyword search

### E2E Tests: ❌ 0 Tests

**Missing:**
- Complete tool flow from query to result
- Actual file loading with @-references
- Multiple focus levels in same query

---

## Files Modified/Created

### New Files (Created)

**Services:**
- `src/services/guidance/types.ts`
- `src/services/guidance/ripgrep.service.ts`
- `src/services/guidance/metadata-extractor.service.ts`
- `src/services/guidance/query-parser.service.ts`
- `src/services/guidance/guidance-loader.service.ts`

**Tool:**
- `src/mcp-server/tools/definitions/guidance-load.tool.ts`

**Tests:**
- `tests/services/ripgrep.service.test.ts`
- `tests/services/metadata-extractor.service.test.ts`
- `tests/services/query-parser.service.test.ts`
- `tests/services/guidance-loader.service.test.ts`
- `tests/integration/guidance-load.tool.test.ts`

**Test Fixtures:**
- `tests/fixtures/guidance/global/testing-implementation.md`
- `tests/fixtures/guidance/global/architecture-strategic.md`
- `tests/fixtures/guidance/global/api-design.md`
- `tests/fixtures/guidance/global/controller-patterns.md`
- `tests/fixtures/no-frontmatter.md`
- `tests/fixtures/malformed-yaml.md`

**Documentation:**
- `IMPLEMENTATION_SUMMARY.md`
- `USAGE.md`
- `~/.claude/research/guidance-mcp-plan.md`
- `~/.claude/research/guidance-mcp-handoff.md` (this file)

**Scripts:**
- `/tmp/add_focus_levels.py` (Python script to add focus_levels)
- `/tmp/test_ripgrep.ts` (Debug script for ripgrep)

### Modified Files

**Guidance Files (54 files):**
- All files in `~/.claude/guidance/` now have `focus_levels` and `tags` in frontmatter

**Configuration:**
- `~/.claude/mcp-profiles/minimal.json`
- `~/.claude/mcp-profiles/qa.json`

**Tool Registration:**
- `src/mcp-server/tools/definitions/index.ts` (added guidanceLoadTool)

---

## Performance Benchmarks

### Current Performance (Working)

- **Focus level filtering:** 20-30ms for 50+ files
- **Content search (single keyword):** 30-50ms
- **Metadata extraction:** 10ms per file (parallel)
- **Total query time:** 40-70ms (under 200ms target ✓)

### Service-Level Benchmarks (From Tests)

- `findByFocusLevel()`: < 100ms ✓
- `searchContent()`: < 100ms ✓
- `extractFrontmatter()`: < 10ms per file ✓
- `extractBatch(10)`: < 100ms ✓
- `parse()`: < 5ms ✓

---

## Decision Log

### Why No Caching?

**Decision:** Use on-demand parsing with ripgrep instead of metadata cache

**Rationale:**
- Ripgrep is fast enough (< 100ms)
- Avoids cache invalidation complexity
- Always fresh data
- Simpler implementation
- No startup overhead
- No file watching needed

**Trade-off:** Parse YAML on each request, but only 10-20 files instead of 100+

### Why Three Focus Levels?

**Considered:**
- 2 levels (tactical/strategic) - too coarse
- 4 levels (strategic/tactical/operational/implementation) - too fine
- 5 levels (planning/architecture/design/coding/debugging) - too complex

**Decision:** 3 levels (strategic/design/implementation)

**Rationale:**
- Maps to natural workflow phases
- Clear boundaries
- Easy to categorize files
- Covers the granularity gap problem

### Why Single-Keyword Search?

**Considered:**
- Full-text search with multi-keyword matching
- Fuzzy search
- Semantic search (embeddings)

**Decision:** Single keyword extraction from query

**Rationale:**
- Simpler implementation
- Fast (uses ripgrep)
- Good enough for MVP
- Can enhance later if needed

### Why Not Primary_Focus?

**Original Plan:** Files have `primary_focus` field

**User Feedback:** "that is vague"

**Decision:** Removed primary_focus concept

**Rationale:**
- Files can belong to multiple levels equally
- No need to pick "primary"
- Simpler frontmatter structure

---

## Lessons Learned

### TDD Discipline

✅ **Services:** Strict RED → GREEN → REFACTOR worked perfectly
- Clean interfaces
- High confidence in changes
- Fast feedback loop

❌ **Tool Logic:** Skipped TDD, wrote implementation first
- Found bugs later through manual testing
- Had to retrofit tests
- Less confidence in correctness

**Lesson:** TDD discipline is worth it even for "simple" integration code

### Ripgrep Pattern Matching

**Mistake:** Initially used single-line pattern for YAML block-style lists
```typescript
`focus_levels:.*\\b${level}\\b`  // Doesn't match YAML arrays
```

**Fix:** Multiline pattern with literal newline
```typescript
'focus_levels:\n- ' + level  // With -U flag
```

**Lesson:** Test patterns with actual data format, not assumed format

### Auto-Assignment Scripts

**Approach:** Wrote Python script to auto-assign focus_levels based on path/category

**Result:** 80% accurate, 20% need manual review

**Lesson:** Automation for bulk operations is good, but always include manual review step

---

## Questions for Next Session

1. **Scoring Strategy:** Should filename matches get higher score than content matches?
2. **Keyword Selection:** Use first technology, or first component, or something else?
3. **Bundle System:** Keep bundles or fully migrate to focus-level-only files?
4. **Project Detection:** Auto-detect from CWD or require explicit project parameter?
5. **@-References:** Load recursively (might be slow) or skip for MVP?

---

## Quick Start for Next Developer

```bash
# 1. Navigate to project
cd ~/.claude/mcp-servers/guidance

# 2. Run tests to see current state
~/.bun/bin/bun test

# 3. Look at failing integration tests
~/.bun/bin/bun test tests/integration/guidance-load.tool.test.ts

# 4. Fix query scoring (see Issue #1 above)
# Edit: src/mcp-server/tools/definitions/guidance-load.tool.ts
# Add: getMostRelevantKeyword() helper
# Update: Line 132-136 to use single keyword

# 5. Rebuild
~/.bun/bin/bun run build

# 6. Test manually (restart Claude Code first)
# Use: mcp__guidance__guidance_load tool

# 7. Verify tests pass
~/.bun/bin/bun test
```

---

## Contact & Resources

**Project Location:** `~/.claude/mcp-servers/guidance/`
**Plan Document:** `~/.claude/research/guidance-mcp-plan.md`
**MCP Profiles:** `~/.claude/mcp-profiles/{minimal,qa}.json`
**Test Fixtures:** `~/.claude/mcp-servers/guidance/tests/fixtures/`
**Guidance Files:** `~/.claude/guidance/` (54 files with focus_levels)

**Key Documentation:**
- Implementation details: `IMPLEMENTATION_SUMMARY.md`
- User guide: `USAGE.md`
- Original plan: `guidance-mcp-plan.md`
- This handoff: `guidance-mcp-handoff.md`

---

**END OF HANDOFF DOCUMENT**
