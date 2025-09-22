---
type: guidance
status: current
category: testing
---

# Testing Strategy Overview

## Testing Layers

### Unit Tests
- Rails: RSpec for models, services, jobs
- Frontend: Vitest for utilities, composables, and services (NOT Vue components)
- Fast, isolated, numerous
- Run in Docker containers

### Integration Tests
- Rails: Request specs for API endpoints
- Frontend: Storybook stories serve as component integration tests
- Verify layer boundaries and contracts
- Ensure data flows correctly

### Visual Tests
- Storybook for component testing and documentation
- Puppeteer for browser automation
- Screenshot comparison for regression
- Manual review for UX quality

### End-to-End Tests
- Puppeteer for critical user journeys
- Verify full stack functionality
- Test external integrations
- Simulate real user behavior

## Coordination Points

### Model-View-Controller
- Backend model changes affect Storybook stories
- API contract changes require frontend test updates
- Database schema changes impact fixtures
- Keep test data synchronized across layers

### Implementation Workflow
1. Backend implementation with RSpec tests
2. API endpoint testing with request specs
3. Frontend implementation with Storybook stories (component tests)
4. Vitest for non-component JavaScript/TypeScript code
5. Puppeteer regression testing
6. Manual QA verification

## Testing Principles

### Test Coverage Requirements
- All new code must have tests
- Modified code needs updated tests
- Critical paths need multiple test layers
- Regression tests for bug fixes

### Mocking Guidelines
- **Only mock at system boundaries** - External APIs, not your own code
- **Use real objects** - Factories and fixtures over doubles
- **See detailed guidance:** 
  - `@.claude/guidance/testing/mocking-guidelines.md` - Core principles
  - `@.claude/guidance/testing/rails-mocking-examples.md` - Rails patterns

### Test Execution Environment
- All tests run inside Docker containers
- Consistent environment across team
- Matches production configuration
- Isolated from host system

### Quality Gates
- Tests must pass before merging
- Linting must pass
- Storybook stories must render
- No regression in screenshots
- Manual QA approval for UX changes

## When to Use Each Test Type

### Backend Testing (RSpec)
- Model validations and business logic
- Service object operations
- Background job processing
- API endpoint contracts

### Frontend Testing
**Storybook (Vue Components):**
- Component behavior and props
- User interactions
- Visual states and variations
- Responsive design

**Vitest (Non-Component Code):**
- Utility functions
- Composables
- Store modules
- API services

### Integration Testing (Puppeteer)
- User workflows
- Cross-system features
- External API interactions
- Visual regression

### Manual Testing
- Exploratory testing
- UX quality assessment
- Edge case discovery
- Performance perception