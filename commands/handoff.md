---
description: Create a task handoff using the template system
---

## Roles Reminder

**Claude: QA Engineer** - Owns ALL testing (automated AND "manual" via tools) before handoff.
**Human: Product Manager** - Receives thoroughly tested feature for UAT sign-off.

**Handoff documents should prepare Claude to complete full QA**, not defer testing to human.

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
SPEC DIRECTORY: {SPEC_DIR}

SPEC CONTEXT (extracted from prerequisite docs - use this to inform implementation):
---
{SPEC_CONTEXT}
---

INSTRUCTIONS:
1. Read the tasks file at {TASKS_FILE_PATH}
2. Extract requirements for Task {TASK_NUMBER}
3. Use the SPEC CONTEXT above for implementation details
4. If more context needed, read full spec docs at {SPEC_DIR}
5. Follow the handoff creation process defined in Steps 3-7 below
6. Include relevant spec excerpts in the "Spec Context" section of the handoff
7. Save the handoff to the appropriate location
8. Report what was created

Follow the handoff template composition process:
{INCLUDE_STEPS_3_TO_7_HERE}
```

**CRITICAL: Before spawning subagents, YOU (main agent) MUST:**
1. Read the tasks.md file
2. Parse line refs from task entries (e.g., `**Ref:** spec:195-226`)
3. Read the main spec doc(s) in the spec directory
4. Extract relevant sections using the hybrid approach (Step 0c)
5. Store extracted context in `{SPEC_CONTEXT}` variable
6. Include extracted context in EACH subagent prompt

### Step 3: Freeform Description Mode (Mode B)

**If no task file reference detected**, process in main conversation using legacy behavior (Steps 3-7 below).

---

## Handoff Creation Process (Executed by Subagents or Main Conversation)

**NOTE**: The following steps (0-7) are executed by:
- **Subagents** when using Mode A/C (task file references)
- **Main conversation** when using Mode B (freeform descriptions)

### 0. Template Structure

**NOTE:** Templates are now split into universal core + category-specific sections.

**Core template** (`core-task-template.md`):
- Universal constraints (Verification Discipline, STOP and Ask, Collaboration Gates)
- Generic verification loops (Targeted → Integration → End-to-End)
- Applies to ALL task types

**Category sections** (one per task):
- `software-development.md` - TDD, testing discipline, code quality (coding tasks)
- `dev-environment-setup.md` - Tool setup, health checks, troubleshooting (operational tasks)
- `infrastructure-ops.md` - Cloud services, CI/CD, security validation (infrastructure tasks)
- `config-files.md` - Syntax validation, integration checks (configuration tasks)

The category section is selected based on task description keywords (see Step 1).

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

### 0c. CRITICAL: Extract Spec Context for Task (HYBRID APPROACH)

**Purpose:** Extract task-relevant excerpts from spec docs for:
1. **Subagent context** - pass extracted context in subagent prompts
2. **Handoff embedding** - include excerpts directly in task handoff documents

**LIMIT: 100 lines max per spec document** (keep handoffs focused)

**Extraction Strategy (Hybrid):**

**Priority 1: Line References from tasks.md**
```markdown
# tasks.md uses refs like:
- **Ref:** spec:195-226, 680-691
- **Reference:** data-model.md:45-120

# Extract using sed:
sed -n '195,226p' specs/project/main-spec.md
sed -n '680,691p' specs/project/main-spec.md
```

**Priority 2: Section Header Matching** (when no line refs)
```bash
# Match task keywords to spec section headers
# Task mentions "API endpoint" → extract "## API Contract" or "## Backend API" section
# Task mentions "component" → extract "## Vue Component" section
# Task mentions "service" → extract "## Backend Service" section

# Use grep to find section and extract with context:
grep -n "^## .*API" specs/project/spec.md | head -1  # Find section start
awk '/^## .*API/,/^## [^A]/' specs/project/spec.md   # Extract until next ## header
```

**Priority 3: Keyword Context** (fallback)
```bash
# Extract lines around key terms mentioned in task:
grep -B 5 -A 10 "service.*responsibilities" specs/project/spec.md
grep -B 3 -A 15 "Request Parameters" specs/project/spec.md
```

**Implementation Process:**

1. **Parse task for line refs:**
   ```bash
   # Extract **Ref:** or **Reference:** patterns from task entry
   refs=$(grep -oP '\*\*Ref:\*\*\s*\K[^\n]+' task_entry)
   # Parse into file:line-range pairs
   ```

2. **If line refs found:**
   ```bash
   for ref in $refs; do
     file=$(echo "$ref" | cut -d: -f1)
     lines=$(echo "$ref" | cut -d: -f2)
     start=$(echo "$lines" | cut -d- -f1)
     end=$(echo "$lines" | cut -d- -f2)
     sed -n "${start},${end}p" "specs/$project/$file"
   done
   ```

3. **If no line refs, match sections:**
   ```bash
   # Build keyword list from task description
   keywords="service|API|endpoint|component|..."

   # Find matching sections in main spec doc
   grep -n "^## " specs/$project/*.md | grep -iE "$keywords"

   # Extract each matching section (cap at 100 lines total)
   ```

4. **Store in `{SPEC_CONTEXT}` variable** for template substitution

**Output Format (for handoff embedding):**
```markdown
## Spec Context (from specs/project/spec.md)

<!-- Extracted lines 195-226 -->
### API Contract
GET /app/api/v2/channel_engagement_metrics.json
...
<!-- End extraction -->

<!-- Extracted lines 680-691 (test scenarios) -->
### Test Scenarios
- Success case with expected result
...
<!-- End extraction -->
```

**Subagent Prompt Enhancement:**
```
{existing subagent prompt}

SPEC CONTEXT (extracted from prerequisite docs):
---
{SPEC_CONTEXT}
---

Use this spec context to inform your implementation approach.
Line references point to full spec docs if more detail needed.
```

**Rules:**
- **NEVER exceed 100 lines per spec doc** - truncate with "... [truncated, see spec:N-M for full section]"
- **Prefer line refs over section matching** - more precise
- **Include line numbers** in output so implementer can find original
- **Focus on implementation-relevant sections** - skip overview/intro sections

---

### 0d. Code Discovery for Reuse

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

**Task Category** (determines core section template):
- **Coding**: `implement`, `create`, `add`, `fix`, `refactor`, `service`, `component`, `model`, `controller`, `feature`, `bug`
- **Operational**: `setup`, `install`, `configure`, `environment`, `editor`, `emulator`, `tooling`, `dev env`, `workspace`, `Waydroid`, `Neovim`, `LSP`
- **Infrastructure**: `CI/CD`, `pipeline`, `deploy`, `Supabase`, `database setup`, `RLS`, `monitoring`, `Sentry`, `PostHog`, `EAS`, `GitHub Actions`
- **Configuration**: `.yml`, `.yaml`, `.json`, `.toml`, `gitignore`, `Dockerfile`, `.env`, `config file`, `docker-compose`, `workflow`

**Technology Stack**:
- Ruby/Rails: `service`, `model`, `controller`, `Rails`, `Ruby`, `RSpec`, `ActiveRecord`, `backend`
- Vue/Frontend: `Vue`, `component`, `Storybook`, `Vitest`, `UI`, `frontend`
- React Native/Mobile: `React Native`, `Expo`, `mobile`, `PowerSync`, `Maestro`, `Paper`, `native`
- Bash/Docker: `bash`, `shell`, `script`, `.sh`, `bats`, `docker`, `container`, `verify-specs`
- API/Integration: `API`, `integration`, `client`, `HTTP`, `endpoint`

**Coding Task Type** (when task category is "coding"):
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

**Task Category sections** (determines base workflow):
- **Coding tasks**: `sections/software-development.md` (TDD, testing discipline)
- **Operational tasks**: `sections/dev-environment-setup.md` (tool setup, health checks)
- **Infrastructure tasks**: `sections/infrastructure-ops.md` (cloud services, CI/CD)
- **Configuration tasks**: `sections/config-files.md` (syntax validation)

**Technology sections** (add for coding tasks):
- If Ruby/Rails: `sections/ruby-rails-code.md`
- If Vue: `sections/vue-component.md`
- If React Native/Mobile: (future: `sections/react-native-mobile.md`)

**Domain sections** (add as needed):
- If API/integration: `sections/api-integration.md`
- If bash scripts: `sections/bash-docker-scripts.md`
- If UI/manual QA: `sections/manual-qa.md`
- If testing focus: `sections/testing.md`

**Selection Logic**:
```bash
# Start with core
templates=("$core_template")

# ============================================
# STEP 1: Detect Task Category (CRITICAL)
# ============================================
task_category="coding"  # default

# Check for operational tasks
if [[ "$description" =~ (setup|install|configure|environment|editor|emulator|tooling|dev.?env|workspace|Waydroid|Neovim|LSP|nvm|node.?version) ]]; then
  task_category="operational"
fi

# Check for infrastructure tasks
if [[ "$description" =~ (CI/?CD|pipeline|deploy|Supabase|database.?setup|RLS|monitoring|Sentry|PostHog|EAS|GitHub.?Actions|secrets|environment.?config) ]]; then
  task_category="infrastructure"
fi

# Check for configuration tasks
if [[ "$description" =~ (\.yml|\.yaml|\.json|\.toml|gitignore|Dockerfile|\.env|config.?file|docker-compose|workflow.?file) ]]; then
  task_category="configuration"
fi

# ============================================
# STEP 2: Add Category-Specific Section
# ============================================
case "$task_category" in
  "coding")
    templates+=("~/.claude/templates/task/sections/software-development.md")
    ;;
  "operational")
    templates+=("~/.claude/templates/task/sections/dev-environment-setup.md")
    ;;
  "infrastructure")
    templates+=("~/.claude/templates/task/sections/infrastructure-ops.md")
    ;;
  "configuration")
    templates+=("~/.claude/templates/task/sections/config-files.md")
    ;;
esac

# ============================================
# STEP 3: Add Technology Sections (for coding tasks)
# ============================================
if [ "$task_category" = "coding" ]; then
  # Detect project stack
  project_has_rails=false
  project_has_vue=false
  project_has_expo=false

  if [ -f "Gemfile" ]; then
    project_has_rails=true
  fi

  if [ -f "package.json" ]; then
    if grep -q '"vue"' package.json; then
      project_has_vue=true
    fi
    if grep -q '"expo"' package.json; then
      project_has_expo=true
    fi
  fi

  # Add technology section based on project + keywords
  if [[ "$description" =~ (backend|service|model|controller|Rails|Ruby|RSpec) ]] && [ "$project_has_rails" = true ]; then
    templates+=("~/.claude/templates/task/sections/ruby-rails-code.md")
  elif [[ "$description" =~ (service|model|controller|Rails|Ruby|RSpec) ]]; then
    templates+=("~/.claude/templates/task/sections/ruby-rails-code.md")
  fi

  if [[ "$description" =~ (frontend|Vue|component|Storybook|UI) ]] && [ "$project_has_vue" = true ]; then
    templates+=("~/.claude/templates/task/sections/vue-component.md")
  elif [[ "$description" =~ (Vue|component|Storybook|frontend) ]]; then
    templates+=("~/.claude/templates/task/sections/vue-component.md")
  fi

  # Future: React Native/Mobile section
  # if [[ "$description" =~ (React.?Native|Expo|mobile|PowerSync) ]] && [ "$project_has_expo" = true ]; then
  #   templates+=("~/.claude/templates/task/sections/react-native-mobile.md")
  # fi
fi

# ============================================
# STEP 4: Add Domain Sections (any task type)
# ============================================
if [[ "$description" =~ (bash|shell|\.sh|bats|script.*test|docker.*script|verify-specs|container) ]]; then
  templates+=("~/.claude/templates/task/sections/bash-docker-scripts.md")
fi

if [[ "$description" =~ (API|integration|client|HTTP|external) ]]; then
  templates+=("~/.claude/templates/task/sections/api-integration.md")
fi

# Add manual QA if UI or integration (coding tasks)
if [ "$task_category" = "coding" ] && [[ "$description" =~ (UI|component|integration|manual) ]]; then
  templates+=("~/.claude/templates/task/sections/manual-qa.md")
fi

# Add testing section for coding tasks (unless already covered by software-development)
if [ "$task_category" = "coding" ] && [[ "$description" =~ (test|spec|coverage) ]]; then
  templates+=("~/.claude/templates/task/sections/testing.md")
fi

# ============================================
# STEP 5: Check for Missing Templates (STOP AND ASK)
# ============================================
missing_templates=()

# React Native / Mobile - template not yet created
if [[ "$description" =~ (React.?Native|Expo|mobile|PowerSync|Maestro|native.?app) ]]; then
  if [ ! -f ~/.claude/templates/task/sections/react-native-mobile.md ]; then
    missing_templates+=("react-native-mobile.md (React Native/Expo patterns)")
  fi
fi

# PowerSync / Offline-first - template not yet created
if [[ "$description" =~ (PowerSync|offline|sync|conflict.?resolution) ]]; then
  if [ ! -f ~/.claude/templates/task/sections/powersync-offline.md ]; then
    missing_templates+=("powersync-offline.md (offline-first sync patterns)")
  fi
fi

# Maestro E2E - template not yet created
if [[ "$description" =~ (Maestro|E2E|end.?to.?end|flow.?test) ]]; then
  if [ ! -f ~/.claude/templates/task/sections/maestro-e2e.md ]; then
    missing_templates+=("maestro-e2e.md (Maestro E2E testing patterns)")
  fi
fi

# State management - template not yet created
if [[ "$description" =~ (Zustand|state.?management|store) ]]; then
  if [ ! -f ~/.claude/templates/task/sections/state-management.md ]; then
    missing_templates+=("state-management.md (Zustand/state patterns)")
  fi
fi

# If missing templates detected, STOP AND ASK
if [ ${#missing_templates[@]} -gt 0 ]; then
  echo "🛑 STOP: Missing template(s) detected for this task type"
  echo ""
  echo "The following templates would be helpful but don't exist yet:"
  for tmpl in "${missing_templates[@]}"; do
    echo "  - $tmpl"
  done
  echo ""
  echo "Options:"
  echo "  1. Proceed without specialized template (use generic guidance)"
  echo "  2. Create the template first, then retry handoff"
  echo "  3. Provide inline guidance for this specific task"
  echo ""
  echo "How would you like to proceed?"
  # AWAIT USER DECISION - do not proceed until user responds
  exit 1
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

Task Category: {task_category}
  - coding → software-development.md (TDD, testing discipline)
  - operational → dev-environment-setup.md (tool setup, health checks)
  - infrastructure → infrastructure-ops.md (cloud services, CI/CD)
  - configuration → config-files.md (syntax validation)

Prerequisites read:
  - specs/XXX/plan.md (architecture decisions)
  - specs/XXX/data-model.md (entity design)
  - specs/XXX/research.md (implementation approach)
  - specs/XXX/contracts/YYY.yaml (API contract)

Spec context extracted:
  - main-spec.md:195-226 (API Contract - 31 lines)
  - main-spec.md:680-691 (Test Scenarios - 11 lines)
  - data-model.md:45-80 (Entity Schema - 35 lines)
  Total: 77 lines (within 100-line limit)

Templates used:
  - core-task-template.md (universal)
  - sections/{category-section}.md (based on task category)
  - sections/{technology-section}.md (if coding task)
  - sections/{domain-section}.md (as needed)

Variables filled:
  - DATE: 2025-11-05
  - TASK_ID: T001
  - TASK_TYPE: {task_category}
  - PROJECT_NAME: 001-seismic-integration (detected from save location)
  - SPEC_CONTEXT: (embedded in handoff)

Canonical examples included (if coding task):
  - services/highspot/client.rb

Reusable code found:
  - app/services/asset_engagement_metrics_service.rb:15-45 (similar metrics service)
  - lib/date_range_builder.rb:10-18 (date range helper)

Next steps (vary by task category):

**For coding tasks:**
1. Review handoff and fill in remaining variables (marked with {})
2. Read canonical examples before implementing
3. Follow TDD cycle: RED → GREEN → REFACTOR
4. Complete all three verification loops (Claude owns all - including Loop 3 via tools)
5. If tools unavailable: STOP and Ask, do NOT defer to human
6. After completion with evidence, move handoff to completed/ subfolder

**For operational/infrastructure tasks:**
1. Review handoff and verification plan
2. Execute setup/configuration steps
3. Run health checks and verify each component via tools
4. Document any troubleshooting steps encountered
5. If verification tools unavailable: STOP and Ask
6. Hand off only after all verification passes (not "please verify manually")

**Role reminder:** Claude is QA Engineer. Human receives thoroughly tested work for UAT sign-off.
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
