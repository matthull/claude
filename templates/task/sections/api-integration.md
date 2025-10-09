---
type: task-template
section: api-integration
description: API contracts, VCR cassettes, error handling, and HTTP client patterns
applies_to: api
source_guidance:
  global:
    - testing/test-driven-development
    - architecture/api-integration
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

## API Integration Details

### API Contract

**Service**: {API_SERVICE_NAME}
**Endpoint**: {HTTP_METHOD} `{API_ENDPOINT}`

**Request Headers**:
```
Authorization: Bearer {TOKEN_TYPE}
Content-Type: application/json
{ADDITIONAL_HEADERS}
```

**Request Body**:
```json
{API_REQUEST_BODY_EXAMPLE}
```

**Expected Response**:
```json
{API_RESPONSE_BODY_EXAMPLE}
```

**Status Codes**:
- `200 OK`: {SUCCESS_DESCRIPTION}
- `201 Created`: {CREATION_DESCRIPTION}
- `204 No Content`: {NO_CONTENT_DESCRIPTION}
- `400 Bad Request`: {BAD_REQUEST_DESCRIPTION}
- `401 Unauthorized`: {AUTH_FAILURE_DESCRIPTION}
- `404 Not Found`: {NOT_FOUND_DESCRIPTION}
- `409 Conflict`: {CONFLICT_DESCRIPTION}
- `422 Unprocessable Entity`: {VALIDATION_FAILURE_DESCRIPTION}
- `500 Server Error`: {SERVER_ERROR_DESCRIPTION}

### VCR Cassette Evidence

**You MUST record real API interactions with VCR cassettes**

**Cassette Location**:
```
spec/vcr_cassettes/{service_name}/{endpoint_name}/{scenario}.yml
```

**Required Cassettes**:
- [ ] `{scenario_1}.yml` - {DESCRIPTION}
- [ ] `{scenario_2}.yml` - {DESCRIPTION}
- [ ] `error_{status_code}.yml` - {ERROR_SCENARIO_DESCRIPTION}

**VCR Configuration**:
```ruby
# In spec file
VCR.use_cassette('{cassette_name}') do
  # API call happens here
  result = ApiClient.call(params)
  expect(result).to be_successful
end
```

**Recording New Cassettes**:
```bash
# Delete old cassette
rm spec/vcr_cassettes/{path}/{cassette_name}.yml

# Run test with real API credentials
# VCR will record the interaction
bundle exec rspec spec/{path}/{file}_spec.rb

# Verify cassette was created
ls -la spec/vcr_cassettes/{path}/
```

**Cassette Verification Checklist**:
- [ ] Cassette contains expected request (method, URL, body)
- [ ] Cassette contains expected response (status, body)
- [ ] Sensitive data scrubbed (tokens, passwords, API keys)
- [ ] Cassette committed to git
- [ ] Test passes with cassette (no real API call)

### Error Handling Patterns

**Common HTTP Error Scenarios**:

#### 401 Unauthorized (Token Expired/Invalid)
```ruby
def handle_unauthorized_response
  # Refresh token and retry
  refresh_access_token
  retry_request
end
```

#### 404 Not Found (Resource Doesn't Exist)
```ruby
def handle_not_found
  # Create resource if appropriate
  # OR return meaningful error to caller
  create_resource if should_create?
end
```

#### 409 Conflict (Resource Already Exists)
```ruby
def handle_conflict_response(response)
  # Implement upsert pattern
  existing_id = extract_id_from_conflict(response)
  update_existing_resource(existing_id)
end
```

#### 422 Unprocessable Entity (Validation Error)
```ruby
def handle_validation_error(response)
  # Parse validation errors
  errors = JSON.parse(response.body)['errors']

  # Map to local validation or raise meaningful error
  raise ValidationError, format_errors(errors)
end
```

#### 500 Server Error (External Service Down)
```ruby
def handle_server_error
  # Log error for investigation
  Rails.logger.error("API server error: #{response.body}")

  # Retry with exponential backoff OR
  # Queue for later processing OR
  # Return error to user
  raise ExternalServiceError, "Service temporarily unavailable"
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
