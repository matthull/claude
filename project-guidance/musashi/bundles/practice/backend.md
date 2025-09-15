---
type: bundle
layer: practice
parent: domain/coding.md
context: Musashi backend development with Ruby on Rails
estimated_lines: 400
---
# Practice: Backend (Musashi)

Musashi-specific backend patterns using Ruby on Rails.

## Global Backend Foundation
@~/.claude/guidance/bundles/practice/backend.md

## Musashi Backend Architecture

### Rails Patterns
All project-specific Rails patterns and conventions:
@../../rails/api-patterns.md
@../../rails/backend-testing.md
@../../rails/background-jobs.md
@../../rails/fixture-based-testing.md
@../../rails/models.md
@../../rails/service-objects.md

### Rails-Vue Integration (Backend Side)
Backend patterns for supporting Vue.js frontend:
@../../rails-vue/integration-patterns.md

### Key Backend Decisions
- Rails 7 with Ruby 3.2+
- PostgreSQL for primary database
- Redis for caching and sessions
- Sidekiq for background job processing
- RSpec for testing with fixtures
- Pundit for authorization

### API Architecture
- RESTful JSON APIs for Vue frontend
- GraphQL for complex data fetching needs
- JWT tokens for authentication
- Rate limiting with Rack::Attack
- API versioning through URL path

### Service Layer Patterns
- Service objects for complex business logic
- Command pattern for user actions
- Query objects for complex database queries
- Form objects for complex validations
- Presenter/Serializer pattern for API responses

### Data Layer Strategy
- Active Record for ORM
- Database views for complex reporting
- Materialized views for performance
- UUID primary keys for distributed systems
- Soft deletes for audit trail

### Background Processing
- Sidekiq for async job processing
- Scheduled jobs with sidekiq-cron
- Job retries with exponential backoff
- Dead letter queue for failed jobs
- Job monitoring with Sidekiq Web UI

### Testing Philosophy
- Fixture-based testing for speed
- Request specs for API endpoints
- Service specs for business logic
- Model specs for validations and scopes
- Integration tests for critical paths