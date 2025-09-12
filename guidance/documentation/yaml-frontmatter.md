---
type: guidance
status: current
category: documentation
---
# YAML Frontmatter for Documentation

## Overview
Structured metadata in YAML format at document start for instant AI comprehension and document classification.

## Core Concepts

### Required Fields
```yaml
---
type: [document-type]
status: [current|complete|archived|blocked]
---
```

### Common Optional Fields
- `version` - For frequently updated docs
- `dependencies` - Related document list
- `created` - Creation date (YYYY-MM-DD)
- `tags` - Categorization keywords
- `context_hints` - AI-specific guidance

### Document Types
- `master` - Overview documents
- `detail` - Specifications
- `reference` - Lookup/catalog
- `task` - Task tracking
- `handoff` - Context preservation
- `session-log` - Work session notes
- `approach` - Methodology docs
- `evaluation` - Assessment results

## When to Apply
- All permanent documentation
- Any structured document
- Documents referenced by AI
- Files needing status tracking
- Documents with dependencies

## Implementation Patterns

### Basic Frontmatter
```yaml
---
type: implementation-plan
status: current
---
```

### Full Frontmatter
```yaml
---
type: requirements
status: current
version: 2.1
dependencies: [project-plan.md, architecture.md]
created: 2025-01-11
tags: [api, authentication]
context_hints:
  purpose: "Define auth system requirements"
  key_concept: "OAuth2 implementation"
---
```

## Anti-patterns
- Missing required fields
- Inconsistent status values
- Stale metadata not updated
- Over-complex hierarchies
- Redundant information
- Using for temporary files

## Benefits
- Instant document classification (40% faster comprehension)
- Clear dependency tracking
- Status visibility without reading
- Enables automation
- Better context management