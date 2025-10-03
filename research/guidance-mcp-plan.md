# Simplified Guidance MCP Server Plan

## Core Concept
Single `guidance_load` tool that intelligently finds and loads task-specific guidance slices at the correct **focus level**, avoiding the "whole domain" problem of bundles.

## Performance Requirements
- **Fast text search** across 100+ markdown files (< 100ms)
- **Efficient frontmatter filtering** by focus level and tags (< 200ms)
- **On-demand YAML parsing** only for filtered files (10-20 files instead of 100+)
- **Parallel processing** for metadata extraction

## Focus Levels
Guidance operates at three distinct focus levels:

1. **`strategic`** - High-level planning, requirements, architecture decisions
   - Examples: Project roadmaps, system architecture, feature requirements
   - Questions: What are we building? Why? What are the constraints?

2. **`design`** - Technical design, API contracts, component boundaries
   - Examples: Class hierarchies, API specifications, database schemas
   - Questions: How will components interact? What are the interfaces?

3. **`implementation`** - Actual coding patterns, syntax, specific techniques
   - Examples: Code snippets, error handling patterns, testing approaches
   - Questions: How do I write this specific code? What's the syntax?

## MCP Server Structure
**Location:** `~/.claude/mcp-servers/guidance/`
**Base:** https://github.com/cyanheads/mcp-ts-template

**Directory Structure:**
```
~/.claude/mcp-servers/guidance/
├── src/
│   ├── mcp-server/
│   │   ├── tools/
│   │   │   ├── definitions/
│   │   │   │   └── guidance-load.ts
│   │   │   └── logic/
│   │   │       └── guidance-load.logic.ts
│   │   └── index.ts
│   ├── services/
│   │   ├── guidance-search.service.ts
│   │   ├── guidance-loader.service.ts
│   │   └── query-parser.service.ts
│   ├── config/
│   │   └── env.ts
│   └── types/
│       └── guidance.types.ts
├── package.json
├── tsconfig.json
├── README.md
└── .env

## The Single Tool: `guidance_load`

### Parameters
- `query` (required): Natural language description of what you need
- `focus_level` (required): One of `strategic`, `design`, or `implementation`
- `project` (optional): Project name for project-specific guidance
- `max_auto_load` (optional, default=2): Maximum files to auto-load

### Intelligent Search Algorithm

1. **Parse query for context signals**
   - Task type (implementing, planning, reviewing, debugging)
   - Component type (controller, service, model, test)
   - Technology (Rails, Ruby, JavaScript, etc.)

2. **Filter by focus level FIRST:**
   - Only consider guidance files that include the requested focus level
   - Files can declare multiple focus levels in frontmatter
   - Ensures granularity match before any other scoring

3. **Search across filtered sources:**
   - Individual guidance files in `~/.claude/guidance/`
   - Project guidance in `~/.claude/project-guidance/{project}/`
   - Bundle files (extract only sections matching focus level)
   - Match by: filename, category, tags, content keywords

4. **Smart Scoring (focus-aware):**
   - Exact task+component match: 100 (e.g., "implementing controllers" → controller-implementation.md)
   - Task-specific guidance: 80 (e.g., "implementing" → implementation-patterns.md)
   - Component-specific: 70 (e.g., "controllers" → controller-patterns.md)
   - Project-specific match: +20 bonus
   - Tag match: 50
   - Content keyword: 30

5. **Return format:**
   ```
   Auto-loaded (2 files, ~150 lines):
   ✓ rails/controller-patterns.md (80 lines) - Controllers implementation patterns
   ✓ testing/controller-testing.md (70 lines) - Testing controllers

   Additional options (load with guidance_load "1,3"):
   1. architecture/mvc-principles.md (~60 lines)
   2. rails/request-handling.md (~90 lines)
   3. security/controller-auth.md (~45 lines)
   ```

## Example Usage Patterns

```typescript
// Implementation-level guidance for coding
guidance_load("implementing Rails controllers", "implementation")
// → Loads: controller syntax, ActiveRecord patterns, params handling

// Design-level guidance for technical planning
guidance_load("designing authentication system", "design")
// → Loads: auth architecture patterns, session vs JWT tradeoffs, API contracts

// Strategic-level guidance for project planning
guidance_load("planning Q1 roadmap", "strategic")
// → Loads: feature prioritization, stakeholder management, risk assessment

// Same topic, different focus levels
guidance_load("user authentication", "strategic")
// → Loads: business requirements, compliance needs, user experience goals

guidance_load("user authentication", "design")
// → Loads: auth flow diagrams, token strategies, security boundaries

guidance_load("user authentication", "implementation")
// → Loads: bcrypt usage, session code, controller filters
```

## Implementation Steps

1. **Setup TypeScript MCP Server**
   - Clone mcp-ts-template
   - Install Bun runtime (v1.2.0+)
   - Configure package.json with project details
   - Set up TypeScript configuration

2. **Implement Tool Definition**
   ```typescript
   // src/mcp-server/tools/definitions/guidance-load.ts
   export const guidanceLoadTool: ToolDefinition = {
     name: 'guidance_load',
     description: 'Intelligently load task-specific guidance at the correct focus level',
     inputSchema: z.object({
       query: z.string().min(1).describe('Natural language description of what you need'),
       focusLevel: z.enum(['strategic', 'design', 'implementation'])
         .describe('Required focus level for guidance granularity'),
       project: z.string().optional().describe('Project name for project-specific guidance'),
       maxAutoLoad: z.number().default(2).describe('Maximum files to auto-load')
     }),
     logic: guidanceLoadLogic
   }
   ```

3. **Build Core Services**
   - `QueryParserService`: Extract task type, components, and technologies from natural language
   - `RipgrepService`: Fast file searching using ripgrep for content, focus levels, and tags
   - `MetadataExtractorService`: Efficient YAML frontmatter extraction (no caching)
   - `GuidanceLoaderService`: Load files, resolve @-references, handle deduplication

4. **Implement Search & Scoring Algorithm**
   ```typescript
   // src/services/guidance-search.service.ts
   interface SearchResult {
     path: string;
     score: number;
     scope: 'global' | 'project';
     category: string;
     tags: string[];
     lineCount: number;
     description: string;
   }
   ```

5. **Add Configuration & Deployment**
   - Configure .env for local development
   - Build with `bun run build`
   - Update MCP profiles to use TypeScript server
   - Test with Claude Code

## Key Improvements Over Current System

1. **Task-aware loading** - Different guidance for implementing vs planning vs reviewing
2. **Granular selection** - Load specific controller guidance, not entire Rails bundle
3. **Automatic discovery** - Claude Code can call this proactively
4. **Zero context waste** - No manual loading commands or file paths
5. **Project awareness** - Automatically checks for project-specific overrides

## Configuration

### Environment Variables (.env)
```bash
NODE_ENV=development
LOG_LEVEL=info
TRANSPORT_TYPE=stdio
AUTH_MODE=none
STORAGE_PROVIDER=memory
```

### MCP Profile Configuration
Add to `~/.claude/mcp-profiles/` configurations:
```json
{
  "guidance": {
    "type": "stdio",
    "command": "bun",
    "args": ["run", "~/.claude/mcp-servers/guidance/dist/index.js"],
    "env": {}
  }
}
```

### Package.json Scripts
```json
{
  "scripts": {
    "dev": "bun run --hot src/index.ts",
    "build": "bun build src/index.ts --outdir dist --target node",
    "start": "bun run dist/index.js",
    "test": "bun test"
  }
}
```

## Guidance File Frontmatter

Each guidance file declares its applicable focus levels:

```yaml
---
type: guidance
category: testing
focus_levels: [implementation]  # Only for coding
tags: [rspec, testing]
---
```

```yaml
---
type: guidance
category: architecture
focus_levels: [strategic, design]  # For planning and design, not coding
tags: [system-design, planning]
---
```

```yaml
---
type: guidance
category: rails
focus_levels: [design, implementation]  # Technical design and coding
tags: [rails, mvc]
---
```

## Performance Optimization Strategy

### Chosen Approach: Smart On-Demand Parsing (No Caching)

We avoid caching entirely to prevent cache invalidation complexity. Instead, we leverage ripgrep's speed and a two-phase search strategy:

**Phase 1: Filter with Ripgrep** (20-30ms)
- Use ripgrep to search YAML frontmatter patterns
- Reduces 100+ files to 10-20 relevant files
- No parsing needed at this stage

**Phase 2: Parse Only Filtered Files** (50ms)
- Extract YAML frontmatter from filtered files only
- Use parallel processing for extraction
- Always fresh data, no stale cache issues

**Why This Works:**
- Ripgrep is extremely fast (written in Rust, optimized for searching)
- We parse 10-20 files instead of 100+ (80-90% reduction)
- Total time < 200ms without any caching complexity

#### 1. Fast YAML Frontmatter Extraction
```typescript
// src/services/metadata-extractor.service.ts
class MetadataExtractorService {
  // Extract just frontmatter without reading entire file
  async extractFrontmatter(filePath: string): Promise<Metadata | null> {
    // Read only first 500 bytes (enough for frontmatter)
    const header = await fs.read(filePath, { length: 500 });

    // Quick regex check for frontmatter block
    const match = header.match(/^---\n([\s\S]*?)\n---/);
    if (!match) return null;

    // Parse YAML only if needed
    return yaml.parse(match[1]);
  }

  // Parallel extraction for multiple files
  async extractBatch(filePaths: string[]): Promise<Map<string, Metadata>> {
    // Use Promise.all for parallel processing
    // Could also use worker threads for very large sets
    const results = await Promise.all(
      filePaths.map(path => this.extractFrontmatter(path))
    );
    return new Map(filePaths.map((path, i) => [path, results[i]]));
  }
}
```

#### 2. Two-Phase Search Strategy
```typescript
// Phase 1: Use ripgrep to find ALL files with focus level in frontmatter
const findFilesByFocusLevel = async (level: FocusLevel) => {
  // Ripgrep is VERY fast at finding patterns, even in YAML
  const cmd = `rg -l "focus_levels:.*${level}" --type md`;
  return await exec(cmd);
};

// Phase 2: Parse only the filtered files for full metadata
const searchWithFocusLevel = async (query: string, focusLevel: FocusLevel) => {
  // First, quickly filter files by focus level using ripgrep
  const candidateFiles = await findFilesByFocusLevel(focusLevel);

  // Then extract metadata only from candidates (10-20 files instead of 100+)
  const metadata = await metadataExtractor.extractBatch(candidateFiles);

  // Finally, search content in filtered set
  const contentMatches = await ripgrepService.search(query, candidateFiles);

  return combineResults(metadata, contentMatches);
};
```

### 3. Ripgrep for Everything
```typescript
// Use ripgrep for ALL searches - it's incredibly fast
class RipgrepService {
  // Find files by focus level (searches YAML frontmatter)
  async findByFocusLevel(level: FocusLevel): Promise<string[]> {
    // This is fast even on 100+ files
    const cmd = `rg -l "focus_levels:.*\\b${level}\\b" --type md`;
    return await exec(cmd);
  }

  // Find files by tags
  async findByTags(tags: string[]): Promise<string[]> {
    const pattern = tags.map(t => `tags:.*\\b${t}\\b`).join('|');
    const cmd = `rg -l "${pattern}" --type md`;
    return await exec(cmd);
  }

  // Search content
  async searchContent(query: string, files?: string[]): Promise<SearchResult[]> {
    const fileArgs = files ? files.join(' ') : '--type md';
    const cmd = `rg --json "${query}" ${fileArgs}`;
    return this.parseJsonOutput(await exec(cmd));
  }
}
```

### 4. Performance Characteristics
- **Focus level filtering**: ~20-30ms for 100+ files using ripgrep
- **YAML parsing**: ~50ms for 20 filtered files (parallel)
- **Content search**: ~30-50ms using ripgrep
- **Total response time**: < 200ms even without caching

### 5. Why This Approach Works
- Ripgrep is optimized in Rust and extremely fast
- We filter BEFORE parsing YAML (typically 100 files → 10-20 files)
- Parallel processing for YAML extraction
- No cache invalidation complexity
- Always fresh data

## Example Implementation

### Tool Logic
```typescript
// src/mcp-server/tools/logic/guidance-load.logic.ts
export const guidanceLoadLogic = async (
  args: GuidanceLoadArgs,
  context: ToolContext
): Promise<GuidanceLoadResult> => {
  const { query, focusLevel, project, maxAutoLoad = 2 } = args;

  // Parse query for context signals
  const queryContext = await queryParser.parse(query);

  // Phase 1: Use ripgrep to quickly filter files by focus level (~20ms)
  const focusFilteredFiles = await ripgrepService.findByFocusLevel(focusLevel);

  // Phase 2: Run parallel searches on filtered set
  const [contentMatches, tagMatches] = await Promise.all([
    ripgrepService.searchContent(query, focusFilteredFiles),
    ripgrepService.findByTags(queryContext.tags)
  ]);

  // Phase 3: Extract metadata only for matching files (~50ms for 20 files)
  const matchingFiles = [...new Set([
    ...contentMatches.map(m => m.path),
    ...tagMatches
  ])].filter(f => focusFilteredFiles.includes(f));

  const metadata = await metadataExtractor.extractBatch(matchingFiles);

  // Phase 4: Score and rank results
  const scoredResults = matchingFiles.map(file => ({
    path: file,
    metadata: metadata.get(file),
    score: calculateScore({
      hasContentMatch: contentMatches.some(m => m.path === file),
      hasTagMatch: tagMatches.includes(file),
      metadata: metadata.get(file),
      queryContext,
      focusLevel
    })
  }));

  const rankedResults = scoredResults.sort((a, b) => b.score - a.score);

  // Phase 5: Auto-load top results
  const toAutoLoad = rankedResults.slice(0, maxAutoLoad);
  const additionalOptions = rankedResults.slice(maxAutoLoad, maxAutoLoad + 5);

  // Phase 6: Load files with @-reference resolution
  const loadedContent = await guidanceLoader.loadWithReferences(toAutoLoad);

  return {
    autoLoaded: toAutoLoad.map(r => ({
      path: r.path,
      lines: r.metadata?.lineCount || 0,
      description: r.metadata?.description || ''
    })),
    content: loadedContent,
    additionalOptions: additionalOptions.map((r, i) => ({
      number: i + 1,
      path: r.path,
      lines: r.metadata?.lineCount || 0
    })),
    performanceMetrics: {
      filesScanned: focusFilteredFiles.length,
      filesMatched: matchingFiles.length,
      searchTimeMs: context.elapsed()
    }
  };
};
```

## Design Decisions

1. **Focus Levels**: Using three levels (strategic/design/implementation) to ensure proper granularity
2. **No Caching**: Using ripgrep for all searches to avoid cache invalidation complexity
3. **Performance**: Two-phase search - filter with ripgrep first, then parse YAML only for matches
4. **Bundle Deprecation**: Individual guidance files with focus levels replace the need for bundles

## Open Questions

1. **Bundle Migration**: How to transition existing bundles to focus-level-based files?
2. **Learning**: Should it track which guidance gets loaded together to improve recommendations?
3. **Integration**: Should `/guidance add` command automatically set focus levels based on content?
4. **Project Detection**: Should the MCP auto-detect current project from working directory?

## Summary

This MCP server provides a single `guidance_load` tool that:
- **Filters by focus level** (strategic/design/implementation) to ensure proper granularity
- **Uses ripgrep for everything** - no caching needed, always fresh data
- **Performs well** - < 200ms response time for 100+ files
- **Auto-loads 2 best matches** and lists additional options
- **Resolves @-references** automatically

The key insight is using ripgrep's speed for initial filtering (by focus level) to reduce the set of files that need YAML parsing from 100+ down to 10-20, making on-demand parsing feasible without caching.

## Next Steps

1. **Setup Development Environment**
   - Install Bun runtime (v1.2.0+)
   - Clone mcp-ts-template to `~/.claude/mcp-servers/guidance/`
   - Install dependencies with `bun install`

2. **Implement Core Components**
   - Create `guidance-load` tool definition
   - Build query parser service for context extraction
   - Implement search service with scoring algorithm
   - Add loader service with @-reference resolution

3. **Testing & Refinement**
   - Test with various query patterns
   - Optimize scoring weights based on results
   - Add caching for frequently accessed guidance

4. **Integration**
   - Build and deploy server
   - Add to MCP profiles configuration
   - Test with Claude Code
   - Document usage patterns

5. **Future Enhancements**
   - Add guidance usage analytics
   - Implement learning from load patterns
   - Support for guidance snippets/sections
   - Integration with `/guidance add` command