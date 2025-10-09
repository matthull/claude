---
description: Create a task handoff using the template system
---

## Usage
```
/handoff <task-description>
```

**Examples:**
- `/handoff implement Seismic property assignment with Rails service`
- `/handoff fix rendering bug in SeismicFolderSelector component`
- `/handoff add custom_properties table with indexes`
- `/handoff create API client for Highspot integration`

## Implementation

### 1. Parse Task Description & Detect Project Stack

**Input**: `$ARGUMENTS` contains task description

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
- If Vue: `sections/vue-component.md` (TODO: create this)

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
5. **Leave other variables as placeholders** for manual filling

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

# Save
echo "$content" > "$save_path"
```

### 7. Report to User

```
✅ Created task handoff: {save_path}

Templates used:
  - core-task-template.md
  - sections/ruby-rails-code.md
  - sections/api-integration.md
  - sections/testing.md

Canonical examples included:
  - services/highspot/client.rb

Next steps:
1. Review handoff and fill in remaining variables (marked with {})
2. Read canonical examples before implementing
3. Follow TDD cycle: RED → GREEN → REFACTOR
4. Complete all three verification loops
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
