---
type: guidance
status: current
category: testing
tags:
  - integrations
  - testing
  - api-client
focus_levels:
  - implementation
---

# API Client Testing Patterns

## Test Setup

### Build Over Create
- Use `build(:factory)` instead of `create`
- Stub `save!` and `update!` methods
- Avoid database roundtrips in API tests

### Direct State Setting
```ruby
client.instance_variable_set(:@access_token, 'valid_token')
client.instance_variable_set(:@token_expires_at, 1.hour.from_now)
```

### Shared Contexts
- Extract common setup to shared contexts
- Use `include_context 'authenticated client'`

## Authentication

### Stub Auth in Non-Auth Tests
```ruby
before do
  allow(client).to receive(:ensure_authenticated!).and_return(true)
  allow(client).to receive(:authenticated?).and_return(true)
  client.instance_variable_set(:@access_token, 'valid_token')
  client.instance_variable_set(:@token_expires_at, 1.hour.from_now)
end
```

### Test All Auth States
- Valid token
- Expired token
- Missing token

### Test Auth Errors
- 401 → AuthenticationError
- Network timeout → AuthenticationError with /Network error/
- Invalid credentials → Specific error message

## Response Validation

### Multi-Level Assertions
```ruby
# 1. Type check
expect(result).to be_an(Array)

# 2. Size validation
expect(result.length).to be > 0

# 3. Structure check
expect(result.first).to have_key('id')
expect(result.first).to have_key('name')

# 4. Content validation
expect(result['id']).to eq('expected-id')
```

### Return Type First
- Always check return type before accessing fields
- Use `be_a(Hash)`, `be_an(Array)`, `be_a(String)`

### Document API Limitations
```ruby
# NOTE: This endpoint does NOT return rootFolderId
# For that, use GET /teamsites/{id}
```

## Error Handling

### Specific Error Classes
- 400 → ApiError
- 401 → AuthenticationError
- 403 → ApiError (or PermissionError)
- 404 → NotFoundError
- 409 → Special handling (see below)
- 413 → ApiError
- 429 → RateLimitError
- 500 → ApiError

### Match Error Messages with Regex
```ruby
expect { ... }.to raise_error(Seismic::Client::NotFoundError, /not found/)
```

### Network Errors
```ruby
stub_request(:post, url).to_timeout

expect { client.method }.to raise_error(AuthenticationError, /Network error/)
```

### Graceful Degradation
- **GET operations**: Return `nil` on 404
- **Non-critical writes**: Return `false` on failure
- **Critical operations**: Raise specific error

## HTTP Status Codes

### Test All Relevant Statuses
- 200/201: Success paths
- 400: Bad request (invalid params)
- 401: Unauthorized (auth failure)
- 403: Forbidden (permission issues)
- 404: Not found
- 409: Conflict (idempotency)
- 413: Payload too large (uploads)
- 429: Rate limited
- 500: Server error

### 409 Conflict Idempotency
```ruby
context 'when resource already exists (409 conflict)' do
  let(:conflict_response) do
    { 'error' => 'Already exists', 'existingId' => 'existing-123' }
  end

  before do
    stub_request(:post, url).to_return(status: 409, body: conflict_response.to_json)
  end

  it 'returns existing resource ID instead of raising error' do
    result = client.create_resource(params)
    expect(result).to eq('existing-123')
  end
end
```

## WebMock Patterns

### Header Matching
```ruby
# Exact match
stub_request(:post, url)
  .with(
    headers: {
      'Authorization' => 'Bearer valid_token',
      'Content-Type' => 'application/json'
    },
    body: payload.to_json
  )

# Regex match
stub_request(:post, url)
  .with(headers: { 'Authorization' => /Bearer/ })
```

### Block Matchers for Complex Requests
```ruby
stub_request(:post, url)
  .with(headers: { 'Authorization' => 'Bearer valid_token' }) do |request|
    request.headers['Content-Type']&.include?('multipart/form-data') &&
      request.body.include?('Content-Disposition: form-data; name="metadata"')
  end
```

### URL Regex Matching
```ruby
stub_request(:get, %r{https://api\.example\.com/.*/items})
```

### Verify Requests Made
```ruby
expect(WebMock).to have_requested(:post, expected_url)
```

## VCR Strategy

### Hybrid Approach
- **VCR cassettes**: Happy path with real API
- **WebMock stubs**: Error scenarios and edge cases

### Environment-Based Tokens
```ruby
before do
  token = ENV['API_VCR_TOKEN'] || 'test_token'
  client.instance_variable_set(:@access_token, token)
  client.instance_variable_set(:@token_expires_at, 1.hour.from_now)
end
```

### Document Cassette Dependencies
```ruby
# NOTE: content_id from 'upload_file_success' cassette (d4576ec5-...)
# To re-record: First re-record upload_file_success.yml, then update this ID
let(:content_id) { 'd4576ec5-cc45-4d5a-a346-58abb33a0be6' }
```

### VCR Helpers for Dynamic Data
```ruby
name: "Test Asset #{vcr_timestamp}"
parent_folder_id: vcr_folder_id
external_id: "asset-#{vcr_timestamp}"
```

## Test Data

### Real Files for Uploads
```ruby
# Temp files (modify/delete)
before do
  FileUtils.mkdir_p(File.dirname(file_path))
  File.write(file_path, 'test content')
end

after do
  FileUtils.rm_f(file_path)
end

# Fixtures (read-only)
let(:pdf_path) { Rails.root.join('spec/fixtures/files/sample.pdf') }
```

### Test Minimal and Full Params
```ruby
context 'with minimal metadata' do
  it 'works with empty metadata hash' do
    result = client.upload_file(folder_id, file_path, {})
    expect(result).to be_a(Hash)
  end
end

context 'with full metadata' do
  let(:metadata) { { externalId: 'ue-123', description: 'Test' } }
  # ...
end
```

### Configuration Errors
```ruby
context 'with missing required config' do
  it 'raises ConfigurationError before API call' do
    client_without_config = described_class.new(invalid_integration)
    expect { client_without_config.method }.to raise_error(
      ConfigurationError,
      /Config not set/
    )
  end
end
```

## Edge Cases

### Empty Data
```ruby
it 'accepts empty array' do
  result = client.add_properties(content_id, [])
  expect(result).to be true
end
```

### Missing Resources
```ruby
it 'raises error for missing file' do
  expect { client.upload_file(folder_id, 'nonexistent.pdf', {}) }
    .to raise_error(ApiError, /File not found/)
end
```

### Token Expiration
```ruby
it 'sets token expiration time' do
  Timecop.freeze do
    client.authenticate!
    expected = Time.current + 3600
    expect(client.token_expires_at).to be_within(1.second).of(expected)
  end
end
```

## Test Organization

### Context Grouping
```ruby
describe '#method_name' do
  context 'with successful operation' do
    # Happy path
  end

  context 'with minimal parameters' do
    # Optional params omitted
  end

  context 'when resource not found (404)' do
    # Error scenario
  end

  context 'with server error (500)' do
    # Error scenario
  end
end
```

### Descriptive Test Names
- ✅ "uploads file with correct multipart structure and returns response hash"
- ✅ "returns existing folder ID instead of raising error"
- ✅ "filters out non-folder items and returns only folders"
- ❌ "it works"
- ❌ "returns result"

### Separate Error Handling Blocks
```ruby
describe 'error handling' do
  before do
    # Common auth setup
  end

  context 'with rate limiting' do
    # 429 handling
  end

  context 'with server errors' do
    # 500 handling
  end
end
```

## Testing Checklist

### Setup
- [ ] Use `build` instead of `create`
- [ ] Stub authentication appropriately
- [ ] Set up fixtures or temp files

### Happy Path
- [ ] Test successful response (200/201)
- [ ] Validate response type and structure
- [ ] Test minimal required parameters
- [ ] Test full parameter set

### Error Scenarios
- [ ] 400 Bad Request
- [ ] 401 Unauthorized
- [ ] 403 Forbidden
- [ ] 404 Not Found
- [ ] 409 Conflict (if applicable)
- [ ] 413 Payload Too Large (uploads)
- [ ] 429 Rate Limited
- [ ] 500 Internal Server Error
- [ ] Network timeout/error

### Edge Cases
- [ ] Empty response data
- [ ] Missing configuration
- [ ] Missing files (uploads)
- [ ] Token expiration
- [ ] Invalid input data

### Test Quality
- [ ] Descriptive test names
- [ ] Grouped contexts
- [ ] VCR cassette documentation
- [ ] Appropriate matchers (`be_within` for times, regex for errors)
- [ ] Request verification (`have_requested`)
- [ ] Hybrid VCR/WebMock strategy
