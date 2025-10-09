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

## CRITICAL: Safe Database Migrations (ABSOLUTE)

**You MUST NEVER create breaking migrations**

**RATIONALE:** Breaking migrations cause production downtime.

**You MUST IMMEDIATELY STOP** if a migration:
- ❌ Adds column and uses it in same deploy
- ❌ Removes column without `ignored_columns` first
- ❌ Changes column type used by running code
- ❌ Adds constraint on existing data
- ❌ Renames column used by running code

**Safe Patterns ONLY:**

**Adding Column:**
1. Add column (migration only)
2. Deploy
3. Use column (code in next PR)

**Removing Column:**
1. Remove code usage
2. Add to `ignored_columns`
3. Deploy
4. Drop column (migration in next PR)

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

### Loop Commands

**Loop 1: TDD Inner Loop**
```bash
bundle exec rspec spec/{path}/{filename}_spec.rb
```

**Loop 2: Project-Wide Verification**
```bash
bundle exec rspec
# OR if project has verify script:
./specs/{PROJECT_NAME}/verify-specs.sh
```

**Loop 3: Rails Console Verification (OPTIONAL - requires user approval to skip)**

**When Loop 3 is REQUIRED**:
- ✅ Integration of multiple components
- ✅ External API interactions
- ✅ Complex business logic with side effects
- ✅ Database queries or ActiveRecord relationships
- ✅ State transitions or workflow logic

**When Loop 3 MAY BE SKIPPED** (with user approval):
- ⚠️ Pure service objects with no external dependencies
- ⚠️ Simple data transformations
- ⚠️ Unit tests provide 100% confidence in behavior

**Stop and Ask Protocol**:
```
Before skipping Loop 3, you MUST ask:
"This task involves [description]. Unit tests provide [level] confidence.
May I skip Loop 3 console verification, or would you like me to perform manual QA?"
```

**Console Verification Procedure**:
```bash
rails console

# Test the implementation with real data
{CONSOLE_VERIFICATION_COMMANDS}
```

**Console Testing Examples**:
```ruby
# Load relevant data
resource = Resource.find({ID})

# Test service/method directly
service = ServiceName.new(resource)
result = service.call

# Verify result
result.inspect
# => Expected output

# Check side effects
resource.reload
resource.attribute_name
# => Expected value

# Test edge cases
edge_case_resource = Resource.where({condition}).first
ServiceName.new(edge_case_resource).call
```

### Code Quality Checklist

**Before Completing Task**:
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

### Canonical Examples (Project-Specific)

**These are exemplar implementations in the codebase. Read and follow their patterns when implementing similar functionality.**

#### Controllers

**CRUD Controllers** - Read: `app/api/v2/video_link_assets_controller.rb`
```
Use when: Building standard REST API endpoints (index, show, create, update, destroy)
Follow patterns for:
- Strong parameters
- Response formatting (success/error)
- Status codes (200, 201, 204, 422, 404)
- Resource loading and authorization
```

**Integration Controllers** - Read: `app/api/v2/seismic/teamsites_controller.rb`
```
Use when: Integrating with 3rd party APIs via controller actions
Follow patterns for:
- External service orchestration
- Error handling from external APIs
- Response mapping (external → internal format)
- Async job triggering for long-running operations
```

#### Models

**Asset Models** - Read: `models/video_link_asset.rb`
```
Use when: Creating asset-type models (files, links, media)
Follow patterns for:
- Asset-specific validations
- Type hierarchies (STI or polymorphism)
- Associated metadata handling
- File/URL processing
```

**General Models** - Read: `models/seismic_integration.rb`
```
Use when: Creating any model class
Follow patterns for:
- Validations and callbacks
- Associations (has_many, belongs_to, etc.)
- Scopes and class methods
- Instance methods for business logic
- State management (if applicable)
```

#### Services

**API Clients** - Read: `services/highspot/client.rb`
```
Use when: Building HTTP clients for external APIs
Follow patterns for:
- HTTP client setup (Faraday, HTTParty)
- Authentication (headers, tokens)
- Request/response handling
- Error handling (4xx, 5xx responses)
- Retry logic and timeouts
```

**General Services** - Read: `services/highspot/asset_metadata.rb`
```
Use when: Extracting business logic from models/controllers
Follow patterns for:
- Service object structure (initialize, call)
- Dependency injection
- Error handling and result objects
- Single responsibility focus
- Private helper methods
```

#### Workers

**Async Jobs** - Read: `HighspotPublicSyncWorker`
```
Use when: Creating background jobs (Sidekiq, ActiveJob)
Follow patterns for:
- Job structure and perform method
- Error handling and retries
- Job queuing and priority
- Idempotency considerations
- Progress tracking (if applicable)
```

**Instructions for Handoff Creator**:
```
When generating a task handoff:
1. Identify which pattern(s) apply to the task
2. Add instruction to read relevant canonical example(s)
3. Format: "Read and follow patterns from: {FILE_PATH}"
4. Include in Task Details or Quick Context section
```

**Instructions for Task Implementer**:
```
When working on a task with canonical examples:
1. Read the canonical example BEFORE implementing
2. Follow its patterns (structure, error handling, naming)
3. Adapt patterns to your specific use case
4. Maintain consistency with codebase conventions
```

### Common Anti-patterns to Avoid

**You MUST NEVER**:
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
