---
type: task-template
section: ruby-rails-code
description: Ruby/Rails patterns, RSpec test structure, console verification
applies_to: ruby
source_guidance:
  global:
    - testing/test-driven-development
    - development-process/tdd-human-review-cycle
    - code-quality/code-review-principles
  project:
    - musashi/rails/fixture-based-testing
---

## CRITICAL: Fixture Builder Constraint (ABSOLUTE)

**You MUST NEVER create or edit manual fixture .yml files**

**RATIONALE:** This project uses fixture_builder gem which regenerates ALL fixtures - manual .yml files in spec/fixtures/ or test/fixtures/ WILL BE DELETED on next regeneration.

**You MUST NEVER:**
- ❌ Create .yml files in spec/fixtures/ or test/fixtures/
- ❌ Edit existing .yml fixture files
- ❌ Use `File.write` to generate fixture files
- ❌ Copy fixture patterns from standard Rails documentation

**You MUST ALWAYS:**
- ✅ Define fixtures ONLY in `spec/support/test_data_factory.rb`
- ✅ Use FixtureBuilder.configure block
- ✅ Add exactly ONE fixture per new model
- ✅ Regenerate: `rake spec:fixture_builder_rebuild`

<!-- CONDITIONAL: Include migration section ONLY if needs_migration: true -->
<!-- BEGIN_IF_MIGRATION -->
## CRITICAL: Safe Database Migrations (ABSOLUTE)

**You MUST NEVER create breaking migrations**

**RATIONALE:** Breaking migrations cause production downtime.

**You MUST IMMEDIATELY STOP** if migration:
- Adds column and uses it in same deploy
- Removes column without `ignored_columns` first
- Changes column type on active column

**Safe Add**: Migration only → Deploy → Use in next PR
**Safe Remove**: Stop usage → ignored_columns → Deploy → Drop in next PR
<!-- END_IF_MIGRATION -->

---

## CRITICAL: Test Every New Public Method (ABSOLUTE)

**You MUST NEVER add a public method without its own test**

**RATIONALE:** Untested methods = hidden bugs + broken contracts.

**You MUST ALWAYS test at the layer where the method is defined:**
- ✅ Controller action → Request spec (NOT controller spec)
- ✅ Client method → Client spec
- ✅ Service method → Service spec
- ✅ Model method → Model spec
- ✅ Helper method → Helper spec

**WRONG:**
```ruby
# Adding method to Client class
def update_file_version(id, file)
  # implementation
end
# ❌ Only testing through Service that uses Client
```

**CORRECT:**
```ruby
# spec/services/seismic/client_spec.rb
describe '#update_file_version' do
  it 'updates the file version' do
    # Direct test of Client#update_file_version
  end
end

# spec/services/seismic/sync_service_spec.rb
describe '#call' do
  it 'uses client to update' do
    # Service test that may mock/stub Client
  end
end

# spec/requests/api/v2/assets_spec.rb (NOT spec/controllers/)
describe 'POST /api/v2/assets' do
  it 'creates asset' do
    # Request spec for controller action
  end
end
```

---

## CRITICAL: Spec File Organization (ABSOLUTE)

**You MUST NEVER create multiple spec files for individual methods**

**RATIONALE:** One spec file per class maintains organization and reduces file sprawl.

**File Organization Rules:**
- ✅ Controllers: ONE spec file per controller (all endpoints in single file)
- ✅ Models: ONE spec file per model (all methods in single file)
- ✅ Services: ONE spec file per service class (all methods in single file)
- ✅ Jobs: ONE spec file per job class (all methods in single file)
- ✅ Use `describe` and `context` blocks to organize tests within the file

**WRONG:**
```
spec/services/seismic/asset_exporter_get_asset_url_spec.rb     # ❌ Method-specific file
spec/services/seismic/asset_exporter_upload_url_spec.rb        # ❌ Method-specific file
spec/services/seismic/asset_exporter_url_detection_spec.rb     # ❌ Method-specific file
```

**CORRECT:**
```
spec/services/seismic/asset_exporter_spec.rb                   # ✅ Single file for entire class

RSpec.describe Seismic::AssetExporter do
  describe '#get_asset_url' do
    # Tests for get_asset_url method
  end

  describe '#upload_url' do
    # Tests for upload_url method
  end

  describe '#detect_url_type' do
    # Tests for detect_url_type method
  end
end
```

**IF you find multiple spec files for one class:**
1. **IMMEDIATELY STOP** creating new method-specific files
2. Consolidate into single spec file
3. Use describe blocks for each method
4. Delete redundant files

---

<!-- PLANNER NOTE: This section describes WHAT to implement, never HOW
     - Describe method names and purpose, not implementations
     - Reference existing code by line numbers, don't reproduce it
     - List test scenarios, don't write complete tests
     - Keep any code snippets to 1-5 lines maximum for context
-->

## Ruby/Rails Implementation Details

### Method Signatures Required

**List method names with brief descriptions only:**
- `method_name(param1, param2)` - {purpose}
- `other_method` - {purpose}

**Reference existing patterns:**
- Similar to: `{existing_file}:{line_numbers}`
- Follow pattern in: `{canonical_example}`

<!-- PLANNER NOTE: Do NOT include full method implementations or class structures -->

### Test Coverage Required

**Spec file**: `spec/{path}/{filename}_spec.rb`

**Test scenarios to cover:**
- {Scenario 1 description} - verify {behavior}
- {Scenario 2 description} - verify {edge case}
- {Scenario 3 description} - verify {error handling}

**Reference existing test patterns:**
- Similar to: `{existing_spec_file}:{line_numbers}`

<!-- PLANNER NOTE: Describe scenarios, do NOT write complete test code -->

### Verification Commands

**Loop 1 (TDD)**:
```bash
bundle exec rspec spec/{path}/{filename}_spec.rb
```

**Loop 2 (Scoped)**:
```bash
# CRITICAL: ALWAYS include verify-specs.sh for project-level verification
./specs/{PROJECT_NAME}/verify-specs.sh

# Alternative (if verify-specs.sh doesn't exist yet):
bundle exec rspec spec/services/
```

**Loop 3 (Console/Script Verification)**:

**Loop 3 Determination (Binary - REQUIRED or NOT REQUIRED)**:

Loop 3 is **REQUIRED** unless ALL code paths are 100% exercised by unit tests (RSpec).

**REQUIRED** (most backend tasks):
- ✅ Service integrating with external APIs (verify real API behavior)
- ✅ Multi-component integration (Service → Client → API)
- ✅ Database changes (verify data persists correctly)
- ✅ Worker/job orchestration (verify job enqueuing and execution)
- ✅ Any integration flow not covered by e2e RSpec tests

**NOT REQUIRED** (rare - fully unit tested):
- Pure utility methods with 100% RSpec coverage of all code paths
- Single-class changes where unit tests exercise every branch
- Changes covered by existing integration/request specs

**There is no "optional with approval" - determine which category applies and proceed.**

```bash
# Console verification
docker compose exec web bundle exec rails console
{CONSOLE_VERIFICATION_COMMANDS}

# OR script verification (for complex flows)
docker compose exec web bundle exec rails runner {SCRIPT_PATH}
```

### Code Quality Checklist

**Before Completing Task**:
- [ ] **CRITICAL: ONE spec file per class** (no method-specific spec files)
- [ ] **CRITICAL: Every new public method has its own test** (test at the layer where defined)
- [ ] **CRITICAL: No manual fixture .yml files created or edited** (must use test_data_factory.rb)
- [ ] **CRITICAL: No breaking migrations** (add/remove columns follow safe patterns)
- [ ] **CRITICAL: No `Rails.env.production?` usage** (use positive environment checks)
- [ ] **CRITICAL: No shared constants between strong_params and jbuilder**
- [ ] **CRITICAL: No caching without documented justification** (exhaust query optimization first)
- [ ] RuboCop passes: `bundle exec rubocop {modified_files}`
- [ ] No debug statements (`binding.pry`, `puts`, `console.log` remnants)
- [ ] Method complexity reasonable (< 10 lines preferred)
- [ ] Clear variable names (no `tmp`, `data`, `result` without context)
- [ ] Edge cases handled (nil, empty, invalid input)
- [ ] Error messages are descriptive

### Rails Patterns

**Service Objects**:
```ruby
# app/services/{domain}/{service_name}.rb
module Domain
  class ServiceName
    def initialize(resource)
      @resource = resource
    end

    def call
      # Keep focused on single responsibility
      # Return meaningful result
    end

    private

    def helper_method
      # Private methods for complex logic
    end
  end
end
```

**Controller Integration** (if applicable):
```ruby
def action_name
  service = Domain::ServiceName.new(resource)
  result = service.call

  if result.success?
    render json: result.data
  else
    render json: { error: result.error }, status: :unprocessable_entity
  end
end
```

<!-- CONDITIONAL: Include ONLY if needs_canonical: true (creating NEW class/major rewrite) -->
<!-- BEGIN_IF_CANONICAL -->
### Canonical Examples

**Creating NEW controller?** Read: `app/api/v2/video_link_assets_controller.rb`
**Creating NEW service?** Read: `services/highspot/client.rb`
**Creating NEW model?** Read: `models/seismic_integration.rb`
**Creating NEW worker?** Read: `HighspotPublicSyncWorker`

Follow their patterns for structure, error handling, naming.
<!-- END_IF_CANONICAL -->

### Common Anti-patterns to Avoid

**You MUST NEVER**:
- ❌ **Create multiple spec files for individual methods** (ONE spec file per class)
- ❌ **Add public methods without tests** (every method needs its own spec)
- ❌ **Create or edit manual fixture .yml files** (use test_data_factory.rb ONLY)
- ❌ **Create breaking migrations** (follow safe add/remove patterns)
- ❌ **Use `Rails.env.production?`** (use positive environment checks)
- ❌ **Share constants between strong_params and jbuilder**
- ❌ **Add caching without justification** (optimize queries first)
- ❌ **Add boilerplate comments** (no `# Arrange`, `# Act`, `# Assert`, `# Setup`, etc. - code should be self-documenting)
- ❌ Skip writing tests first (TDD red phase)
- ❌ Over-mock/stub in tests (test real behavior when possible)
- ❌ Put business logic in controllers
- ❌ Use `allow_any_instance_of` (brittle and unclear)
- ❌ Leave `skip` or `pending` in tests without STOP and ASK protocol
- ❌ Commit commented-out code
- ❌ Use raw SQL when ActiveRecord methods exist

**Prefer**:
- ✅ Service objects for complex business logic
- ✅ Integration tests over unit tests for critical flows
- ✅ Fixtures over factories. Only use factories for integration type specs ilke request specs, or for edge cases where the standard fixtures do't suffice
- ✅ Named scopes over repeated `where` clauses
- ✅ ActiveRecord callbacks only for model concerns (not business logic)
