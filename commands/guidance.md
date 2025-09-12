# /guidance

## Purpose
Manage the modular guidance library for Claude Code using isolated Task tool execution.

## Usage
```
/guidance add global <content>   # Add to global guidance library
/guidance add project <content>  # Add to project-specific guidance
/guidance list [scope]           # List available guidance modules
/guidance search <query>         # Search and number guidance modules
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
Load pre-configured guidance bundles based on context descriptor.

**Parameters:**
- **Descriptor**: Natural language describing desired context (e.g., "ruby", "frontend", "therapy")
- **list**: Special parameter to show all available bundles

**Usage:**
```
/guidance bundle <descriptor>    # Load bundle matching descriptor
/guidance bundle list            # Show all available bundles
```

**Examples:**
- `/guidance bundle rails` → Loads technique/rails.md and all parent bundles
- `/guidance bundle coding` → Loads domain/coding.md and foundation/software-dev.md
- `/guidance bundle therapy` → Loads foundation/therapeutic.md
- `/guidance bundle frontend react` → Loads appropriate frontend/React bundles
- `/guidance bundle list` → Shows hierarchy of all bundles

**Implementation:**
The LLM interprets the natural language descriptor and selects the most appropriate bundle based on context. If the descriptor is ambiguous, suggests running `/guidance bundle list` to see available options.

When loading a bundle:
1. Load the selected bundle file
2. Recursively load all parent bundles (via @-references)
3. Load all directly included guidance modules
4. Report what was loaded and total estimated context usage

**Bundle List Format:**
```
Available Guidance Bundles:

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

Technique (specific tools/approaches):
  ruby-dev          - Ruby patterns [inherits: backend]
  rails             - Rails framework [inherits: ruby-dev]
```

## Subagent Prompt Templates

### Add Subcommand Implementation

For the 'add' subcommand, use direct tools for smart upsert:

**Step 1: Identify Target**
1. Extract keywords from the content
2. Search for existing modules with those keywords (parallel Grep)
3. Check filenames for exact matches (e.g., "tdd" → tdd-*.md)

**Step 2: Decide Action**
- **Update existing**: If high-confidence match found
- **Create new**: If no good match exists

**Step 3: Execute**
- For updates: Read file, append/merge content, write back
- For new: Detect category, create file with proper template

**Step 4: Report**
- Show what was done: "Updated testing/tdd-principles.md (added 25 lines)"
- Allow user to correct: "Actually, create a new file instead"

**Quality Standards:**
- Global: Under 150 lines, no code, framework-agnostic
- Project: Under 300 lines, can include code/framework specifics

**Category Detection:**
- Extract main topic from content
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