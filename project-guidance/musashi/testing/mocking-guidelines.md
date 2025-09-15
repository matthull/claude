---
type: guidance
status: current
category: testing
---

# Mocking Guidelines for Rails/RSpec

## Core Principle: Mock at System Boundaries Only

### What to Mock
✅ **External APIs** - Third-party services (Seismic, Stripe, etc.)
✅ **File Storage** - S3, cloud storage, external file systems  
✅ **Network Calls** - HTTP requests, webhooks
✅ **Time-sensitive Operations** - Use Timecop for time-dependent tests
✅ **Expensive Operations** - Image processing, PDF generation (sparingly)

### What NOT to Mock
❌ **Your Own Models** - Use factories or fixtures
❌ **Your Own Services** - Use real instances with test data
❌ **ActiveRecord** - Use test database
❌ **Simple Collaborators** - Use real objects
❌ **Value Objects** - Too simple to mock

## Testing Patterns

### Good: Using Real Objects
```ruby
# ✅ GOOD - Using real service with fixture data
describe Seismic::AssetExporter do
  let(:account) { accounts(:main_account) }
  let(:asset_finder) { AssetFinder.new }  # Real instance
  let(:testimonial) { renderable_testimonials(:testimonial) }
  
  # Only mock the external API
  before do
    stub_request(:post, /api.seismic.com/)
      .to_return(status: 201, body: response.to_json)
  end
end
```

### Bad: Excessive Mocking
```ruby
# ❌ BAD - Mocking objects you own
describe Seismic::AssetExporter do
  let(:asset_finder) { instance_double(AssetFinder) }  # Don't mock this
  let(:testimonial) { double('testimonial') }  # Use real fixture
  
  before do
    allow(AssetFinder).to receive(:new).and_return(asset_finder)
    allow(asset_finder).to receive(:find).and_return(testimonial)
  end
end
```

## RSpec-Specific Guidelines

### Use WebMock for HTTP
```ruby
# External API calls
stub_request(:get, "https://api.external.com/data")
  .with(headers: { 'Authorization' => 'Bearer token' })
  .to_return(status: 200, body: fixture_file('external_response.json'))
```

### Use Factories Over Doubles
```ruby
# ✅ GOOD
let(:user) { create(:user, name: 'Test User') }
let(:account) { create(:account, user: user) }

# ❌ BAD  
let(:user) { double('user', name: 'Test User', id: 1) }
```

### Mock File Operations Sparingly
```ruby
# ✅ OK for external file systems
allow(AWS::S3).to receive(:upload_file).and_return(true)

# ❌ Avoid for local files - use tmp directory instead
File.write(Rails.root.join('tmp', 'test.txt'), 'content')
```

## Service Object Testing

### Test Through Public Interface
```ruby
describe UserRegistrationService do
  # ✅ GOOD - Test the actual service
  subject(:service) { described_class.new(params) }
  
  let(:params) { { email: 'test@example.com', name: 'Test' } }
  
  it 'creates a user' do
    expect { service.call }.to change(User, :count).by(1)
  end
  
  # Only mock external email service
  before do
    allow(EmailService).to receive(:send_welcome).and_return(true)
  end
end
```

## Request Spec Guidelines

### Integration Tests Should Be Integrated
```ruby
# ✅ GOOD - Real database, real models
describe 'POST /api/testimonials' do
  let(:account) { create(:account) }
  
  before do
    sign_in_as(account)
    # Only stub external Seismic API
    stub_request(:post, /seismic/).to_return(status: 201)
  end
  
  it 'creates a testimonial' do
    expect {
      post '/api/testimonials', params: valid_params
    }.to change(Testimonial, :count).by(1)
  end
end
```

## Common Anti-Patterns to Avoid

### 1. Mock Trains
```ruby
# ❌ BAD - Too many mocks chained
allow(user).to receive(:account).and_return(account)
allow(account).to receive(:settings).and_return(settings)
allow(settings).to receive(:enabled?).and_return(true)

# ✅ GOOD - Use real associations
user = create(:user, account: create(:account, settings_enabled: true))
```

### 2. Stubbing Implementation Details
```ruby
# ❌ BAD - Testing HOW not WHAT
expect(service).to receive(:validate_params)
expect(service).to receive(:process_data)
expect(service).to receive(:save_results)

# ✅ GOOD - Test behavior
result = service.call
expect(result).to be_success
expect(result.value).to eq(expected_data)
```

### 3. Over-Specifying Mocks
```ruby
# ❌ BAD - Too specific
expect(EmailService).to receive(:send)
  .with(exactly('test@example.com'))
  .once
  .and_return(true)

# ✅ GOOD - Just enough
allow(EmailService).to receive(:send).and_return(true)
# Then verify the outcome, not the call
```

## Testing Layers and Mocking

### Unit Tests (Models, Services)
- Minimal mocking - only external dependencies
- Use database transactions for speed
- Prefer factories to create test data

### Integration Tests (Request Specs)  
- Mock external APIs only
- Use real database and models
- Test full request/response cycle

### System Tests (Feature Specs)
- Mock as little as possible
- Maybe mock payment gateways or slow external services
- Focus on user experience

## Performance Considerations

### When Mocking for Speed IS Acceptable
```ruby
# ✅ OK - Expensive operation in unit test
context 'with rendered image' do
  before do
    # Mock only the expensive rendering, not the whole object
    allow(testimonial).to receive(:render_attachment)
      .and_return(double(download_file: double(url: 'test.png')))
  end
end
```

### But Prefer Real Operations in Integration Tests
```ruby
# Integration tests should use real operations when possible
# Use VCR for recording real API responses if needed
```

## Red Flags in Code Review

🚩 Mocking a model's associations
🚩 Using `double()` for domain objects
🚩 `allow_any_instance_of` (usually indicates design issue)
🚩 More than 3 mocks in a single test
🚩 Mocking ActiveRecord queries
🚩 Tests with more mock setup than actual test code

## Best Practices Summary

1. **Start with no mocks** - Add them only when necessary
2. **Mock at boundaries** - External services, not internal code
3. **Use real objects** - Factories and fixtures over doubles
4. **Test behavior** - Not implementation details
5. **Keep tests readable** - If mock setup dominates, refactor
6. **One mock per test** - Multiple mocks indicate wrong test level
7. **Verify assumptions** - Integration tests catch mock drift