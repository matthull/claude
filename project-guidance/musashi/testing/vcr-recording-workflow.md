---
type: guidance
status: current
category: testing
---

# VCR Cassette Recording for Seismic API

## Quick Start

Run the rake task for complete workflow instructions:

```bash
docker exec musashi-web-1 bundle exec rake seismic:vcr:token
```

The task outputs:
- **STDOUT**: The access token (capture with `$()`)
- **STDERR**: Complete workflow instructions

## Test Pattern

Tests must use `ENV['SEISMIC_VCR_TOKEN']` with fallback to mock token:

```ruby
describe '#some_seismic_method' do
  before do
    # Use ENV token when recording, fallback to mock for replay
    token = ENV['SEISMIC_VCR_TOKEN'] || 'test_token'
    expiry = 1.hour.from_now

    # Set token directly - client.authenticated? will return true, so no auth needed
    client.instance_variable_set(:@access_token, token)
    client.instance_variable_set(:@token_expires_at, expiry)
  end

  it 'does something', :vcr do
    VCR.use_cassette('seismic/cassette_name') do
      result = client.some_seismic_method
      # assertions...
    end
  end
end
```

## How It Works

1. **Development DB**: Rake task fetches valid token from dev database `SeismicIntegration`
2. **Token Injection**: Token passed via `ENV['SEISMIC_VCR_TOKEN']` during test run
3. **Real API Call**: Test makes real API call with valid token, VCR records it
4. **Auto-Filtering**: VCR `before_record` hook filters all sensitive data
5. **Replay**: Subsequent runs use cassette, no token needed (falls back to `'test_token'`)

## Benefits

- ✅ Zero code edits to record/re-record cassettes
- ✅ Dev DB access properly isolated (only during rake task)
- ✅ Test DB never touched (uses ENV var for token)
- ✅ CI-safe (ENV var optional, falls back to mock)
- ✅ Self-documenting (instructions in rake task output)
- ✅ Reusable across all Seismic VCR tests

## VCR Configuration

Sensitive data filtering configured in `spec/support/vcr.rb`:
- Bearer tokens: `Authorization: Bearer <SEISMIC_TOKEN>`
- Request body: `client_id=<CLIENT_ID>&client_secret=<CLIENT_SECRET>&user_id=<USER_ID>`
- Response body: `access_token`, `id_token`, `refresh_token` → `<ACCESS_TOKEN>`, etc.

All filtering happens automatically via `before_record` hook.
