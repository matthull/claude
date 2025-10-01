---
type: guidance
status: current
category: testing
tags:
- backend
- integrations
---

# WebMock Patterns for External API Testing

## Overview
Comprehensive patterns for stubbing external API requests using WebMock in RSpec tests. Based on established patterns in the codebase.

## API-First Integration Development Process

### 1. Document API
Create: `working-docs/projects/integrations/{service-name}/api-reference.md`

Document per endpoint:
- HTTP method and URL
- Headers (auth, content-type)
- Request body structure
- Response structure (success)
- Error formats and codes
- Rate limits, pagination

Example:
```markdown
# GET /api/v2/content/{id}
Headers:
  Authorization: Bearer {token}
  Accept: application/json

Response 200:
{"id": "123", "title": "Asset Title", "url": "https://..."}

Response 404:
{"error": "Content not found", "code": "CONTENT_NOT_FOUND"}
```

### 2. Validate with Curl
```bash
# working-docs/projects/integrations/{service-name}/curl-tests.sh

# Auth
curl -X POST https://api.example.com/auth/token \
  -H "Content-Type: application/json" \
  -d '{"client_id":"xxx","client_secret":"yyy"}' \
  > curl-responses/auth-token.json

# Success case
curl -X GET https://api.example.com/api/v2/content/123 \
  -H "Authorization: Bearer actual_token" \
  > curl-responses/content-fetch.json

# Error case
curl -X GET https://api.example.com/api/v2/content/nonexistent \
  -H "Authorization: Bearer actual_token" \
  > curl-responses/content-404.json
```

Save all responses. Test errors. Document discrepancies.

### 3. Write WebMock Specs
```ruby
describe 'External API Integration' do
  # From: curl-responses/content-fetch.json
  let(:content_response) do
    {
      "id" => "123",
      "title" => "Asset Title",
      "url" => "https://example.com/asset"
    }
  end

  before do
    # Matches curl response exactly
    stub_request(:get, "https://api.example.com/api/v2/content/123")
      .with(headers: { 'Authorization' => 'Bearer test_token' })
      .to_return(
        status: 200,
        body: content_response.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end
end
```

ALWAYS comment curl response source. Match exact structure.

### 4. TDD Implementation
1. Write failing spec
2. Implement service
3. Make spec pass
4. Verify against real API periodically

```ruby
class ExternalApiService
  def fetch_content(id)
    # Implementation
  end
end
```

### Critical Rule
**WebMocks MUST match curl responses exactly** - no guessing.

## Setup and Configuration

### Global Configuration (spec/spec_helper.rb)
```ruby
require 'webmock/rspec'

# Block all external requests by default, whitelist local services
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: ['elasticsearch', 'selenium:4444', 'web:4000', 'vite:3036']
)
```

## Core Stubbing Patterns

### Basic Request Stubbing
```ruby
# Simple GET request
stub_request(:get, "https://api.example.com/resource")
  .to_return(status: 200, body: { data: "value" }.to_json)

# POST with body and headers
stub_request(:post, "https://api.example.com/resource")
  .with(
    body: payload.to_json,
    headers: {
      'Content-Type' => 'application/json',
      'Authorization' => 'Bearer token'
    }
  )
  .to_return(
    status: 201,
    body: response.to_json,
    headers: { 'Content-Type' => 'application/json' }
  )
```

### Authentication Patterns

#### API Key Authentication
```ruby
stub_request(:post, url)
  .with(headers: { 'X-Api-Key' => api_key })
  .to_return(status: 200, body: response.to_json)
```

#### OAuth Token Flow
```ruby
# Token request
stub_request(:post, "https://auth.example.com/oauth/token")
  .with(
    body: {
      client_id: client_id,
      client_secret: client_secret,
      grant_type: 'client_credentials'
    }
  )
  .to_return(
    status: 200,
    body: {
      access_token: 'test_token',
      expires_in: 3600,
      token_type: 'Bearer'
    }.to_json
  )

# Authenticated API request
stub_request(:get, "https://api.example.com/resource")
  .with(headers: { 'Authorization' => 'Bearer test_token' })
  .to_return(status: 200, body: data.to_json)
```

## Error Simulation Patterns

### Network Errors
```ruby
# Timeout
stub_request(:get, url).to_timeout

# Connection refused
stub_request(:get, url).to_raise(Errno::ECONNREFUSED)

# Generic network error
stub_request(:get, url).to_raise(Net::OpenTimeout)
```

### HTTP Error Responses
```ruby
# 401 Unauthorized
stub_request(:get, url)
  .to_return(status: 401, body: { error: 'Unauthorized' }.to_json)

# 404 Not Found
stub_request(:get, url)
  .to_return(status: 404, body: { error: 'Not found' }.to_json)

# 429 Rate Limited with Retry-After
stub_request(:get, url)
  .to_return(
    status: 429,
    headers: { 'Retry-After' => '60' },
    body: { error: 'Rate limit exceeded' }.to_json
  )

# 500 Server Error
stub_request(:get, url)
  .to_return(status: 500, body: 'Internal Server Error')
```

### Malformed Responses
```ruby
# Invalid JSON
stub_request(:get, url)
  .to_return(status: 200, body: "not valid json{")

# Empty response
stub_request(:get, url)
  .to_return(status: 200, body: "")

# Unexpected content type
stub_request(:get, url)
  .to_return(
    status: 200,
    body: "<html>Not JSON</html>",
    headers: { 'Content-Type' => 'text/html' }
  )
```

## Advanced Patterns

### Sequential Responses
```ruby
# Different responses on successive calls
stub_request(:get, url)
  .to_return({ status: 500 }, { status: 200, body: data.to_json })
```

### Conditional Stubbing
```ruby
# Match specific query parameters
stub_request(:get, "https://api.example.com/search")
  .with(query: { q: 'test', page: '1' })
  .to_return(body: results.to_json)

# Match request body patterns
stub_request(:post, url)
  .with(body: hash_including({ required_field: 'value' }))
  .to_return(status: 201)

# Match header patterns
stub_request(:get, url)
  .with(headers: { 'Accept' => /application\/json/ })
  .to_return(body: data.to_json)
```

### Dynamic Response Generation
```ruby
stub_request(:post, url)
  .to_return do |request|
    body = JSON.parse(request.body)
    {
      status: 200,
      body: {
        echo: body,
        timestamp: Time.current.iso8601
      }.to_json
    }
  end
```

## Request Verification

### Basic Verification
```ruby
# Verify request was made
expect(WebMock).to have_requested(:post, url)

# Verify with specific parameters
expect(WebMock).to have_requested(:post, url)
  .with(
    body: expected_payload.to_json,
    headers: { 'Content-Type' => 'application/json' }
  )

# Verify number of times
expect(WebMock).to have_requested(:get, url).times(3)

# Verify no request was made
expect(WebMock).not_to have_requested(:delete, url)
```

### Advanced Verification
```ruby
# Verify with block
expect(WebMock).to have_requested(:post, url) do |request|
  JSON.parse(request.body)['field'] == 'expected_value'
end

# Get request history
WebMock::RequestRegistry.instance.requested_signatures
```

## Testing Helpers

### Reusable Stub Methods
```ruby
# In spec/support/api_test_helpers.rb
module ApiTestHelpers
  def stub_successful_api_response(endpoint, response_data)
    stub_request(:get, "#{api_base_url}/#{endpoint}")
      .with(headers: standard_headers)
      .to_return(
        status: 200,
        body: response_data.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def stub_api_error(endpoint, status, error_message)
    stub_request(:get, "#{api_base_url}/#{endpoint}")
      .to_return(
        status: status,
        body: { error: error_message }.to_json
      )
  end

  def stub_paginated_response(endpoint, items, page: 1, per_page: 20)
    stub_request(:get, "#{api_base_url}/#{endpoint}")
      .with(query: { page: page, per_page: per_page })
      .to_return(
        status: 200,
        body: {
          data: items,
          pagination: {
            page: page,
            per_page: per_page,
            total: items.count
          }
        }.to_json
      )
  end
end

RSpec.configure do |config|
  config.include ApiTestHelpers, type: :request
end
```

### Context-Specific Helpers
```ruby
# Authentication context
shared_context "authenticated api request" do
  before do
    stub_request(:post, "#{auth_url}/token")
      .to_return(body: { access_token: 'test_token' }.to_json)
  end
end

# Error scenarios context
shared_context "api error responses" do
  let(:stub_timeout) do
    stub_request(:any, /api\.example\.com/).to_timeout
  end

  let(:stub_server_error) do
    stub_request(:any, /api\.example\.com/)
      .to_return(status: 500)
  end
end
```

## Best Practices

### Organization
- Group related stubs in `before` blocks
- Use `let` blocks for reusable stub definitions
- Create helpers for common patterns
- Use shared contexts for common scenarios

### Safety
- Always disable net connect in test environment
- Whitelist only necessary local services
- Verify critical requests were made correctly
- Clear stubs between tests if needed: `WebMock.reset!`

### Performance
- Stub at the HTTP level, not the client level
- Reuse stub definitions across tests
- Avoid over-stubbing (stub only what's needed)

### Clarity
- Use descriptive variable names for URLs and payloads
- Document why specific responses are stubbed
- Group stubs logically by service or feature
- Keep stub data close to test assertions

## Common Pitfalls to Avoid

1. **Not matching exact URLs** - Include protocol, params, and trailing slashes
2. **Forgetting headers** - Many APIs require specific headers
3. **Wrong content type** - Match the actual API's content type
4. **Over-specific matching** - Don't match on irrelevant details
5. **Not handling errors** - Always test error scenarios
6. **Stub leakage** - Clean up or scope stubs appropriately

## Integration with Time-Sensitive Tests

```ruby
# Use with Timecop for consistent time-based testing
Timecop.freeze do
  expire_time = 1.hour.from_now

  stub_request(:post, token_url)
    .to_return(
      body: {
        access_token: 'token',
        expires_at: expire_time.iso8601
      }.to_json
    )

  # Test token expiration logic
end
```
