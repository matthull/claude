---
type: guidance
status: current
category: rails
---

# Backend Testing Patterns

## RSpec Configuration

### Test Types and Locations
- Models: `spec/models/`
- Services: `spec/services/`
- Jobs: `spec/jobs/`
- Request specs: `spec/requests/`
- Avoid controller specs - use request specs instead

### Running Tests
- Full suite: `docker exec musashi-web-1 bundle exec rspec`
- Single file: `docker exec musashi-web-1 bundle exec rspec path/to/spec.rb`
- Single test: `docker exec musashi-web-1 bundle exec rspec path/to/spec.rb:LINE_NUMBER`
- TDD workflow: `docker exec -ti musashi-web-1 bundle exec guard`

## Request Spec Organization

### File Location and Naming
- **One request spec file per controller**
- Location mirrors controller path: `spec/requests/{controller_path}_spec.rb`
- Examples:
  - `app/controllers/app/api/v2/seismic_controller.rb` → `spec/requests/app/api/v2/seismic_controller_spec.rb`
  - `app/controllers/admin/api/users_controller.rb` → `spec/requests/admin/api/users_controller_spec.rb`
  - `app/controllers/app/api/content_assets_controller.rb` → `spec/requests/app/api/content_assets_controller_spec.rb`
- **Never** create multiple spec files for one controller
- **Never** use endpoint-based spec organization (e.g., `seismic_settings_spec.rb`)

### Contract Tests
- Define API contracts before implementation (TDD red phase)
- Test request/response shapes match expected contracts
- Include all required fields in response expectations
- Test error response formats consistently

## Request Spec Patterns

### Structure
- Use Arrange-Act-Assert with newline separations
- Group related tests in contexts
- Test one behavior per example
- Use Rails path helpers, not hardcoded strings

### Coverage Areas
- Happy path for each endpoint
- Parameter validation
- Authorization rules
- Error conditions
- Response structure
- Status codes
- Pagination
- Includes/associations

### Response Testing
- Avoid one spec per attribute
- Test complete response structure in single spec
- Verify JSON structure matches jbuilder
- Check for N+1 queries
- Test with realistic data volumes

## Model Testing

### What to Test
- Validations with valid and invalid data
- Associations configuration
- Scopes return expected results
- Callbacks that contain logic
- Custom methods
- Database constraints

### Fixture Usage
- Fixtures are automatically loaded
- Use `let` to expose fixtures
- Example: `let(:user) { users(:main_user) }`
- See fixture-based-testing.md for details

## Service Object Testing

### Test Structure
- Test public interface (usually `call` or `perform`)
- Mock external dependencies
- Test success and failure paths
- Verify side effects
- Test transaction rollback

### Edge Cases
- Invalid input handling
- External service failures
- Concurrent execution
- Partial completion scenarios
- Resource cleanup

## Background Job Testing

### Job Behavior
- Test job execution logic
- Mock external API calls
- Test retry behavior
- Verify idempotency
- Test failure scenarios

### Job Scheduling
- Test that jobs are enqueued
- Verify job parameters
- Test scheduled vs immediate execution
- Check queue routing

## Performance Considerations

### Test Speed
- Full suite is 10+ minutes - too slow for regular runs
- Identify specific spec files relevant to changes
- Use focused runs during development
- Profile slow specs when modifying

### Optimization Tips
- Use fixtures over factories
- Avoid database hits when possible
- Use `build` instead of `create`
- Mock expensive operations
- Clean up after tests

## CI/CD Integration

### GitHub Actions
- Tests run in parallel (4 jobs)
- Named: `test(4, 0)`, `test(4, 1)`, etc.
- Check failures: `gh run list --branch branch-name --workflow Rspec --status failure`
- View logs: `gh run view RUN_ID --log-failed`

### Required Checks
- All specs must pass
- No N+1 queries (bullet gem)
- Coverage thresholds met
- Rubocop linting passes

## Common Patterns

### Testing APIs
- Test request/response cycle
- Verify authentication
- Check authorization
- Test pagination
- Validate error responses

### Testing Validations
- Test presence validations
- Test uniqueness with database
- Test format validations
- Test conditional validations
- Test custom validators

### Testing Associations
- Test has_many relationships
- Test belongs_to requirements
- Test dependent destroy behavior
- Test through associations
- Test polymorphic associations

## Anti-patterns to Avoid

### Test Smells
- Testing private methods directly
- Over-mocking leading to false positives
- Testing framework behavior
- Shared examples that obscure intent
- Tests requiring specific order

### Performance Issues
- Using factories when fixtures exist
- Not cleaning up test data
- Loading unnecessary associations
- Creating too much test data
- Running all tests for small changes