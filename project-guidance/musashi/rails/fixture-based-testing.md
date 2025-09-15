---
type: guidance
status: current
category: rails
project: musashi
---

# Fixture-Based Testing Strategy

## Overview
This project prioritizes fixtures over factories for performance and consistency. Fixtures are defined in `fixture_builder.rb` and provide typical test data scenarios.

## Core Principles

### Fixture Usage
- **Always use fixtures for typical data** - Pre-loaded, fast, consistent
- **Expose fixtures via `let` statements** - More readable than repeated fixture calls
- **Never edit fixture YAML files directly** - Use fixture_builder.rb instead

### Example Pattern
```ruby
describe UserService do
  let(:user) { users(:main_user) }
  let(:admin) { users(:admin) }
  let(:account) { accounts(:primary) }
  
  it "processes user data" do
    result = UserService.new(user).process
    expect(result).to be_success
  end
end
```

### Factory Usage
- **Only for edge cases** - When fixtures don't provide needed scenario
- **Avoid FactoryBot.create** - Use build or build_stubbed
- **Never in unit tests** - Fixtures only for models, services, etc.

## Request Spec Patterns

### Acceptable Factory Use
```ruby
# Only in request specs for specific scenarios
it "handles user with 100+ projects" do
  user = FactoryBot.create(:user)
  100.times { FactoryBot.create(:project, user: user) }
  
  get api_projects_path
  expect(response).to be_success
end
```

## Anti-patterns
- Using `FactoryBot.create` in unit tests
- Editing fixture YAML files
- Not using `let` for fixture references
- Creating data that fixtures already provide

## Performance Impact
- Fixtures: ~0.01s per test
- Factories: ~0.5-2s per test
- 100 tests difference: 50-200s saved

## Migration from Factories
1. Check if fixture exists: `grep -r "user:" spec/fixtures/`
2. Replace factory with fixture: `users(:main_user)`
3. Use `let` for cleaner code
4. Remove unnecessary factory traits that fixtures cover