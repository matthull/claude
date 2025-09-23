# Guidance Library - Remaining Work from Audit

## Files We Actually Fixed (✅ DONE)
1. README.md - Reduced 244→54 lines
2. therapy files - Reduced 775→151 lines
3. Deleted test-verbose.md
4. Merged 4 documentation files → project-workflow.md
5. Merged 2 testing files → test-driven-development.md
6. ai-development/prompt-structure.md - Removed overview
7. ai-development/claude-prompting.md - Removed overview

## Files Still Needing Major Fixes (Score 1-5/10)

### Severe Violations - ai-development category:
- **context-optimization.md** - Has Overview section
- **instruction-clarity.md** - Likely has Overview
- **output-control.md** - Likely verbose
- **reasoning-patterns.md** - Likely explanatory
- **structured-formatting.md** - Likely has Overview
- **command-task-isolation.md** - Likely verbose

### Severe Violations - documentation category:
- **development-workflow.md** - Verbose
- **document-decomposition.md** - Explanatory
- **handoff.md** - Likely has template explanations
- **implementation-plan.md** - Verbose structure
- **parking-lot.md** & **parking-lot-pattern.md** - Redundant pair
- **requirements.md** - Likely verbose
- **scope-management.md** - Explanatory
- **session-logging.md** - Template heavy
- **task-handoffs.md** - Redundant with handoff.md
- **yaml-frontmatter.md** - Likely explanatory

### Severe Violations - development-process category:
- **brownfield-development.md** - Likely verbose
- **incremental-implementation.md** - Has Overview, benefits
- **spec-kit-workflow.md** - Likely verbose
- **task-list-management.md** - Explanatory

### Severe Violations - code-quality category:
- **code-review-principles.md** - Has "Human Focus" philosophy
- **error-handling.md** - Likely verbose
- **general-code-writing.md** - Likely has explanations
- **immediately-runnable-code.md** - Likely verbose

### Severe Violations - other categories:
- **architecture/cross-layer-impact.md** - Has "Core Principle" and "Rationale" sections
- **architecture/api-integration.md** - Likely verbose
- **frontend/css-architecture.md** - Likely explanatory
- **security files** - Likely verbose
- **planning/anti-patterns.md** - Likely explanatory

## Files Needing Mergers:
1. **code-search/principles.md** + **techniques.md** → Single file
2. **parking-lot.md** + **parking-lot-pattern.md** → Single file
3. **handoff.md** + **task-handoffs.md** → Single file
4. **communication/balanced-analysis.md** + **developer-tone.md** → Might merge

## Common Patterns to Fix:

### Delete on sight:
- "Overview" sections (90% of files have this)
- "Benefits" sections
- "Rationale" sections
- "Core Principle" sections
- Philosophical justifications
- Historical context

### Rewrite patterns:
- Paragraphs → Bullet lists
- Explanations → Commands
- "You should consider..." → "Do:"
- "This helps..." → DELETE
- "It's important to..." → DELETE

## Estimated Work:
- ~30-40 files need rewriting
- Most just need Overview deletion + tightening
- Would reduce total library by ~30-40%
- Bundles are already compliant (just @-references)