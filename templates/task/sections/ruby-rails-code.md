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
- ✅ Define fixtures ONLY in `spec/support/fixture_builder.rb`
- ✅ Use FixtureBuilder.configure block
- ✅ Add exactly ONE fixture per new model
- ✅ Regenerate: `rake db:fixtures:dump` or `FIXTURES=true bundle exec rspec`

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

## CRITICAL: Rails Environment Checks (ABSOLUTE)

**You MUST NEVER use `Rails.env.production?`**

**RATIONALE:** Positive checks = easier staging/review app logic.

**CORRECT:**
```ruby
['development', 'test'].include?(Rails.env)
```

**WRONG:**
```ruby
Rails.env.production?  # ❌ FORBIDDEN
```

---

## CRITICAL: Strong Parameters vs Jbuilder Separation (ABSOLUTE)

**You MUST NEVER share constants between strong_params and jbuilder**

**RATIONALE:** Input acceptance (strong_params) and output presentation (jbuilder) are separate concerns.

**WRONG:**
```ruby
FIELDS = [:name, :email]  # ❌ Shared constant
params.require(:user).permit(FIELDS)
json.extract! @user, *FIELDS
```

**CORRECT:**
```ruby
# In controller
params.require(:user).permit(:name, :email)

# In jbuilder
json.extract! @user, :name, :email, :created_at
```

---

## CRITICAL: API Documentation First (ABSOLUTE)

**You MUST NEVER write API client methods without doc extraction**

**RATIONALE:** Guessing API specs = broken integration.

**BEFORE writing any client method:**
1. WebFetch the API documentation
2. Complete extraction template
3. Show extracted specs to user
4. ONLY THEN write implementation

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

## Ruby/Rails Implementation Details

### Method Signature

```ruby
{METHOD_SIGNATURE}
```

**Pattern Examples**:
```ruby
# Class method
def self.method_name(param1, param2)

# Instance method
def method_name(param1, param2)

# Service pattern
class ServiceName
  def initialize(resource)
    @resource = resource
  end

  def call
    # implementation
  end
end
```

### Expected Test Structure

**File**: `spec/{path}/{filename}_spec.rb`

```ruby
require 'rails_helper'

RSpec.describe {ClassName} do
  # Test data setup
  let(:resource) { create(:resource) }
  let(:service) { described_class.new(resource) }

  describe '{method_name}' do
    context 'when {condition}' do
      it '{expected behavior}' do
        # Arrange
        {SETUP}

        # Act
        result = {ACTION}

        # Assert
        expect(result).to {EXPECTATION}
      end
    end

    context 'when {different_condition}' do
      it '{different expected behavior}' do
        # ...
      end
    end
  end
end
```

**Test Data Setup Patterns**:
```ruby
# Factory usage
let(:user) { create(:user) }
let(:attributes) { attributes_for(:resource) }

# Manual setup
let(:valid_params) do
  {
    key1: 'value1',
    key2: 'value2'
  }
end

# Stubbing
before do
  allow(ExternalService).to receive(:call).and_return(stubbed_response)
end
```

### Verification Commands

**Loop 1 (TDD)**:
```bash
bundle exec rspec spec/{path}/{filename}_spec.rb
```

**Loop 2 (Scoped)**:
```bash
./specs/{PROJECT_NAME}/verify-specs.sh
# OR scoped to directory:
bundle exec rspec spec/services/
```

**Loop 3 (Console)**:

**Required for**: External APIs, database changes, integrations
**Skip ONLY with user approval**

```bash
rails console
{CONSOLE_VERIFICATION_COMMANDS}
```

### Code Quality Checklist

**Before Completing Task**:
- [ ] **CRITICAL: Every new public method has its own test** (test at the layer where defined)
- [ ] **CRITICAL: No manual fixture .yml files created or edited** (must use fixture_builder.rb)
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
- ❌ **Add public methods without tests** (every method needs its own spec)
- ❌ **Create or edit manual fixture .yml files** (use fixture_builder.rb ONLY)
- ❌ **Create breaking migrations** (follow safe add/remove patterns)
- ❌ **Use `Rails.env.production?`** (use positive environment checks)
- ❌ **Share constants between strong_params and jbuilder**
- ❌ **Add caching without justification** (optimize queries first)
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
