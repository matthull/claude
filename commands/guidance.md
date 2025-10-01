# /guidance

## Purpose
Manage the modular guidance library for Claude Code using isolated Task tool execution.

## Usage
```
/guidance add global <content>   # Add to global guidance library
/guidance add project <content>  # Add to project-specific guidance
/guidance list [scope]           # List available guidance modules
/guidance search <query>         # Search and number guidance modules
/guidance tag <tag-name>         # List guidance modules by tag
/guidance load <query>           # Search and auto-load high-confidence matches
/guidance load <numbers>         # Load specific modules by number from search
```

## Implementation
This command follows the command-task-isolation pattern from `@~/.claude/guidance/ai-development/command-task-isolation.md`.

**Key Principles:**
- All subcommands now use direct tools for speed
- Add uses smart upsert logic (search → update or create)
- Search and load use parallel execution
- Minimal context usage - only load what's needed

## Subcommands

### add
Smart upsert operation - updates existing guidance or creates new module using direct tools.

**Parameters:**
- **Scope**: `global` (universal) or `project` (framework-specific)
- **Content**: The guidance to add/update

**Workflow:**
1. Search for related existing modules by keywords
2. If found: Update the most relevant module
3. If not found: Create new module with auto-detected category/name
4. Report what was done (created/updated/appended)
5. User can correct if needed

### list
Lists available guidance modules via direct tool use (lightweight operation).

**Parameters:**
- **Scope**: `global`, `project`, or both if omitted

### search
Fast search of guidance modules using direct tool calls (no Task delegation for performance).

**Parameters:**
- **Query**: Keywords to search for

**Returns:** Numbered list of matching modules that can be loaded with `/guidance load`

**Implementation:** Uses direct Grep tool (ripgrep) with parallel execution

### tag
Fast filtering of guidance modules by tags using the guidance-tag-search.sh script.

**Parameters:**
- **Tag name**: Tag to filter by (e.g., `backend`, `testing`, `frontend`, `integrations`)

**Returns:** Numbered list of matching modules that can be loaded with `/guidance load`

**Implementation:**
Run `~/.claude/commands/guidance-tag-search.sh <tag-name>` using Bash tool. The script searches both global and project guidance directories for files with the specified tag in their frontmatter.

**Common Tags:**
Bundle names like `software-dev`, `coding`, `backend`, `frontend`, `testing`, `rails`, `ai-development`, `devops`, or custom tags like `integrations`.

### load  
Smart loading of guidance modules - either by search query or by specific numbers.

**Two modes:**
1. **Query mode** (`/guidance load testing`): Fast search and auto-load high-confidence matches
2. **Number mode** (`/guidance load 1,3,5`): Loads specific modules from previous search results

**Parameters:**
- **Query**: Search terms to find and auto-load relevant modules
- **Numbers**: Comma-separated list of result numbers from previous search

**Implementation:** Query mode uses direct tools (no Task delegation) for speed

### bundle
Load pre-configured guidance bundles based on context descriptors, with project bundles overriding global ones. Supports loading multiple bundles at once.

**Parameters:**
- **Descriptors**: One or more natural language descriptors describing desired contexts (e.g., "ruby", "frontend", "therapy")
- **list**: Special parameter to show all available bundles

**Usage:**
```
/guidance bundle <descriptor>              # Load single bundle matching descriptor
/guidance bundle <descriptor1> <descriptor2> ...  # Load multiple bundles
/guidance bundle list                      # Show all available bundles
```

**Examples:**
- `/guidance bundle rails` → Loads technique/rails.md (project first, then global)
- `/guidance bundle frontend backend` → Loads both frontend and backend bundles with their parent bundles
- `/guidance bundle coding testing` → Loads domain/coding.md and practice/testing.md with their foundations
- `/guidance bundle therapy` → Loads foundation/therapeutic.md
- `/guidance bundle architecture devops database` → Loads all three bundles in parallel
- `/guidance bundle list` → Shows hierarchy of all bundles (both project and global)

**Implementation:**
The LLM interprets the natural language descriptors and selects the most appropriate bundles based on context. For multiple bundles, load them in parallel using multiple Read tool calls in a single message. If any descriptor is ambiguous, suggests running `/guidance bundle list` to see available options.

**Bundle Resolution Order:**
1. Check project bundles first: `.claude/guidance/bundles/{layer}/{name}.md`
2. Fall back to global bundles: `~/.claude/guidance/bundles/{layer}/{name}.md`
3. If project bundle exists, use it exclusively (it can @-reference the global version)

When loading bundles:
1. For each descriptor, search for bundle in project first, then global
2. Load all selected bundle files IN PARALLEL (multiple Read tools in one message)
3. Recursively load all parent bundles (via @-references) - deduplicate if shared parents
4. Load all directly included guidance modules
5. Report what was loaded and total estimated context usage

**Multiple Bundle Loading:**
- Parse all descriptors from the command
- Resolve each descriptor to its bundle file path
- Use parallel Read tool calls to load all bundles simultaneously
- Deduplicate any shared parent bundles to avoid loading the same content twice
- Report total bundles loaded and estimated context size

**Bundle List Format:**
```
Available Guidance Bundles:

PROJECT BUNDLES (.claude/guidance/bundles/):
Practice:
  architecture*      - Project-specific architecture [overrides global]

GLOBAL BUNDLES (~/.claude/guidance/bundles/):
Foundation (top-level contexts):
  software-dev        - All software development work
  personal-assistant  - General assistant tasks
  therapeutic        - Mental health support
  creative           - Writing and content creation

Domain (areas within foundations):
  coding             - Active code writing [inherits: software-dev]
  architecture       - System design [inherits: software-dev]
  devops            - Operations [inherits: software-dev]
  debugging         - Troubleshooting [inherits: software-dev]
  data-analysis     - Data science [inherits: software-dev]

Practice (specific methodologies):
  backend           - Server-side dev [inherits: coding]
  frontend          - Client-side dev [inherits: coding]
  testing           - Test strategies [inherits: coding]
  database          - Data persistence [inherits: coding]
  architecture      - System design patterns [inherits: coding]

Technique (specific tools/approaches):
  ruby-dev          - Ruby patterns [inherits: backend]
  rails             - Rails framework [inherits: ruby-dev]

* = Project bundle overrides global bundle with same name
```

## Subagent Prompt Templates

### Add Subcommand Implementation

## ⚠️ MANDATORY ULTRA-CONCISE ENFORCEMENT - CANNOT BE SKIPPED ⚠️

**ABSOLUTE REQUIREMENT**: Every single piece of guidance content MUST be processed through ultra-concise enforcement BEFORE ANY other action. Skipping this step = IMMEDIATE REJECTION of the entire operation.

### PHASE 0: MANDATORY PRE-PROCESSING [NON-NEGOTIABLE]

**YOU MUST:**
1. **IMMEDIATELY** load @~/.claude/guidance/ai-development/ultra-concise-enforcement.md
2. **APPLY ALL TRANSFORMATIONS** to the input content BEFORE proceeding
3. **SHOW BEFORE/AFTER** comparison with exact line counts and character reduction
4. **VALIDATE ALL 8 CHECKLIST ITEMS** - If ANY fail, STOP and fix them
5. **REJECT OPERATION ENTIRELY** if enforcement is skipped or incomplete

**ENFORCEMENT AUDIT TRAIL [REQUIRED OUTPUT]:**
```
=== ULTRA-CONCISE ENFORCEMENT APPLIED ===
Original: [X lines, Y characters]
Processed: [X lines, Y characters]
Reduction: [Z%]

DELETIONS APPLIED:
✅ Removed N "Benefits" sections
✅ Removed N explanatory sentences
✅ Removed N hedging words
✅ Removed N philosophical justifications

REWRITES APPLIED:
✅ Explanatory → Declarative: N transformations
✅ Verbose → Direct: N transformations
✅ Soft → Hard: N transformations
✅ Paragraphs → Lists: N transformations

VALIDATION CHECKLIST:
✅ No benefits sections
✅ No explanatory sentences
✅ No hedging language
✅ No philosophical justification
✅ No alternative approaches
✅ Direct commands only
✅ Declarative statements only
✅ Lists instead of paragraphs

ALL CHECKS PASSED: Proceeding with guidance operation
```

**FAILURE CONDITIONS (STOP IMMEDIATELY):**
- User content contains "Benefits" or "Why this matters" sections → REJECT
- Any sentence starting with "This helps..." → REJECT
- Hedging language detected (could/might/consider) → REJECT
- Validation checklist has any ❌ items → REJECT
- Enforcement step was skipped → REJECT ENTIRE OPERATION

### PHASE 1: Identify Target [ONLY AFTER ENFORCEMENT]

1. Extract keywords from PROCESSED content
2. Search for existing modules with those keywords (parallel Grep)
3. Check filenames for exact matches (e.g., "tdd" → tdd-*.md)

### PHASE 2: Decide Action

- **Update existing**: If high-confidence match found
- **Create new**: If no good match exists

### PHASE 3: Execute

- For updates: Read file, append/merge PROCESSED content, write back
- For new: Detect category, create file with PROCESSED content using template

### PHASE 4: Report

- Show enforcement metrics: "Reduced content by 65% (300→105 lines)"
- Show action taken: "Updated testing/tdd-principles.md (added 25 processed lines)"
- Include enforcement proof: "✅ All 8 ultra-concise validations passed"

**QUALITY STANDARDS (POST-ENFORCEMENT):**
- Global: Under 150 lines AFTER enforcement
- Project: Under 300 lines AFTER enforcement
- MUST pass all 8 validation checklist items

**ENFORCEMENT VERIFICATION:**
Before saving ANY guidance file, you MUST:
1. Re-check all 8 validation items
2. Confirm >40% reduction from original
3. Show final validation status

**Category Detection:**
- Extract main topic from PROCESSED content
- Common categories: testing, architecture, workflow, frontend, backend
- If unclear, ask user for category

**File Naming:**
- Based on core concept (e.g., "TDD practices" → tdd-principles.md)
- Use kebab-case
- Descriptive but concise

### Search Subcommand Implementation

For the 'search' subcommand, use direct Grep tool for performance:
1. Run TWO Grep tool calls IN PARALLEL (single message, multiple tool blocks)
2. One for ~/.claude/guidance/, one for .claude/guidance/  
3. Use output_mode: "files_with_matches" for fast results
4. Format results as numbered list with brief descriptions
5. Store mapping in YAML block for load command

**CRITICAL**: Must use parallel tool calls for performance - invoke both Grep tools in the same message!

### Load Subcommand Implementation

For the 'load' subcommand, determine mode and act accordingly:

**Number Mode** (e.g., "1,3,5"):
- Use direct Read tool calls to load specified modules from stored search results
- Reference the YAML mapping from previous search

**Query Mode** (e.g., "testing"):  
- Use direct tools for performance (no Task delegation)
- Run parallel Grep searches on both directories
- Identify high-confidence matches (exact category/name matches)
- Load high-confidence files with Read tool (parallel calls)
- List remaining matches with numbers

High-Confidence Criteria:
- Exact category match (e.g., "testing" → testing/*.md)
- Exact filename match (e.g., "tdd" → tdd-*.md)
- Project-specific versions of requested topics

**CRITICAL**: Use parallel tool calls - multiple Grep/Read tools in same message!

### List Subcommand Implementation

For the 'list' subcommand, use direct Bash tool (lightweight operation):
- Global: `find ~/.claude/guidance -name "*.md" -type f | sort`
- Project: `find .claude/guidance -name "*.md" -type f 2>/dev/null | sort`
- Format output showing categories and module names

## Example Usage

```
# Add to global guidance (smart upsert)
/guidance add global "Always use database transactions for multi-step operations, implement rollback strategies, avoid long-running transactions"
# → Searches for existing transaction/database guidance
# → Creates new: database/transaction-patterns.md (no match found)
# → Reports: "Created database/transaction-patterns.md (45 lines)"

# Update existing guidance
/guidance add global "TDD should include integration tests after unit tests"
# → Finds: testing/tdd-principles.md
# → Updates existing file with new content
# → Reports: "Updated testing/tdd-principles.md (added 15 lines)"

# Add to project guidance (Rails-specific)
/guidance add project "Service objects should go in app/services/, inherit from ApplicationService"
# → Searches project guidance for service patterns
# → Creates: rails/service-objects.md
# → Reports: "Created rails/service-objects.md (62 lines)"

# List all guidance modules
/guidance list
# → Shows both global and project modules organized by category

# List only global modules
/guidance list global
# → Shows modules in ~/.claude/guidance/

# Search for testing-related guidance (list only)
/guidance search "testing"
# → Shows numbered list of modules containing "testing"
# Example output:
#   1. testing/tdd-principles.md (global)
#   2. testing/testing-strategy.md (global)
#   3. rails/fixture-based-testing.md (project)

# Filter guidance by tag
/guidance tag backend
# → Shows numbered list of modules tagged with "backend"
# Example output:
#   1. security/validation-and-authorization.md (global)

/guidance tag testing
# → Shows all testing-related guidance
# Example output:
#   1. testing/test-driven-development.md (global)

/guidance tag software-dev
# → Shows foundational software development guidance
# Example output:
#   1. communication/balanced-analysis.md (global)
#   2. security/code-security-boundaries.md (global)
#   3. development-process/no-interface-guessing.md (global)

# Load testing guidance (auto-loads high-confidence matches)
/guidance load testing
# → Auto-loads modules 1-3 (high confidence)
# → Lists modules 4-8 as additional options

# Load specific modules from search results
/guidance load 1,3
# → Loads modules 1 and 3 from previous search

# Quick load common topics
/guidance load tdd
# → Auto-loads TDD-related guidance

# Complex guidance where agent asks for clarification
/guidance add global "Cache invalidation strategies and patterns"
# → Agent asks: "What category? (architecture, performance, etc.)"
```

## Reference Syntax
- Global guidance: `@~/.claude/guidance/category/module.md`
- Project guidance: `@.claude/guidance/category/module.md`

## Benefits
- Consolidates guidance management under one command
- More intuitive command structure with clear subcommands
- Supports future expansion with additional subcommands
- Maintains backward compatibility through clear migration path