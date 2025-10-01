---
type: bundle
layer: practice
parent: practice/backend.md
context: External API integration development and testing
estimated_lines: 350
---
# Practice: Integrations

External API integration patterns, testing strategies, and implementation guidance.

## Parent Context
@../practice/backend.md

## API Integration Strategy

### Integration Architecture
@~/.claude/guidance/architecture/api-integration.md

Core principles for external API integration:
- Never guess API structure - use documentation only
- Document API thoroughly before implementation
- Test with curl/Postman before coding
- Ask for clarification when documentation is unclear

## Testing Strategies

### Integration Mocking Strategy
@../../testing/integration-mocking-guidelines.md

### General Mocking Guidelines
@../../testing/mocking-guidelines.md

### WebMock Patterns
@../../testing/webmock-patterns.md

Comprehensive patterns for simple API integrations:
- API-first development workflow
- Request stubbing patterns
- Error simulation
- Authentication testing

### VCR Cassette Recording
@../../testing/vcr-recording-workflow.md

Recording real API responses for complex integrations:
- Development credential loading
- Cassette recording process
- Sensitive data filtering
- Replay verification

### Mock Implementation Examples
@../../testing/rails-mocking-examples.md

Real-world examples of mocking patterns in Rails specs.

## Integration Testing

### Manual QA and Integration Testing
@../../testing/integration-manual-qa.md

Human testing strategies for verifying integrations beyond automated tests.

## Implementation Patterns

### Service Objects for Integrations
@../../rails/service-objects.md

Service layer patterns for encapsulating external API calls and business logic.

## Key Integration Principles

### API-First Development
1. Document endpoint thoroughly
2. Test with curl, save responses
3. Write specs matching real responses
4. Implement service with TDD
5. Verify against real API periodically

### Test Strategy Selection
- **WebMock**: Simple APIs, single-endpoint tests, predictable responses
- **VCR**: Complex APIs, multi-step flows, authentication sequences

### Error Handling
- Test network failures (timeout, connection refused)
- Test HTTP errors (401, 404, 429, 500)
- Test malformed responses
- Implement circuit breakers for failures
- Add comprehensive logging

### Authentication Patterns
- Mock authentication in unit tests
- Use real credentials with VCR for recording
- Filter sensitive data from cassettes
- Test token expiration and refresh

### Performance Considerations
- Implement retry logic with exponential backoff
- Handle rate limiting gracefully
- Cache responses when appropriate
- Monitor API call volumes
- Set appropriate timeouts
