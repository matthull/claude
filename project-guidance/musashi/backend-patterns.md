---
type: guidance
status: current
category: backend
---

# Backend Development Patterns

## API Design
- Maintain consistent model response structures across endpoints
- Use jbuilder files for JSON response structures (not model FIELDS constants)
- Use strong_params in controllers for parameter validation
- **Never** share constants between strong_params and jbuilder

## Controller Concerns
- Use `Pagination` concern for paginated endpoints - includes helper methods `page`, `per_page`, `pagination`
- Example: `include Pagination` then use `page:, per_page:` instead of manual parameter parsing

## Performance & Caching
- Avoid caching unless documented justification exists
- Exhaust query optimization before adding caching
- Maintain single source of truth for data
- Check AppSignal metrics post-deployment rather than proactive caching

## Testing & Documentation
- **Always** add tests for new/modified features - tests are part of the feature
- **Always** add YARD docs when creating/modifying files, classes, or methods
- Use Arrange-Act-Assert structure with newline separations:
```ruby
it "lists all the account's users" do
  # Arrange
  FactoryBot.create :user, account: user.account

  # Act
  get app_api_users_path(format: :json)

  # Assert
  expect(response.parsed_body['users'].count).to eq(2)
end
```

## Database Migrations
- **Never** create breaking migrations that rely on new code
- **Always** deploy migrations separately from code changes
- Add columns first, then use them in subsequent PR
- Remove usage first, add to `ignored_columns`, then drop in subsequent PR

## Security & Data Validation
- **Never** trust client-side data
- **Always** validate and sanitize server-side
- **Always** check authorization server-side even if client-side UI restricts access

## Code Quality
- Avoid raw SQL - use ActiveRecord API
- Avoid Rails environment checks except for UI distinctions
- **Never** use `Rails.env.production?` - prefer `['development', 'test'].include?(Rails.env)`
- **Avoid** useless or superfluous comments - code should be self-documenting
- Only add comments for complex business logic, non-obvious decisions, or YARD documentation