---
type: guidance
status: current
category: documentation
---
# Document Decomposition

## Core Concepts

### Size Limits
- **Master documents** - < 100 lines (overview and navigation)
- **Detail documents** - < 200 lines (complete specifications)
- **Reference documents** - Size varies (lookup tables, catalogs)
- **Total context budget** - ~2000 lines for a work session

### Hierarchy Pattern
- **Master** - Overview, key decisions, links to details
- **Detail** - Complete specification of single topic
- **Reference** - Lookup information not meant for full reading
- **No indexes** - Directory structure is self-documenting

### Single Responsibility
- One document = one topic
- Complete coverage within scope
- Clear boundaries between documents
- Minimal cross-references

## When to Apply
- Document exceeds 200 lines
- Multiple topics in single file
- Frequent partial updates needed
- Different audiences for different sections
- Context loading becomes inefficient

## Implementation Patterns

### Document Splitting
1. Identify logical boundaries
2. Extract cohesive sections
3. Create master for navigation
4. Link details from master
5. Move reference data to catalogs

### Naming Convention
- Descriptive, not generic
- Include document type in name
- Use consistent patterns
- Reflect hierarchy in naming

## Anti-patterns
- Kitchen sink documents (600+ lines)
- Mixing overview with implementation
- Duplicating content across documents
- Deep nesting (> 3 levels)
- Manual index maintenance
- Orphan documents without clear home

