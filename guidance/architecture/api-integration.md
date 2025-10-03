---
type: guidance
status: current
category: architecture
focus_levels:
- strategic
- design
tags:
- architecture
- api
---

# API Integration Patterns

## Core Principles

### Never Guess API Structure
- **NEVER** guess structure or parameters for API calls
- **ALWAYS** use only what's in provided documentation
- **ASK** user for help when documentation is unclear or missing
- Guessing API structures is a waste of time - you'll never get it right

### Documentation-First Approach
- Read API documentation thoroughly before implementation
- Verify endpoint URLs, HTTP methods, and required headers
- Check authentication requirements and rate limits
- Understand request/response formats (JSON, XML, etc.)
- Note any versioning requirements

### Required Information Before Coding
Before making any API call, confirm:
1. **Endpoint URL** - Full URL including protocol and path
2. **HTTP Method** - GET, POST, PUT, DELETE, PATCH, etc.
3. **Headers** - Content-Type, Authorization, API keys
4. **Request Body** - Exact structure and required fields
5. **Response Format** - Expected response structure and status codes
6. **Error Handling** - Error response formats and meanings

### Implementation Strategy
```
1. Gather documentation
2. Ask for clarification on ambiguities
3. Build minimal test request
4. Verify response structure
5. Implement error handling
6. Add retry logic if appropriate
```

## Common Pitfalls to Avoid

### Never Assume
- Parameter names or casing (userId vs user_id vs UserID)
- Nested object structures
- Array vs single object responses
- Optional vs required fields
- Default values or behaviors
- Rate limiting strategies

### Always Verify
- Authentication method (Bearer token, API key, OAuth, etc.)
- Where credentials go (header, query param, body)
- Data types (strings vs numbers vs booleans)
- Date/time formats (ISO 8601, Unix timestamp, etc.)
- Pagination mechanisms
- Filtering and sorting parameters

## When Documentation Is Missing

### Ask User For
- Example requests/responses from their testing
- Postman collections or cURL commands that work
- API documentation links
- Contact with API provider for clarification
- Any existing integration code to reference

### Never
- Guess based on "common patterns"
- Try multiple variations hoping one works
- Make assumptions based on similar APIs
- Implement without clear specifications

## Testing External APIs

<!-- @.claude/guidance/testing/vcr-recording-workflow.md - Project-specific, not available in global guidance -->

### Use Tools First
- Test with cURL or Postman before coding
- Verify responses match documentation
- Check edge cases and error conditions
- Confirm rate limits and throttling

### Implementation Testing
- Start with hardcoded test data
- Add logging for all requests/responses
- Implement circuit breakers for failures
- Test timeout and retry scenarios
- Do end-to-end testing (e.g. via rails console) of ruby methods that implement API calls after the unit tests pass

## Key Takeaway
Time spent understanding API documentation and asking clarifying questions is never wasted. Time spent guessing API structures always is. When in doubt, ask the user for help or examples rather than making assumptions.
