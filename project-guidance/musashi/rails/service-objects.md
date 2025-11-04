---
type: guidance
status: current
category: rails

# Automatic triggers
file_triggers:
  - "*_service.rb"
  - "*_service_spec.rb"
directory_triggers:
  - "app/services/**"
  - "spec/services/**"
---

# Service Object Patterns

## When to Use Service Objects

### Good Candidates
- Complex business operations spanning multiple models
- External API integrations
- Multi-step workflows with transaction requirements
- Operations with multiple possible outcomes
- Business logic that doesn't belong to a single model
- Reusable operations called from multiple places

### Poor Candidates
- Simple CRUD operations
- Single model validations
- Basic data transformations
- Presentation logic (use helpers/decorators)
- Simple queries (use scopes)

## Design Principles

### Single Responsibility
- Each service object should do one thing well
- Name services after what they do (verb + noun)
- Keep services focused and composable
- Avoid generic names like "ProcessService"
- Split complex services into smaller ones

### Clear Interface
- Define a consistent public interface (usually `call` or `perform`)
- Use keyword arguments for clarity
- Return consistent result objects
- Document expected inputs and outputs
- Validate inputs early and clearly

### Dependency Injection
- Pass dependencies as parameters
- Avoid hard-coded dependencies on specific classes
- Make services testable in isolation
- Use dependency injection for external services
- Keep services framework-agnostic when possible

## Implementation Patterns

### Result Objects
- Return success/failure status explicitly
- Include relevant data in results
- Provide error messages for failures
- Make results queryable (success?, failure?)
- Consider using a consistent result object pattern

### Error Handling
- Fail fast with clear error messages
- Use exceptions for unexpected errors
- Return failure results for expected errors
- Don't hide errors with broad rescue blocks
- Log errors with appropriate context

### Transaction Management
- Wrap database operations in transactions when needed
- Handle rollback scenarios explicitly
- Consider nested transactions carefully
- Test transaction rollback behavior
- Document transaction boundaries

## Organization Strategies

### File Structure
- Place services in app/services directory
- Group related services in subdirectories
- Use consistent naming conventions
- Mirror domain concepts in organization
- Keep service files focused and small

### Namespacing
- Use modules to group related services
- Avoid deeply nested namespaces
- Consider domain-driven design principles
- Keep namespace names meaningful
- Maintain consistency across the codebase

## Testing Service Objects

### Unit Testing
- Test the public interface thoroughly
- Mock external dependencies
- Test success and failure paths
- Verify side effects occur correctly
- Test edge cases and error conditions

### Integration Testing
- Test services with real dependencies
- Verify database state changes
- Test transaction rollback scenarios
- Validate external API interactions
- Test service composition

## Composition Patterns

### Service Orchestration
- Compose services for complex workflows
- Keep orchestration logic separate
- Handle failures at each step
- Provide progress feedback for long operations
- Make workflows resumable when possible

### Shared Behavior
- Extract common patterns to base classes
- Use modules for shared functionality
- Avoid deep inheritance hierarchies
- Keep shared code focused and minimal
- Document shared behavior clearly

## Performance Considerations

### Optimization Strategies
- Avoid N+1 queries in services
- Use batch operations when possible
- Cache expensive computations
- Profile before optimizing
- Consider async processing for slow operations

### Background Processing
- Move slow operations to background jobs
- Return quickly with status updates
- Provide progress tracking for long operations
- Handle partial completion gracefully
- Design for eventual consistency

## Common Patterns

### Form Objects
- Encapsulate complex form logic
- Handle multi-model forms
- Provide validation across models
- Separate form logic from controllers
- Make forms reusable

### Query Objects
- Encapsulate complex queries
- Make queries reusable and testable
- Provide clear interfaces for filtering
- Optimize query performance
- Document query logic

### Command Objects
- Represent user intentions as objects
- Validate commands before execution
- Provide audit trails for commands
- Make commands queueable
- Support command replay/undo

## Anti-patterns to Avoid

### Service Object Smells
- God objects doing too many things
- Services calling other services in loops
- Business logic leaking into controllers
- Services tightly coupled to Rails
- Missing error handling
- Inconsistent interfaces between services
- Services with side effects in initialization
- Mixing concerns (e.g., authorization with business logic)
- Services that are just wrappers around model methods
- Over-engineering simple operations

### Maintenance Issues
- Untested service objects
- Services without clear documentation
- Inconsistent result handling
- Hidden dependencies
- Complex inheritance hierarchies
- Services with unclear responsibilities
- Missing transaction boundaries
- Poor error messages