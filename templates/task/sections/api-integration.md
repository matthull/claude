---
type: task-template
section: api-integration
description: API contracts, VCR cassettes, error handling, and HTTP client patterns
applies_to: api
source_guidance:
  global:
    - testing/test-driven-development
    - architecture/api-integration
    - api-development/doc-extraction-mandatory

## CRITICAL: Documentation Extraction Required (ABSOLUTE)

**You MUST NEVER implement API client without doc extraction**

**RATIONALE:** Guessing API specs = broken integration.

**You MUST ALWAYS:**
1. WebFetch the API documentation URL
2. Extract ALL specifications into template
3. Quote exact text from docs (no paraphrasing)
4. Show extraction BEFORE writing any code

**STOP if docs unavailable:** Request docs URL from user.

**Extraction Template** (complete BEFORE coding):
```markdown
**Doc URL**: [exact URL]
**HTTP Method**: [QUOTE from docs]
**Endpoint Path**: [QUOTE from docs]
**Content-Type**: [QUOTE from docs]
**Field Names**: [QUOTE exact field names]
```

---

## CRITICAL: API Security Requirements (ABSOLUTE)

**You MUST NEVER merge code without authentication and authorization**

**RATIONALE:** Unauthenticated/unauthorized access = data breach.

**You MUST ALWAYS verify**:
- ✅ Authentication required (before_action :authenticate_user!)
- ✅ Authorization checked (user owns/can access resource)
- ✅ Resource scoped to current user/account
- ✅ Strong parameters used (never permit!)

**You MUST NEVER**:
- ❌ Skip authentication checks
- ❌ Skip authorization checks
- ❌ Use client-side-only access control
- ❌ Trust client-provided data
- ❌ Write raw SQL queries
- ❌ Interpolate user input into SQL

**Authorization Pattern:**
```ruby
before_action :authenticate_user!
before_action :authorize_resource

def authorize_resource
  @resource = current_user.resources.find(params[:id])
end
```

---

## CRITICAL: Input Validation (ABSOLUTE)

**You MUST NEVER trust client data**

**RATIONALE:** SQL injection = complete database compromise.

**You MUST ALWAYS**:
- ✅ Use strong parameters
- ✅ Validate parameter types
- ✅ Sanitize string inputs
- ✅ Use ActiveRecord API (never raw SQL)

**You MUST NEVER**:
- ❌ Use `params.permit!`
- ❌ Write raw SQL with user input
- ❌ Use `find_by_sql` with user data
- ❌ Interpolate params into queries

---

## CRITICAL: Data Exposure Prevention (ABSOLUTE)

**You MUST NEVER expose sensitive data in API responses**

**You MUST verify jbuilder files don't expose**:
- ❌ Password hashes
- ❌ Internal IDs unnecessarily
- ❌ Admin-only fields
- ❌ Raw error messages
- ❌ Stack traces

**Error Handling:**
- ✅ Generic error messages publicly
- ✅ Detailed errors logged internally
- ✅ No database structure revealed
- ✅ No internal logic exposed

---

## CRITICAL: Client Method Testing (ABSOLUTE)

**You MUST NEVER add API client methods without dedicated tests**

**RATIONALE:** Untested client methods = broken API contracts + runtime failures.

**When adding methods to API clients, you MUST:**
- ✅ Write client spec FIRST (TDD red phase)
- ✅ Test success response handling
- ✅ Test each error status (404, 401, 422, 500)
- ✅ Use VCR cassettes for each scenario
- ✅ Verify request format matches API docs

**WRONG:**
```ruby
# Adding to services/seismic/client.rb
def update_file_version(id, file)
  # implementation
end
# ❌ No spec/services/seismic/client_spec.rb test
```

**CORRECT:**
```ruby
# spec/services/seismic/client_spec.rb
describe '#update_file_version' do
  it 'updates file version', :vcr do
    # Test the client method directly
  end

  it 'handles 404', :vcr do
    # Test error handling
  end
end
```

---

## API Integration Details

### API Contract

**Endpoint**: {HTTP_METHOD} `{API_ENDPOINT}`
**Auth**: Bearer {TOKEN_TYPE}

**Request**:
```json
{API_REQUEST_BODY_EXAMPLE}
```

**Response (200)**:
```json
{API_RESPONSE_BODY_EXAMPLE}
```

**Errors**: 401 (auth), 404 (not found), 422 (validation)

### VCR Cassettes

**Location**: `spec/vcr_cassettes/{service_name}/{scenario}.yml`

**Required**:
- `{scenario_1}.yml`
- `{scenario_2}.yml`
- `error_{status}.yml`

```ruby
VCR.use_cassette('{cassette_name}') do
  result = ApiClient.call(params)
  expect(result).to be_successful
end
```

**You MUST scrub sensitive data from cassettes.**

### Error Handling

```ruby
def handle_response(response)
  case response.status
  when 200 then SuccessResult.new(response.body)
  when 401 then refresh_token_and_retry
  when 404 then create_resource_or_error
  when 409 then update_existing(response)
  when 422 then raise ValidationError
  when 500 then raise ExternalServiceError
  end
end
```

### API Client Implementation Pattern

**HTTP Client Setup** (using Faraday, HTTParty, etc.):
```ruby
class ApiClient
  BASE_URL = '{API_BASE_URL}'

  def self.call(endpoint, method: :get, body: nil, headers: {})
    response = connection.public_send(method, endpoint) do |req|
      req.headers = default_headers.merge(headers)
      req.body = body.to_json if body
    end

    handle_response(response)
  end

  private

  def self.connection
    @connection ||= Faraday.new(url: BASE_URL) do |conn|
      conn.request :json
      conn.response :json
      conn.adapter Faraday.default_adapter
    end
  end

  def self.default_headers
    {
      'Authorization' => "Bearer #{access_token}",
      'Content-Type' => 'application/json'
    }
  end

  def self.handle_response(response)
    case response.status
    when 200..299
      SuccessResult.new(response.body)
    when 401
      handle_unauthorized
    when 404
      handle_not_found
    when 409
      handle_conflict(response)
    when 422
      handle_validation_error(response)
    else
      handle_error(response)
    end
  end
end
```

### Testing API Integrations

**Test Structure**:
```ruby
RSpec.describe ApiClient do
  describe '.call' do
    context 'when API returns success' do
      it 'returns parsed response', :vcr do
        VCR.use_cassette('api_success') do
          result = described_class.call('/endpoint')

          expect(result).to be_successful
          expect(result.data).to include({EXPECTED_KEYS})
        end
      end
    end

    context 'when API returns 404' do
      it 'handles not found', :vcr do
        VCR.use_cassette('api_not_found') do
          expect {
            described_class.call('/nonexistent')
          }.to raise_error(NotFoundError)
        end
      end
    end

    context 'when API returns 409 conflict' do
      it 'implements upsert pattern', :vcr do
        VCR.use_cassette('api_conflict') do
          result = described_class.call('/endpoint', method: :post, body: data)

          expect(result).to be_successful
          expect(result.data['id']).to eq(existing_id)
        end
      end
    end
  end
end
```

### API Discovery Documentation

**When integrating a new API**, document your findings:

**API Research**:
- **Documentation URL**: {API_DOCS_URL}
- **Authentication Method**: {AUTH_METHOD}
- **Rate Limits**: {RATE_LIMIT_INFO}
- **Sandbox/Test Environment**: {TEST_ENV_URL}

**Endpoints Discovered**:
```
GET    /api/v2/resources          - List resources
POST   /api/v2/resources          - Create resource
GET    /api/v2/resources/:id      - Get resource
PUT    /api/v2/resources/:id      - Update resource
DELETE /api/v2/resources/:id      - Delete resource
```

**Key Learnings**:
- {LEARNING_1}
- {LEARNING_2}
- {GOTCHA_1}
- {GOTCHA_2}

### API Security Checklist

**Before Completing Task**:
- [ ] **CRITICAL: API documentation fetched and extracted** (all 9 fields quoted)
- [ ] **CRITICAL: Implementation matches extracted specs exactly** (HTTP method, endpoint, content-type)
- [ ] **CRITICAL: Every new client method has dedicated tests** (with VCR cassettes)
- [ ] **CRITICAL: Authentication required** (before_action :authenticate_user!)
- [ ] **CRITICAL: Authorization verified** (resource scoped to current user)
- [ ] **CRITICAL: Strong parameters used** (never permit!)
- [ ] **CRITICAL: No raw SQL queries**
- [ ] **CRITICAL: No sensitive data in responses** (check jbuilder)
- [ ] **CRITICAL: Error messages sanitized** (no stack traces/internal details)
- [ ] Input validated server-side
- [ ] Client data never trusted
- [ ] Rate limits considered for sensitive endpoints

### Anti-patterns to Avoid

**You MUST NEVER**:
- ❌ **Implement API client without doc extraction** (must WebFetch and quote specs first)
- ❌ **Guess HTTP method from similar endpoints** (must quote from docs)
- ❌ **Add client methods without tests** (every client method needs specs)
- ❌ **Skip authentication checks**
- ❌ **Skip authorization checks**
- ❌ **Use `params.permit!`**
- ❌ **Write raw SQL queries**
- ❌ **Expose sensitive data in responses**
- ❌ **Trust client-provided data**
- ❌ Make real API calls in tests without VCR
- ❌ Commit API credentials (use ENV vars or Rails credentials)
- ❌ Ignore error responses (always handle 4xx/5xx)
- ❌ Retry indefinitely (implement max retries)
- ❌ Assume API contract won't change (validate responses)
- ❌ Parse response without checking status first
- ❌ Use `rescue => e` without re-raising or logging

**Prefer**:
- ✅ VCR for deterministic API testing
- ✅ Result objects over raising exceptions for expected errors
- ✅ Idempotent operations when possible
- ✅ Request/response logging for debugging
- ✅ Timeouts on all external requests
- ✅ Graceful degradation when API is unavailable
