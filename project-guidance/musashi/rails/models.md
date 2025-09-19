---
type: guidance
status: current
category: rails
---

# Rails Model Patterns

## Association Best Practices

### Dependency Management
- Consider :dependent options carefully based on business logic
- Use :destroy for associated records that shouldn't exist without parent
- Use :nullify when associated records can exist independently
- Use :restrict_with_error to prevent deletion when associations exist
- Avoid :delete_all unless you're certain callbacks aren't needed

### Bidirectional Associations
- Use :inverse_of for bidirectional associations to reduce queries
- Helps Rails understand the relationship and optimize object loading
- Critical for associations with validations on the inverse
- Improves memory usage by ensuring single object instances

### Association Options
- Use counter_cache for frequently counted associations
- Apply scopes to associations when you always need filtered data
- Consider :touch to update parent timestamps when children change
- Use :autosave carefully - understand when Rails saves associations

## Validation Patterns

### Validation Strategy
- Validate at the model level, not just in forms
- Use database constraints as backup for critical validations
- Consider conditional validations for different contexts
- Group related validations logically
- Write custom validators for complex business rules

### Common Validation Pitfalls
- Don't skip validations without explicit reason
- Be careful with uniqueness validations - add database indexes
- Consider case sensitivity in uniqueness validations
- Handle validation errors gracefully in controllers
- Test edge cases in validation logic

## Callback Patterns

### Callback Usage
- Use callbacks sparingly - they can make debugging difficult
- Prefer service objects for complex operations
- Keep callbacks focused on the model's direct concerns
- Avoid callbacks that touch other models when possible
- Document why callbacks are necessary

### Callback Order
- Understand the callback chain order
- Be careful with conditional callbacks
- Avoid dependent callbacks between models
- Consider using database triggers for data integrity
- Test callback behavior thoroughly

## Query Optimization

### Preventing N+1 Queries
- Use includes for associations you'll access
- Use preload when you need separate queries
- Use eager_load when you need JOIN-based loading
- Monitor queries in development with bullet gem
- Add database indexes for frequently queried columns

### Scope Patterns
- Create scopes for commonly used queries
- Keep scopes simple and composable
- Use class methods for complex scopes with logic
- Avoid scopes with side effects
- Test scope combinations

## Data Integrity

### Database Constraints
- Add database-level constraints for critical business rules
- Use foreign key constraints for referential integrity
- Add NOT NULL constraints where appropriate
- Create unique indexes for uniqueness validations
- Consider check constraints for data validation

### Migration Patterns
- Make migrations reversible when possible
- Add indexes for foreign keys and frequently queried columns
- Consider the impact of migrations on production data
- Use strong migrations gem practices
- Separate schema changes from data migrations

## Model Organization

### Separation of Concerns
- Keep models focused on data and business rules
- Extract complex logic to service objects
- Use concerns for shared behavior across models
- Avoid fat models - prefer composition
- Separate presentation logic from models

### Naming Conventions
- Use descriptive names for associations and scopes
- Follow Rails naming conventions consistently
- Name callbacks clearly to indicate their purpose
- Use intention-revealing names for custom methods

## Performance Considerations

### Caching Strategies
- Cache expensive computed attributes
- Invalidate caches when dependencies change
- Use touch: true to bust caches automatically
- Consider database-level computed columns
- Profile before optimizing

### Large Dataset Handling
- Use find_each for batch processing
- Implement pagination for large result sets
- Consider database views for complex queries
- Use pluck/select for specific attributes
- Avoid loading unnecessary data

## Testing Models

### Test Coverage
- Test validations with valid and invalid data
- Test associations are properly configured
- Test scopes return expected results
- Test callbacks when they contain logic
- Test custom methods thoroughly

### Testing Strategies
- **CRITICAL: Add fixtures for new models** - See fixture-based-testing.md
- Use fixtures for typical test data (defined in fixture_builder.rb)
- Use factories for edge cases only
- Test the public interface, not implementation
- Mock external dependencies
- Keep tests fast and isolated

### New Model Checklist
When creating a new model:
1. Create the model class
2. Write the migration
3. **Add fixture(s) to `spec/support/fixture_builder.rb`** ← REQUIRED
4. Create factory in `spec/factories/`
5. Write model specs using fixtures

## Common Anti-patterns

### Avoid These Patterns
- Putting presentation logic in models
- Complex callbacks that are hard to debug
- Validations that depend on external services
- Business logic in migrations
- Skipping database constraints
- Over-using callbacks for everything
- Direct SQL when ActiveRecord would work
- Premature optimization
- God objects with too many responsibilities