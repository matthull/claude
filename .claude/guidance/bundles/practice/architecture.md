---
type: bundle
layer: practice
parent: domain/coding.md
context: System architecture and design patterns for this project
estimated_lines: 250
---
# Practice: Architecture (Project-Specific)

Project-specific architecture patterns and conventions, extending global architecture principles.

## Global Architecture Foundation
@~/.claude/guidance/bundles/practice/architecture.md

## Project-Specific Architecture Patterns

### Service Layer Architecture
- All business logic in service objects
- Services inherit from ApplicationService base class
- One public method per service (call or perform)
- Services return Result objects for success/failure handling

### Database Design Patterns
- Soft deletes for all user-facing models
- UUID primary keys for distributed systems
- Optimistic locking for concurrent updates
- Database views for complex reporting queries

### API Design Conventions
- RESTful endpoints with consistent naming
- JSON:API specification for responses
- Pagination using cursor-based approach
- Rate limiting per API key

### Error Handling Strategy
- Custom exception classes in app/exceptions
- Centralized error reporting to monitoring service
- User-friendly error messages in I18n
- Detailed logging for debugging

## Project-Specific Includes
@.claude/guidance/architecture/service-objects.md
@.claude/guidance/architecture/api-patterns.md
@.claude/guidance/architecture/database-conventions.md