---
type: guidance
status: current
category: testing
---

# Test-Driven Development Principles

## Overview
TDD is a development methodology where tests are written before implementation code, ensuring correctness and driving design.

## The TDD Cycle

### Red-Green-Refactor
1. **Red**: Write a failing test for next functionality
2. **Green**: Write minimal code to make test pass
3. **Refactor**: Improve code structure keeping tests green

### Cycle Timing
- Each cycle: 5-10 minutes maximum
- If longer, break into smaller steps
- Commit after each green state

## Testing Pyramid

### Distribution
- **Unit Tests (70%)**: Fast, isolated, numerous
- **Integration Tests (20%)**: Key workflows and boundaries
- **E2E Tests (10%)**: Critical user paths only

### When to Use Each Level

#### Unit Tests
- Individual functions/methods
- Business logic
- Data transformations
- Edge cases

#### Integration Tests
- API endpoints
- Database interactions
- Service boundaries
- External service mocking

#### E2E Tests
- Critical user workflows
- Payment flows
- Authentication
- Cross-system operations

## Test Structure Pattern (AAA)

```ruby
it "describes the behavior" do
  # Arrange - Set up test data
  user = create(:user)
  
  # Act - Execute the behavior
  result = UserService.new(user).perform
  
  # Assert - Verify the outcome
  expect(result).to be_success
  expect(user.reload.status).to eq('active')
end
```

**Key Points:**
- One logical assertion per test
- Test behavior, not implementation
- Use descriptive test names

## Test Data Strategies

### Use Fixtures When
- Testing with typical data
- Need consistent data across tests
- Performance is critical
- Read-heavy operations

### Use Factories When
- Testing edge cases
- Need specific data combinations
- Testing write operations
- Building complex object graphs

### Data Minimalism
- Use minimum data required
- Explicitly set only relevant attributes
- Let defaults handle irrelevant fields

## Performance Targets
- Unit tests: < 1ms each
- Integration tests: < 100ms each
- E2E tests: < 5s each
- Full suite: < 10 minutes

## What to Test

### Do Test
- Public interfaces
- Business logic
- Edge cases and error paths
- Integration points
- Security boundaries

### Don't Test
- Framework code
- Simple getters/setters
- Third-party libraries
- Implementation details

## Test Doubles

### Types and Usage
- **Stubs**: Canned responses (external APIs)
- **Mocks**: Verify interactions (email sending)
- **Spies**: Record calls for verification
- **Fakes**: Simplified implementations (in-memory DB)

### Mocking Guidelines
- Mock at system boundaries
- Don't mock what you own
- Prefer real objects to mocks
- Verify assumptions with integration tests

## Test Naming

### Good Examples
```ruby
it "returns user's full name when first and last name present"
it "raises ArgumentError when email format is invalid"
```

### Context Grouping
```ruby
describe "#process" do
  context "when payment succeeds" do
    it "marks order as paid"
    it "sends confirmation email"
  end
  
  context "when payment fails" do
    it "marks order as failed"
    it "notifies customer service"
  end
end
```

## Anti-Patterns to Avoid

### Test Anti-Patterns
- **Ice Cream Cone**: Too many E2E, too few unit tests
- **Testing Private Methods**: Test through public interface
- **Excessive Mocking**: Indicates design problems
- **Shared State**: Tests depend on execution order
- **Mystery Guest**: Hidden test dependencies
- **Slow Tests**: Not running tests due to speed

### Code Smells in Tests
- Tests with conditional logic
- Tests with multiple behaviors
- Tests with no assertions
- Commented-out tests

## TDD Benefits

### Design Benefits
- Forces modular, testable design
- Reveals design problems early
- Encourages SOLID principles
- Documents intended behavior

### Development Benefits
- Faster debugging
- Confidence in refactoring
- Prevents regression
- Living documentation
