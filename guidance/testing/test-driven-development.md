---
type: guidance
status: current
category: testing
tags:
- testing
focus_levels:
- implementation
---

# Test-Driven Development

## TDD Cycle
1. **RED**: Write failing test
2. **GREEN**: Minimal code to pass
3. **REFACTOR**: Improve keeping tests green

## Cycle Rules
- 5-10 minutes maximum per cycle
- Commit after each green state
- Auto-run tests on save
- One logical assertion per test

## Testing Pyramid
- **Unit (70%)**: < 1ms each
- **Integration (20%)**: < 100ms each
- **E2E (10%)**: < 5s each
- Full suite: < 10 minutes

## Test Structure (AAA)
```
# Arrange - Setup
user = create(:user)

# Act - Execute
result = service.perform

# Assert - Verify
expect(result).to be_success
```

## When to Use Each Level

### Unit Tests
- Individual functions
- Business logic
- Data transformations
- Edge cases

### Integration Tests
- API endpoints
- Database interactions
- Service boundaries
- External mocking

### E2E Tests
- Critical user workflows
- Payment flows
- Authentication
- Cross-system operations

## Test Doubles
- **Stubs**: Canned responses
- **Mocks**: Verify interactions
- **Spies**: Record calls
- **Fakes**: Simplified implementations

## Mocking Rules
- Mock at system boundaries
- Don't mock what you own
- Prefer real objects
- Verify with integration tests

## What to Test
- Public interfaces
- Business logic
- Edge cases/errors
- Integration points
- Security boundaries

## What NOT to Test
- Framework code
- Simple getters/setters
- Third-party libraries
- Private methods directly
- Implementation details

## Test Quality (FIRST)
- **Fast**: Milliseconds for units
- **Isolated**: No dependencies
- **Repeatable**: Same result
- **Self-validating**: Clear pass/fail
- **Timely**: Written with code

## Anti-patterns
- NEVER: Test multiple behaviors per test
- NEVER: Depend on execution order
- NEVER: Use hardcoded test data
- NEVER: Allow flaky tests
- NEVER: Write tests without assertions
- NEVER: Test private methods directly