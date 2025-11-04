---
type: guidance
status: current
category: rails

# Automatic triggers
file_triggers:
  - "*_controller.rb"
  - "*_controller_spec.rb"
directory_triggers:
  - "app/controllers/api/**"
  - "app/controllers/**/api/**"
  - "spec/requests/api/**"
  - "spec/requests/**/api/**"
---

# Rails API Patterns

## RESTful Design Principles

### Resource-Oriented Architecture
- Design around resources, not actions
- Use standard HTTP verbs for their intended purposes
- Follow Rails routing conventions for predictable endpoints
- Nest resources only when representing true ownership
- Keep nesting shallow (max 1 level deep)

### HTTP Method Semantics
- GET for safe, idempotent reads
- POST for creating new resources
- PUT/PATCH for updates (PUT for full, PATCH for partial)
- DELETE for removing resources
- Use correct status codes for each operation

## Strong Parameters vs Jbuilder Separation

### Strong Parameters (Controller Concern)
- Define what parameters the API accepts
- Act as security boundary for mass assignment
- Should be strict - only permit what's needed
- Never expose internal attributes carelessly
- Consider different params for create vs update
- Group related parameters logically

### Jbuilder Views (Presentation Concern)
- Define what data the API returns
- Shape responses for frontend consumption
- Can include computed fields and associations
- Should be consistent across similar endpoints
- Never expose sensitive internal data
- Consider performance implications of included associations
- Use jbuilder partials to extract common structures and ensure consistency

### Key Principle
The parameters you accept (strong_params) and the data you return (jbuilder) are separate concerns and should not share constants or be tightly coupled.

## API Security Patterns

### Parameter Handling
- Always use strong parameters, never permit!
- Be explicit about permitted parameters
- Validate data types and formats
- Sanitize string inputs
- Guard against mass assignment vulnerabilities
- Consider parameter pollution attacks

### Authentication & Authorization
- Verify authentication before processing
- Check authorization for resource access
- Don't leak information through error messages
- Rate limit sensitive endpoints
- Log suspicious parameter patterns

## Response Structure Consistency

### Standardization Principles
- Use consistent key naming across endpoints
- Maintain similar structure for similar resources
- Include metadata in predictable locations
- Provide consistent pagination formats
- Use standard error response structures
- Extract common response patterns into jbuilder partials

### Collection Responses
- Include total count for paginated results
- Provide clear pagination metadata
- Consider including filter/sort parameters in response
- Be consistent about array wrapping

### Single Resource Responses
- Use consistent top-level key naming
- Include related resources in predictable way
- Provide consistent timestamp formats
- Handle null values consistently

## Error Handling Patterns

### HTTP Status Codes
- 200 OK for successful GET/PUT/PATCH
- 201 Created for successful POST with new resource
- 204 No Content for successful DELETE
- 400 Bad Request for client errors
- 401 Unauthorized for authentication failures
- 403 Forbidden for authorization failures
- 404 Not Found for missing resources
- 422 Unprocessable Entity for validation errors
- 500 Internal Server Error for server failures

### Error Response Structure
- Include human-readable error messages
- Provide field-specific errors for forms
- Use consistent error key naming
- Include error codes for programmatic handling
- Don't expose internal implementation details

## Performance Considerations

### Query Optimization
- Use includes/preload to prevent N+1 queries
- Limit default result set sizes
- Implement efficient pagination
- Consider query complexity in API design
- Monitor slow query logs

### Response Optimization
- Only return fields that clients need
- Implement sparse fieldsets if needed
- Consider response caching strategies
- Use ETags for conditional requests
- Compress large responses

## Testing Patterns

### Request Spec Coverage
- Test happy path for each endpoint
- Test parameter validation
- Test authorization rules
- Test error conditions
- Verify response structure
- Check status codes
- Test pagination
- Verify includes work correctly

### Contract Testing
- Verify API contracts are maintained
- Test that responses match documented structure
- Ensure backward compatibility
- Test edge cases and null values

## Common Pitfalls

### Anti-patterns to Avoid
- Exposing database IDs directly without consideration
- Returning different structures for same resource type
- Using non-standard HTTP methods
- Ignoring REST conventions without good reason
- Tight coupling between internal models and API
- Exposing internal error messages
- Allowing unlimited result sets
- Not validating input types
- Trusting client-provided IDs for authorization