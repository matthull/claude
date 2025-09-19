---
type: guidance
status: current
category: testing
---

# Testing Patterns

## Test Performance
- Avoid `FactoryBot.create` - use fixtures or `FactoryBot.build`
- **Never** edit fixture yml files - use fixture_builder.rb instead
- **Start with ONE fixture per model** - modify in tests for different states
- Avoid using factories outside of request specs, use fixtures instead
- Profile and optimize slow specs when modifying code
- Only write capybara specs when prompted by user
- **Never** write controller specs, use request specs instead
- When writing request specs, avoid writing one spec per attribute when testing response payloads, instead write a single spec that checks all attributes for a given scenario.
- When running automated tests to check for regression, the whole test suite is too slow (10+ min.) to run except occasionally. Identify specific spec files to run that are relevant to the changes.

## RSpec Guidelines
- **Always** prefer `let` over instance variables
- **Use fixtures in unit tests** - fixtures are automatically loaded, no need for `fixtures :all`
- **Use `let` statements to expose fixtures** instead of repeating fixture calls - e.g., `let(:user) { users(:main_user) }`
- **One fixture per model** - Start with one fixture in fixture_builder.rb, modify in tests for different states
- **Fixtures for typical data** - Use fixtures defined in fixture_builder.rb for standard test scenarios
- **Factories for edge cases** - Use factories only when fixtures don't provide the specific test data needed
- **Never `include rails_helper`**, it's auto-included
- **use `describe` not `Rspec.describe`**