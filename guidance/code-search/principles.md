---
type: guidance
status: current
category: code-search
---

# Code Search Principles

## Core Principles

### 1. Exhaust Cheap Methods First
- **Start with fastest tools**: glob, grep, ripgrep
- **Progress to expensive methods**: Only use full file reads or AI agents when necessary
- **Token economy**: A glob pattern costs <100 tokens vs 5000+ for file reads

### 2. Pattern Specificity Hierarchy
```
Most Specific → Least Specific
1. Exact function/class names: "class UserController"
2. Unique patterns: "def authenticate_user"
3. File patterns: "**/*controller*.rb"
4. Content patterns: "authentication.*user"
5. Broad searches: "user" (avoid)
```

### 3. Search Space Reduction
- **Directory targeting**: Start searches from most likely locations
- **File type filtering**: Use extensions to eliminate noise
- **Incremental refinement**: Narrow search based on initial results
- **Exclusion patterns**: Actively exclude known non-matches

### 4. Parallel Search Strategy
When searching for multiple related items:
```
BAD:  Search A → wait → Search B → wait → Search C
GOOD: Launch A, B, C simultaneously → process results together
```

### 5. Context Preservation
- **Never load entire files** when searching for specific items
- **Extract relevant portions** using grep with context (-A/-B/-C)
- **Maintain search history** to avoid redundant searches
- **Cache search patterns** that yield good results

## Search Intent Classification

### Definition Searches
- Finding where something is defined (classes, functions, constants)
- Use: Exact pattern matching, declaration syntax
- Tools: grep with language-specific patterns

### Usage Searches
- Finding where something is called or referenced
- Use: Symbol name with flexible surrounding context
- Tools: ripgrep with word boundaries

### Concept Searches
- Finding implementations of patterns or concepts
- Use: Multiple related terms, semantic patterns
- Tools: Combination of grep patterns or specialized agent

### Structure Searches
- Finding files matching naming conventions
- Use: Glob patterns with path specifications
- Tools: glob, find, fd

## Token Optimization Rules

### Always Calculate Token Cost
```
Glob search: ~50 tokens
Grep search: ~200 tokens
Single file read: 500-5000 tokens
Directory read: 10000+ tokens
AI agent search: 2000-8000 tokens
```

### When to Use Each Tool
- **Glob**: File names, paths, extensions (first choice)
- **Grep**: Known patterns in content (second choice)
- **Read**: Only when exact location is known
- **Agent**: Complex semantic searches, multi-file understanding

## Search Failure Recovery

### Progressive Expansion
1. Start with most specific pattern
2. If no results, broaden pattern slightly
3. If still no results, check different locations
4. Consider alternative naming conventions
5. Finally, use semantic search with agent

### Common Failure Patterns
- **Over-specific patterns**: Remove unnecessary constraints
- **Wrong directory**: Search from project root
- **Name variations**: Try camelCase, snake_case, kebab-case
- **Aliasing**: Search for both original and aliased names

## Performance Benchmarks

### Target Metrics
- Simple searches: <500ms, <200 tokens
- Complex searches: <2s, <1000 tokens
- Multi-file searches: <5s, <2000 tokens
- Full codebase scan: Avoid (use agent instead)

### Anti-patterns to Avoid
- Reading files to search them (use grep)
- Recursive file reads (use glob + grep)
- Searching without file type filters
- Not using parallel searches for related items
- Ignoring incremental refinement opportunities