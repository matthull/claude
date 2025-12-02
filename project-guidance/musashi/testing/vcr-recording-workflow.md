---
type: guidance
status: current
category: testing
tags:
- backend
- integrations
---

# VCR Cassette Recording for Seismic API

## Record Cassette

```bash
docker compose exec web bash -c 'TOKEN=$(bundle exec rake seismic:vcr:token 2>/dev/null) && SEISMIC_VCR_TOKEN="$TOKEN" bundle exec rspec spec/path/to/spec.rb:LINE'
```

## Test Pattern

```ruby
describe '#some_seismic_method' do
  before do
    token = ENV['SEISMIC_VCR_TOKEN'] || 'test_token'
    expiry = 1.hour.from_now

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

## Workflow

1. Rake task fetches token from dev DB
2. Token injected via `ENV['SEISMIC_VCR_TOKEN']`
3. Test makes real API call, VCR records response
4. Sensitive data filtered automatically (`spec/support/vcr.rb`)
5. Subsequent runs replay from cassette

## Replay Test

```bash
docker compose exec web bundle exec rspec spec/path/to/spec.rb:LINE
```

No token needed - uses cassette.
