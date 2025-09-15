---
type: guidance
status: current
category: testing
---

# Rails Mocking Examples - Real Code Patterns

## Refactoring Over-Mocked Specs

### Before: Excessive Mocking
```ruby
# ❌ This is what we want to avoid
describe Seismic::AssetExporter do
  let(:asset_finder) { instance_double(AssetFinder) }
  let(:testimonial) { double('testimonial', identifier: 'test-123') }
  
  before do
    allow(AssetFinder).to receive(:new).and_return(asset_finder)
    allow(asset_finder).to receive(:find).and_return(testimonial)
    allow(testimonial).to receive_messages(
      account: account,
      render_attachment: double(download_file: double(url: 'test'))
    )
  end
end
```

### After: Using Real Objects
```ruby
# ✅ Better approach with real objects
describe Seismic::AssetExporter do
  let(:testimonial) { create(:renderable_testimonial, account: account) }
  let(:asset_finder) { AssetFinder.new }
  
  before do
    # Only mock the external Seismic API
    stub_request(:post, /api.seismic.com/)
      .to_return(status: 201, body: { id: 'seismic-123' }.to_json)
  end
  
  it 'exports the testimonial' do
    result = described_class.new(
      asset_type: 'RenderableTestimonial',
      asset_identifier: testimonial.identifier,
      account: account,
      seismic_client: Seismic::Client.new(account)
    ).call
    
    expect(result).to be_success
  end
end
```

## Common Rails Testing Patterns

### Testing Service Objects
```ruby
# app/services/user_onboarding_service.rb
class UserOnboardingService
  def initialize(user)
    @user = user
  end
  
  def call
    create_workspace
    send_welcome_email
    track_analytics
    Result.success(user: @user)
  end
end

# spec/services/user_onboarding_service_spec.rb
describe UserOnboardingService do
  let(:user) { create(:user) }
  subject(:service) { described_class.new(user) }
  
  # ✅ GOOD: Only mock external services
  before do
    allow(AnalyticsService).to receive(:track)
    allow(EmailService).to receive(:send_welcome)
  end
  
  it 'creates a workspace for the user' do
    expect { service.call }.to change(Workspace, :count).by(1)
    expect(user.workspace).to be_present
  end
  
  it 'sends welcome email' do
    service.call
    expect(EmailService).to have_received(:send_welcome).with(user)
  end
end
```

### Testing Controllers/Requests
```ruby
# ✅ GOOD: Request specs with real database
describe 'POST /api/testimonials' do
  let(:account) { create(:account) }
  let(:valid_params) do
    {
      testimonial: {
        text: 'Great product!',
        author_name: 'John Doe',
        author_company: 'Acme Corp'
      }
    }
  end
  
  before do
    sign_in account
    # Only stub external services
    stub_request(:post, /slack.com/).to_return(status: 200)
  end
  
  it 'creates a testimonial' do
    expect {
      post '/api/testimonials', params: valid_params
    }.to change(Testimonial, :count).by(1)
    
    expect(response).to have_http_status(:created)
    expect(json_response['text']).to eq('Great product!')
  end
end
```

### Testing Background Jobs
```ruby
# app/jobs/asset_export_job.rb
class AssetExportJob < ApplicationJob
  def perform(asset_id)
    asset = Asset.find(asset_id)
    ExportService.new(asset).export_to_seismic
  end
end

# spec/jobs/asset_export_job_spec.rb
describe AssetExportJob do
  let(:asset) { create(:file_asset) }
  
  # ✅ GOOD: Test with real models, mock external API
  before do
    stub_request(:post, /seismic.com/)
      .to_return(status: 201, body: { id: 'ext-123' }.to_json)
  end
  
  it 'exports the asset' do
    expect {
      described_class.perform_now(asset.id)
    }.to change { asset.reload.external_id }.from(nil).to('ext-123')
  end
  
  # ✅ GOOD: Test error handling
  context 'when export fails' do
    before do
      stub_request(:post, /seismic.com/).to_return(status: 500)
    end
    
    it 'raises an error for retry' do
      expect {
        described_class.perform_now(asset.id)
      }.to raise_error(ExportService::ExportError)
    end
  end
end
```

### Testing Models with Associations
```ruby
# ❌ BAD: Mocking associations
describe Testimonial do
  let(:testimonial) { build(:testimonial) }
  let(:account) { double('account', active?: true) }
  
  before do
    allow(testimonial).to receive(:account).and_return(account)
  end
end

# ✅ GOOD: Using real associations
describe Testimonial do
  let(:account) { create(:account, active: true) }
  let(:testimonial) { build(:testimonial, account: account) }
  
  it 'belongs to an active account' do
    expect(testimonial.account).to be_active
  end
end
```

## Testing External Integrations

### API Client Testing
```ruby
# app/services/seismic/client.rb
class Seismic::Client
  def fetch_workspaces
    response = HTTParty.get("#{base_url}/workspaces", headers: headers)
    handle_response(response)
  end
end

# spec/services/seismic/client_spec.rb
describe Seismic::Client do
  let(:client) { described_class.new(account) }
  
  describe '#fetch_workspaces' do
    # ✅ GOOD: Mock only the HTTP call
    before do
      stub_request(:get, 'https://api.seismic.com/workspaces')
        .with(headers: { 'Authorization' => 'Bearer token' })
        .to_return(
          status: 200,
          body: { workspaces: [{ id: 'ws-1', name: 'Sales' }] }.to_json
        )
    end
    
    it 'returns workspace data' do
      result = client.fetch_workspaces
      expect(result.first['name']).to eq('Sales')
    end
  end
end
```

### Using VCR for Real API Responses
```ruby
# ✅ GOOD: Record real API responses for consistency
describe 'Seismic Integration', :vcr do
  let(:client) { Seismic::Client.new(account) }
  
  it 'fetches real workspace data' do
    VCR.use_cassette('seismic_workspaces') do
      workspaces = client.fetch_workspaces
      expect(workspaces).to include(
        hash_including('name' => 'Sales Workspace')
      )
    end
  end
end
```

## Testing File Uploads

### Mocking File Storage
```ruby
# ✅ GOOD: Mock S3, use real ActiveStorage in test
describe FileUploadService do
  let(:file) { fixture_file_upload('test.pdf', 'application/pdf') }
  let(:service) { described_class.new(file) }
  
  context 'with S3 storage' do
    before do
      # Mock only the S3 upload
      allow(AWS::S3).to receive(:upload).and_return(true)
    end
    
    it 'stores file metadata' do
      result = service.upload
      expect(result.filename).to eq('test.pdf')
      expect(result.content_type).to eq('application/pdf')
    end
  end
  
  context 'with local storage in test' do
    it 'processes the file' do
      # No mocking needed - ActiveStorage uses local disk in test
      result = service.upload
      expect(result.blob).to be_present
    end
  end
end
```

## Testing Email Delivery

### ActionMailer Testing
```ruby
# ✅ GOOD: Use Rails built-in email testing
describe UserMailer do
  describe '#welcome_email' do
    let(:user) { create(:user, email: 'test@example.com') }
    let(:mail) { described_class.welcome_email(user) }
    
    it 'sends to the right recipient' do
      expect(mail.to).to eq(['test@example.com'])
    end
    
    it 'has the right subject' do
      expect(mail.subject).to eq('Welcome to Our App')
    end
    
    # No mocking needed - Rails handles test delivery
    it 'queues the email' do
      expect {
        mail.deliver_later
      }.to have_enqueued_mail(UserMailer, :welcome_email)
    end
  end
end
```

## Database Transaction Testing

### Testing Rollbacks
```ruby
# ✅ GOOD: Use real database transactions
describe PaymentProcessor do
  let(:order) { create(:order, total: 100) }
  let(:processor) { described_class.new(order) }
  
  context 'when payment fails' do
    before do
      # Only mock the payment gateway
      allow(Stripe::Charge).to receive(:create)
        .and_raise(Stripe::CardError.new('Card declined'))
    end
    
    it 'rolls back the order update' do
      expect {
        processor.process_payment
      }.to raise_error(Stripe::CardError)
      
      # Verify database state using real queries
      expect(order.reload.status).to eq('pending')
      expect(order.payment_transactions).to be_empty
    end
  end
end
```

## Performance-Sensitive Mocking

### When Mocking for Speed IS Acceptable
```ruby
describe TestimonialRenderer do
  let(:testimonial) { create(:testimonial) }
  
  context 'in unit tests' do
    # ✅ OK: Mock expensive operation in unit test
    before do
      allow(ImageMagick).to receive(:generate_image)
        .and_return(StringIO.new('fake image data'))
    end
    
    it 'includes testimonial text in render' do
      result = described_class.new(testimonial).render
      expect(result.metadata[:text]).to eq(testimonial.text)
    end
  end
  
  context 'in integration tests' do
    # ✅ Use real rendering in at least one integration test
    it 'generates a valid PNG', :slow do
      result = described_class.new(testimonial).render
      expect(result.content_type).to eq('image/png')
      expect(result.size).to be > 0
    end
  end
end
```

## Factory Best Practices

### Using Traits Effectively
```ruby
# spec/factories/testimonials.rb
FactoryBot.define do
  factory :testimonial do
    account
    text { 'Great product!' }
    author_name { 'John Doe' }
    
    trait :with_video do
      video_url { 'https://youtube.com/watch?v=123' }
    end
    
    trait :published do
      state { 'published' }
      published_at { 1.day.ago }
    end
  end
end

# spec/services/testimonial_publisher_spec.rb
describe TestimonialPublisher do
  # ✅ GOOD: Use factory traits for test scenarios
  let(:draft_testimonial) { create(:testimonial, state: 'draft') }
  let(:published_testimonial) { create(:testimonial, :published) }
  
  it 'publishes draft testimonials' do
    result = described_class.new(draft_testimonial).publish
    expect(draft_testimonial.reload).to be_published
  end
  
  it 'skips already published testimonials' do
    result = described_class.new(published_testimonial).publish
    expect(result).to be_skipped
  end
end
```

## Summary: The 80/20 Rule

**80% Real Objects:** Models, services, value objects
**20% Mocks:** External APIs, file storage, slow operations

This ratio ensures tests remain fast, reliable, and actually test your code's behavior rather than your mocking skills.