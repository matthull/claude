---
description: Create a task handoff using the template system
---

## Usage
```
/handoff <task-reference-or-description>
```

**Examples:**
- `/handoff @specs/project-docs/seismic-bulk-sync/TASKS.md task 1.1` - Single task from TASKS.md
- `/handoff @specs/project-docs/seismic-bulk-sync/TASKS.md task 1.1 1.2 1.3` - Multiple tasks in parallel
- `/handoff implement Seismic property assignment with Rails service` - Freeform description
- `/handoff @specs/003-feature/tasks.md T001-T003` - Task range

## Implementation Strategy

**CRITICAL: This command uses parallel subagents for efficiency**

When multiple tasks are requested (e.g., `task 1.1 1.2 1.3`), spawn **parallel Task tool subagents** - one per task. Each subagent independently:
1. Reads prerequisite documents
2. Extracts task requirements
3. Composes handoff using template system
4. Saves handoff document

**DO NOT** process tasks sequentially in the main conversation. **ALWAYS** use parallel subagents for scalability.

### Step 1: Parse Arguments & Detect Mode

**Parse `$ARGUMENTS`** to determine handoff mode:

**Mode A: Task File Reference** (Preferred)
- Pattern: `@<file-path> task <task-numbers>`
- Example: `@specs/project-docs/seismic-bulk-sync/TASKS.md task 1.1 1.2 1.3`
- Action: Extract file path and task numbers → spawn subagents

**Mode B: Freeform Description** (Legacy)
- Pattern: Any text without `@` or `task` keyword
- Example: `implement Seismic property sync`
- Action: Process directly in main conversation (legacy behavior)

**Mode C: Task Range** (Alternative)
- Pattern: `@<file-path> T001-T003` or similar
- Example: `@specs/003-feature/tasks.md T001-T003`
- Action: Parse range, extract tasks → spawn subagents

### Step 2: Spawn Parallel Subagents (Mode A & C)

**For each identified task number**, spawn a **Task tool subagent** with `subagent_type: general-purpose`.

**Critical: Use parallel tool calls** - invoke ALL Task tools in a **single message** with multiple tool use blocks.

**Example (3 tasks requested)**:
```
User: /handoff @specs/project-docs/seismic-bulk-sync/TASKS.md task 1.1 1.2 1.3

Claude sends ONE message with THREE Task tool calls:
  - Task(subagent_type: general-purpose, description: "Create handoff for task 1.1", prompt: ...)
  - Task(subagent_type: general-purpose, description: "Create handoff for task 1.2", prompt: ...)
  - Task(subagent_type: general-purpose, description: "Create handoff for task 1.3", prompt: ...)
```

**Subagent Prompt Template**:
```
Create a task handoff document for Task {TASK_NUMBER} from {TASKS_FILE_PATH}.

TASK FILE: {TASKS_FILE_PATH}
TASK NUMBER: {TASK_NUMBER}

INSTRUCTIONS:
1. Read the tasks file at {TASKS_FILE_PATH}
2. Extract requirements for Task {TASK_NUMBER}
3. Follow the handoff creation process defined in Steps 3-7 below
4. Save the handoff to the appropriate location
5. Report what was created

Follow the handoff template composition process:
{INCLUDE_STEPS_3_TO_7_HERE}
```

### Step 3: Freeform Description Mode (Mode B)

**If no task file reference detected**, process in main conversation using legacy behavior (Steps 3-7 below).

---

## Handoff Creation Process (Executed by Subagents or Main Conversation)

**NOTE**: The following steps (0-7) are executed by:
- **Subagents** when using Mode A/C (task file references)
- **Main conversation** when using Mode B (freeform descriptions)

### 0. Core Mandates (Already Embedded in Template)

**NOTE:** Core mandates are now embedded directly in `~/.claude/templates/task/core-task-template.md`.

No action needed - the template includes all core constraints (Testing Discipline, Verification Principle, Stop and Ask protocol, etc.). A comment at the top of the embedded mandates references the source file (`~/.claude/prompts/core-mandates.md`) for sync purposes.

---

### 0b. CRITICAL: Read Prerequisite Documents First (ABSOLUTE)

**You MUST ALWAYS read ALL prerequisite documents BEFORE creating any handoff.**

**RATIONALE:** Handoffs without context = wrong assumptions = wasted implementation.

**You MUST IMMEDIATELY:**
1. Check if task references a file path (e.g., `@specs/003-seismic-automated-sync/tasks.md T001-T003`)
2. Read that file to extract task details
3. Check file header for "Prerequisites" or "Input" section
4. Read ALL listed prerequisite documents (plan.md, data-model.md, research.md, contracts/, etc.)
5. ONLY THEN proceed with handoff creation

**Common prerequisite patterns:**
```bash
# In tasks.md:
**Prerequisites**: plan.md, research.md, data-model.md, contracts/, quickstart.md

# In specs/ directory:
specs/XXX-feature-name/
├── plan.md           # ← READ THIS FIRST
├── research.md       # ← READ THIS SECOND
├── data-model.md     # ← READ THIS THIRD
├── contracts/        # ← READ RELEVANT CONTRACT
├── quickstart.md     # ← READ FOR TEST SCENARIOS
└── tasks.md          # ← THEN parse task details
```

**You MUST NEVER:**
- ❌ Create handoff without reading prerequisites
- ❌ Guess at architecture or design decisions
- ❌ Skip design docs "to save time"
- ❌ Assume you know the approach

**You MUST ALWAYS:**
- ✅ Read ALL prerequisite documents in order
- ✅ Verify understanding of design decisions
- ✅ Extract key architecture patterns from design docs
- ✅ Reference specific line numbers from design docs in handoff

**IF prerequisites are missing:**
1. **IMMEDIATELY STOP** handoff creation
2. Report: "Cannot create handoff - missing prerequisite: [file]"
3. Ask: "Should I proceed without [file] or wait for it?"
4. AWAIT user decision

---

### 0c. Code Discovery for Reuse

**After reading prerequisites**, invoke Explore agent to find existing implementations that can be reused.

**Purpose**: Discover existing code to prevent duplicate work and encourage reuse of proven patterns.

**Invoke**: Task tool with `subagent_type='Explore'`, thoroughness `'very thorough'`

**Search for**:
1. **Services/classes** doing similar things (e.g., other metrics services, sync workers)
2. **Utilities/helpers** providing needed functionality (date ranges, calculators, validators)
3. **Similar features** (similar components, services, controllers, models with similar behavior)
4. **Test patterns** (existing specs, VCR cassettes, test utilities)

**Agent prompt template**:
```
Find existing code in the codebase that could be reused for: {TASK_DESCRIPTION}

Detected stack: {DETECTED_STACK}
Task type: {TASK_TYPE}

Search for:
- Existing services or classes implementing similar functionality
- Utility methods, helpers, or mixins that provide needed capabilities
- Similar features (components, services, controllers, models with similar behavior)
- Relevant test patterns, fixtures, or VCR cassettes

Return file paths with line numbers and brief descriptions of what's reusable.
Format: `file_path:line_range  # what it does / why it's relevant`
```

**Store results** in `{REUSABLE_CODE_FINDINGS}` variable for template substitution.

**Output format** (bash commands with inline comments):
```bash
# Similar service pattern
cat app/services/asset_engagement_metrics_service.rb:15-45  # handle_social_post_metrics method

# Reusable helper methods
cat app/services/concerns/metrics_calculator.rb:23-30  # calculate_engagement_rate
cat lib/date_range_builder.rb:10-18  # build_date_range helper

# Related test patterns
cat spec/services/asset_engagement_metrics_service_spec.rb:50-75  # VCR setup for metrics
```

**Fallback**: If agent fails or times out, set `{REUSABLE_CODE_FINDINGS}=""` and continue.

**Important**: This discovers *reusable code specific to the task*. Handpicked canonical examples in section templates remain the trusted patterns for architecture.

---

### 1. Parse Task Description & Detect Project Stack

**Input**: `$ARGUMENTS` contains task description or file reference

**Project Technology Detection** (Priority Order):
1. **Check for project indicators** (Gemfile, package.json, etc.)
2. **Apply project-specific mappings**:
   - `backend` → Rails (Ruby) if Gemfile exists
   - `frontend` → Vue if package.json with vue dependency exists
3. **Fall back to keyword detection** if project context unclear

**Project-Specific Mappings** (Musashi/Village):
- **Backend** = Rails (Ruby) + RSpec
- **Frontend** = Vue + Vitest + Storybook

**Detection Keywords** (fallback when project unclear):

**Technology**:
- Ruby/Rails: `service`, `model`, `controller`, `Rails`, `Ruby`, `RSpec`, `ActiveRecord`, `backend`
- Vue/Frontend: `Vue`, `component`, `Storybook`, `Vitest`, `UI`, `frontend`
- Bash/Docker: `bash`, `shell`, `script`, `.sh`, `bats`, `docker`, `container`, `verify-specs`
- Config Files: `.yml`, `.yaml`, `.json`, `.toml`, `gitignore`, `Dockerfile`, `.env`, `config file`, `CI config`, `docker-compose`, `workflow`
- API/Integration: `API`, `integration`, `client`, `HTTP`, `endpoint`

**Task Type**:
- CRUD: `create`, `REST`, `endpoint`, `CRUD`, `index`, `show`, `update`, `destroy`
- Integration: `integrate`, `3rd party`, `external`, `sync`, `API client`
- Bug Fix: `fix`, `bug`, `issue`, `error`, `broken`
- Service: `service`, `business logic`, `extract`
- Worker/Job: `worker`, `job`, `async`, `background`, `Sidekiq`
- Database: `migration`, `table`, `index`, `schema`, `database`

### 2. Select Templates

**Always include**:
```bash
core_template=~/.claude/templates/task/core-task-template.md
```

**Technology sections** (add to Hook 1):
- If Ruby/Rails: `sections/ruby-rails-code.md`
- If Vue: `sections/vue-component.md`

**Domain sections** (add to Hook 2):
- If API/integration: `sections/api-integration.md`
- If testing needed (default): `sections/testing.md`
- If UI/manual QA: `sections/manual-qa.md`

**Selection Logic**:
```bash
# Start with core
templates=("$core_template")

# Detect project stack first
project_has_rails=false
project_has_vue=false

if [ -f "Gemfile" ]; then
  project_has_rails=true
fi

if [ -f "package.json" ] && grep -q '"vue"' package.json; then
  project_has_vue=true
fi

# Add technology section based on project + keywords
if [[ "$description" =~ (backend|service|model|controller|Rails|Ruby|RSpec) ]] && [ "$project_has_rails" = true ]; then
  templates+=("~/.claude/templates/task/sections/ruby-rails-code.md")
elif [[ "$description" =~ (service|model|controller|Rails|Ruby|RSpec) ]]; then
  templates+=("~/.claude/templates/task/sections/ruby-rails-code.md")
fi

if [[ "$description" =~ (frontend|Vue|component|Storybook|UI) ]] && [ "$project_has_vue" = true ]; then
  templates+=("~/.claude/templates/task/sections/vue-component.md")
elif [[ "$description" =~ (Vue|component|Storybook|frontend|UI) ]]; then
  templates+=("~/.claude/templates/task/sections/vue-component.md")
fi

if [[ "$description" =~ (bash|shell|\.sh|bats|script.*test|docker.*script|verify-specs|container) ]]; then
  templates+=("~/.claude/templates/task/sections/bash-docker-scripts.md")
fi

# Add config file section
if [[ "$description" =~ (\.yml|\.yaml|\.json|\.toml|gitignore|Dockerfile|\.env|config.*file|CI.*config|environment.*file|docker-compose|workflow) ]]; then
  templates+=("~/.claude/templates/task/sections/config-files.md")
fi

# Add domain sections
if [[ "$description" =~ (API|integration|client|HTTP|external) ]]; then
  templates+=("~/.claude/templates/task/sections/api-integration.md")
fi

# Always include testing (unless explicitly simple)
templates+=("~/.claude/templates/task/sections/testing.md")

# Add manual QA if UI or integration
if [[ "$description" =~ (UI|component|integration|manual) ]]; then
  templates+=("~/.claude/templates/task/sections/manual-qa.md")
fi
```

### 3. Extract Canonical Examples from Templates

**Source**: Canonical examples are defined in section templates (e.g., `ruby-rails-code.md`)

**Extraction Process**:
```bash
# Read the selected section templates
# Extract canonical example mappings from "Canonical Examples" sections
# Parse the pattern-to-file mappings

# Example from ruby-rails-code.md:
# "CRUD Controllers" - Read: `app/api/v2/video_link_assets_controller.rb`
# "Integration Controllers" - Read: `app/api/v2/seismic/teamsites_controller.rb`
# etc.
```

**Selection Logic** (based on task type keywords):
```
If task mentions (CRUD|REST|endpoint|index|show) → CRUD Controller example
If task mentions (integration.*controller|3rd party API) → Integration Controller example
If task mentions (API client|HTTP client|external service) → API Client example
If task mentions (service|business logic) → Service example
If task mentions (worker|job|background|async) → Worker example
If task mentions (model.*asset|asset model) → Asset Model example
If task mentions (model) → General Model example
```

**Implementation**:
1. Read selected section templates
2. Parse "Canonical Examples" sections
3. Match task keywords to example categories
4. Build list of relevant example files
5. Add to `{CANONICAL_EXAMPLE_COMMANDS}` variable

### 4. Compose Template

**Process**:

1. **Read core template**
2. **Insert section templates at SECTION HOOKs**:
   - Find `<!-- SECTION HOOK: Technology-specific patterns -->`
   - Insert technology sections (ruby-rails-code.md, vue-component.md)
   - Find `<!-- SECTION HOOK: Domain-specific guidance -->`
   - Insert domain sections (api-integration.md, testing.md, manual-qa.md)
3. **Extract canonical examples from selected templates**:
   - Parse "Canonical Examples" sections from included templates
   - Match task keywords to example categories
   - Generate `cat` commands for relevant examples
4. **Fill deterministic variables**:
   - `{DATE}` → `date +%Y-%m-%d`
   - `{TASK_ID}` → Generate from project context or prompt user
   - `{CANONICAL_EXAMPLE_COMMANDS}` → `cat <extracted-canonical-files>`
   - `{REUSABLE_CODE_FINDINGS}` → Bash commands from Step 0b code discovery
   - `{PROJECT_NAME}` → Detect from save location (e.g., "001-seismic-integration" from `specs/001-seismic-integration/`)
5. **Leave other variables as placeholders** for manual filling

**Project Name Detection**:
```bash
# If saving to specs/001-seismic-integration/task-handoffs/
# Extract: PROJECT_NAME=001-seismic-integration
if [[ "$save_path" =~ specs/([^/]+)/task-handoffs ]]; then
  project_name="${BASH_REMATCH[1]}"
  # Replace {PROJECT_NAME} with actual project
  content="${content//\{PROJECT_NAME\}/$project_name}"
fi
```

**Frontmatter**:
```yaml
---
type: task-handoff
task_id: {TASK_ID}
date: {DATE}
generated_from_templates:
  - core-task-template
  - sections/ruby-rails-code  # (if included)
  - sections/api-integration  # (if included)
  # ... etc
source_guidance:
  global:
    - testing/test-driven-development
    - development-process/tdd-human-review-cycle
    # ... (aggregate from all template frontmatter)
---
```

### 5. Determine Save Location

**Options**:

1. **If in project with specs/** structure:
   ```bash
   # Detect project
   if [ -d "specs" ]; then
     # List projects
     projects=$(ls -1 specs/)
     # Prompt or use current context
     save_to="specs/{project}/task-handoffs/{TASK_ID}-{slug}.md"
   fi
   ```

2. **If in project root** (no specs/):
   ```bash
   # Create specs/tasks/ if needed
   mkdir -p specs/tasks
   save_to="specs/tasks/{TASK_ID}-{slug}.md"
   ```

3. **Fallback**:
   ```bash
   save_to="./{TASK_ID}-{slug}.md"
   ```

**Slug generation**: Convert description to filename-safe slug:
```bash
# "implement Seismic property assignment" → "implement-seismic-property-assignment"
slug=$(echo "$description" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-' | tr -cd 'a-z0-9-')
```

### 6. Execute Composition

**Steps**:

1. Read core template
2. For each SECTION HOOK:
   - Read applicable section templates
   - Insert at hook location (replace comment with section content)
3. Fill deterministic variables
4. Add frontmatter with template tracking
5. Save to determined location
6. Report to user

**Example Implementation**:
```bash
# Read core
content=$(cat ~/.claude/templates/task/core-task-template.md)

# Replace SECTION HOOK 1 (Technology-specific)
if [[ -n "$tech_sections" ]]; then
  tech_content=$(cat $tech_sections)
  content=$(echo "$content" | sed "/<!-- SECTION HOOK: Technology-specific patterns/r /dev/stdin" <<< "$tech_content")
fi

# Replace SECTION HOOK 2 (Domain-specific)
if [[ -n "$domain_sections" ]]; then
  domain_content=$(cat $domain_sections)
  content=$(echo "$content" | sed "/<!-- SECTION HOOK: Domain-specific guidance/r /dev/stdin" <<< "$domain_content")
fi

# Fill variables
content="${content//\{DATE\}/$(date +%Y-%m-%d)}"
content="${content//\{TASK_ID\}/$task_id}"
content="${content//\{REUSABLE_CODE_FINDINGS\}/$reusable_code_findings}"

# Save
echo "$content" > "$save_path"
```

### 7. Report to User

```
✅ Created task handoff: {save_path}

Prerequisites read:
  - specs/XXX/plan.md (architecture decisions)
  - specs/XXX/data-model.md (entity design)
  - specs/XXX/research.md (implementation approach)
  - specs/XXX/contracts/YYY.yaml (API contract)

Templates used:
  - core-task-template.md
  - sections/ruby-rails-code.md
  - sections/api-integration.md
  - sections/testing.md

Variables filled:
  - DATE: 2025-11-05
  - TASK_ID: T001
  - PROJECT_NAME: 001-seismic-integration (detected from save location)

Canonical examples included:
  - services/highspot/client.rb

Reusable code found:
  - app/services/asset_engagement_metrics_service.rb:15-45 (similar metrics service)
  - lib/date_range_builder.rb:10-18 (date range helper)

Next steps:
1. Review handoff and fill in remaining variables (marked with {})
2. **VERIFY verify-specs.sh path is correct** (Loop 2 verification)
3. Read canonical examples before implementing
4. Follow TDD cycle: RED → GREEN → REFACTOR
5. Complete all three verification loops
6. After completion, move handoff to completed/ subfolder (see Archival section)
```

## Error Handling

**No task description**:
```
Error: Task description required
Usage: /handoff <task-description>
Example: /handoff implement Seismic property assignment with Rails service
```

**Template not found**:
```
Error: Template not found: {template_path}
Run: ls ~/.claude/templates/task/sections/
```

**Cannot determine save location**:
```
Warning: Could not detect project structure
Saving to: ./{TASK_ID}-{slug}.md
Consider creating specs/ directory for better organization
```
