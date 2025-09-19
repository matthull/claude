---
type: guidance
status: current
category: rails
project: musashi
---

# Fixture-Based Testing Strategy

## Overview
This project prioritizes fixtures over factories for performance and consistency. Fixtures are defined in `spec/support/fixture_builder.rb` and provide typical test data scenarios.

## Critical Requirements for New Models

### ALWAYS Create Fixtures for New Models
**When introducing ANY new model, you MUST:**
1. Add **exactly ONE** fixture in `fixture_builder.rb` (start minimal)
2. Name it simply after the model (e.g., `@integration_config`, `@webhook`)
3. Associate with `@main_account` (unless model doesn't belong to account)
4. Use consistent IDs and timestamps (FIXED_TIME)
5. Set attributes to typical/default values
6. Let tests modify this fixture for different states

### Example: Adding Fixture for New Model
```ruby
# In spec/support/fixture_builder.rb
FixtureBuilder.configure do |fbuilder|
  fbuilder.factory do
    # ... existing fixtures ...

    # START WITH JUST ONE fixture per model
    @seismic_integration = SeismicIntegration.create!(
      id: 1,
      account: @main_account,  # Default to main_account
      delegation_user_email: '',  # Start in typical/default state
      delegation_user_id: nil,
      tenant_id: nil,
      # ... other attributes with sensible defaults ...
      created_at: FIXED_TIME,
      updated_at: FIXED_TIME
    )
    # Tests can modify this fixture as needed for different states
  end
end
```

## Core Principles

### Fixture Creation in fixture_builder.rb
- **Location**: `spec/support/fixture_builder.rb` - ONLY place to define fixtures
- **Rebuild**: Fixtures auto-rebuild when fixture_builder.rb changes
- **Fixed Time**: Use `FIXED_TIME` constant for timestamps
- **Consistent IDs**: Use sequential IDs starting from 1
- **Associations**: Link fixtures together using instance variables
- **Naming**: Use descriptive instance variable names (`@main_`, `@typical_`, etc.)

### Fixture Usage in Tests
- **Always use fixtures for typical data** - Pre-loaded, fast, consistent
- **Expose fixtures via `let` statements** - More readable than repeated fixture calls
- **Never edit fixture YAML files directly** - They're auto-generated

### Example Test Pattern
```ruby
describe IntegrationConfigService do
  # Expose fixtures with let statements
  let(:integration_config) { integration_configs(:main_integration_config) }
  let(:inactive_config) { integration_configs(:inactive_integration_config) }
  let(:account) { accounts(:main_account) }

  it "processes active integrations" do
    result = IntegrationConfigService.new(integration_config).sync
    expect(result).to be_success
  end
end
```

## Fixture Builder Best Practices

### Required Elements for Each Fixture
1. **Unique ID**: Sequential integers starting from 1
2. **Associations**: Link to existing fixtures via instance variables
3. **Required attributes**: All validations must pass
4. **Timestamps**: Always use FIXED_TIME constant
5. **Realistic data**: Use meaningful values, not "test123"

### Fixture Relationships
```ruby
# Good: Clear relationships between fixtures
@customer = FactoryBot.create(:customer, account: @main_account, ...)
@customer_page = FactoryBot.create(:customer_page, customer: @customer, ...)
@testimonial = FactoryBot.create(:testimonial, customer: @customer, ...)

# Bad: Creating orphaned fixtures
@customer = FactoryBot.create(:customer, ...)  # No account!
```

### When to Add Multiple Fixtures (RARE)
**DEFAULT: Start with ONE fixture per model.** Only add more when:
- Multiple accounts absolutely require isolated test data that can't be created in test setup
- A specific state is used across many test files (not just a few tests)
- The fixture represents a fundamentally different configuration (e.g., different account)

**Before adding a second fixture, ask:**
- Can I modify the existing fixture in my test setup instead?
- Is this state truly needed across many test files?
- Am I creating fixture proliferation unnecessarily?

## Factory Usage Guidelines

### When Factories Are Acceptable
- **Only for edge cases** - When fixtures don't provide needed scenario
- **Request specs only** - For testing extreme scenarios
- **Build over create** - Use `build` or `build_stubbed` when possible
- **Never in unit tests** - Fixtures only for models, services, etc.

### Acceptable Factory Use Example
```ruby
# Only in request specs for specific scenarios
it "handles account with 100+ integrations" do
  account = accounts(:main_account)
  100.times do
    FactoryBot.create(:integration_config, account: account)
  end

  get api_integration_configs_path
  expect(response).to be_success
end
```

## Common Fixture Patterns

### Minimal Fixture Philosophy
**Start with ONE fixture per model in a typical state.** Modify in tests as needed.

```ruby
# CORRECT: Just one fixture in typical state
@integration_config = FactoryBot.create(
  :integration_config,
  id: 1,
  account: @main_account,  # Default to main_account
  status: 'active',  # Typical/default state
  created_at: FIXED_TIME,
  updated_at: FIXED_TIME
)

# AVOID: Multiple fixtures for different states
# DON'T create @active_config, @inactive_config, @pending_config, etc.
# Instead, modify the one fixture in your test setup
```

### Modifying Fixtures in Test Setup
Instead of creating multiple fixtures, modify the existing fixture in your test:

```ruby
describe "when integration is inactive" do
  before do
    integration_configs(:integration_config).update!(status: 'inactive')
  end

  it "skips processing" do
    # Test with modified fixture
  end
end

describe "with expired tokens" do
  before do
    integration = integration_configs(:integration_config)
    integration.update!(
      access_token: 'expired-token',
      token_expires_at: 1.day.ago
    )
  end

  it "refreshes the token" do
    # Test with modified fixture
  end
end
```

## Anti-patterns to Avoid
- **Forgetting fixtures for new models** - Always add exactly one
- **Creating multiple fixtures for different states** - Modify the one fixture in tests instead
- **Fixture proliferation** - Don't create @active_, @inactive_, @pending_ variants
- Using `FactoryBot.create` in unit tests
- Editing fixture YAML files directly
- Not using `let` for fixture references
- Creating fixtures without associations
- Using random or Time.now for timestamps
- Skipping fixture creation thinking "I'll add it later"

## Performance Impact
- Fixtures: ~0.01s per test
- Factories: ~0.5-2s per test
- 100 tests difference: 50-200s saved
- Fixture builder runs once, not per test

## Checklist for New Models
- [ ] Model class created
- [ ] Migration written
- [ ] Factory defined in `spec/factories/`
- [ ] **ONE FIXTURE added to fixture_builder.rb** ← CRITICAL (just one!)
- [ ] Fixture associated with @main_account
- [ ] Model specs use the fixture (modify in tests as needed)
- [ ] Request specs use fixture where appropriate