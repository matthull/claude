---
type: bundle
layer: practice
parent: domain/coding.md
context: Musashi testing practices and QA workflows
estimated_lines: 350
---
# Practice: Testing (Musashi)

Musashi-specific testing patterns and QA workflows.

## Global Testing Foundation
@~/.claude/guidance/bundles/practice/testing.md

## Musashi Testing Architecture

### Testing Patterns
All project-specific testing patterns and guidelines:
@../../testing/testing-strategy.md
@../../testing/integration-manual-qa.md
@../../testing/mocking-guidelines.md
@../../testing/rails-mocking-examples.md
@../../testing-patterns.md
@../../puppeteer.md

### Backend Testing
Rails-specific testing patterns:
@../../rails/backend-testing.md
@../../rails/fixture-based-testing.md

### Frontend Testing
Vue.js testing patterns:
@../../vue/frontend-testing.md

### Key Testing Decisions
- RSpec for Ruby/Rails testing
- Vitest for JavaScript/Vue testing
- Fixtures over factories for performance
- Request specs over controller specs
- Puppeteer for browser automation
- Manual QA regression testing with screenshots

### Test Organization
- Unit tests for models and services
- Request specs for API endpoints
- Component tests for Vue components
- Integration tests for critical user flows
- Regression tests with visual comparison

### Performance Considerations
- Fixture-based testing for speed
- Selective test runs for large changes
- Parallel test execution in CI
- Test profiling and optimization

### QA Workflows
- Pre-development baseline screenshots
- Post-development verification
- Visual regression testing
- Manual testing for UX changes
- Automated browser testing with Puppeteer