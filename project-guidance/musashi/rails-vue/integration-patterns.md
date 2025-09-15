---
type: guidance
status: current
category: rails-vue
---

# Rails + Vue Integration Patterns

## Data Flow Architecture

### Standard Data Flow Path
Rails Model → API Controller → Jbuilder View → Vue Component → User Interaction → API → Model

### Key Principles
- Rails models define the authoritative data structure
- Controllers handle request/response transformation only
- Jbuilder views shape data specifically for frontend consumption
- Vue components should never assume backend structure details
- Data transformations should happen at clear boundaries

## API Design for Vue Consumption

### Response Structure Consistency
- Maintain consistent response shapes across similar endpoints
- Include all needed associations in single responses when possible
- Avoid requiring multiple API calls for single view rendering
- Provide computed fields that Vue would otherwise need to calculate
- Use consistent naming conventions (camelCase vs snake_case boundaries)

### Frontend-Friendly Patterns
- Design API responses around UI needs, not database structure
- Group related data logically for component consumption
- Include metadata (pagination, totals) in standardized format
- Provide clear null/empty state representations

## Database Schema Evolution

### Maintaining API Compatibility
- Add new fields as optional with sensible defaults
- Keep old fields during transition periods
- Version endpoints only when breaking changes are unavoidable
- Document deprecation timelines clearly
- Consider frontend migration effort in schema decisions

### Coordination Strategies
- Backend changes should anticipate frontend impact
- Deploy backward-compatible changes first
- Allow time for frontend migration before removing old fields
- Monitor API usage to track migration progress

## Error Handling Across Layers

### Error Propagation Principles
- Rails validation errors should map to frontend form fields
- API errors should include both human-readable and programmatic formats
- HTTP status codes should accurately reflect error types
- Frontend should handle errors gracefully at component boundaries
- Global error handlers should catch unhandled API failures

### Consistency Requirements
- Error response structure should be uniform across all endpoints
- Field-level errors should use consistent naming
- Error messages should be frontend-display ready
- Include enough context for debugging without exposing internals

## Storybook and Component Testing

### Model Change Coordination
- Backend model changes often require Storybook story updates
- Story data should mirror actual API response structures
- Include realistic test data covering edge cases
- Stories should test component behavior with various data states
- Keep story data in sync with backend model evolution

### Testing Integration Points
- Request specs validate the API contract Vue depends on
- Component tests verify correct API response handling
- Integration tests ensure end-to-end data flow works
- Mock data in tests should match real API responses

## State Management Patterns

### Data Ownership Principles
- Prefer local component state for single-use data
- Use shared state management only for truly shared data
- API responses should be treated as immutable in components
- Avoid duplicating backend state unnecessarily
- Clear data refresh strategies for stale data

### Loading and Error States
- Consistent loading state patterns across components
- Error states should provide actionable user feedback
- Optimistic updates should have rollback strategies
- Background refresh shouldn't disrupt user interactions

## Performance Optimization

### Data Transfer Efficiency
- Prevent N+1 queries through proper eager loading
- Limit API response fields to what frontend actually uses
- Implement pagination for large datasets
- Consider response compression for large payloads
- Balance between number of requests and response size

### Caching Strategies
- Cache expensive computations at appropriate layers
- Use HTTP caching headers effectively
- Implement frontend caching for expensive operations
- Clear caches appropriately when data changes
- Consider real-time updates vs polling vs manual refresh

## Implementation Sequencing

### Recommended Order for Changes
1. Update Rails models and migrations
2. Modify API controllers and strong params
3. Update jbuilder views for response structure
4. Adjust Vue components to consume new data
5. Update component tests and stories
6. Verify integration tests still pass

### Risk Mitigation
- Test each layer independently before integration
- Use feature flags for gradual rollout
- Keep old code paths during transition
- Monitor errors during deployment
- Have rollback plan ready

## Common Integration Pitfalls

### Anti-patterns to Avoid
- Direct database access from frontend code
- Tight coupling between component structure and API responses
- Assuming synchronous data availability
- Ignoring loading and error states
- Mixing concerns across layer boundaries
- Over-fetching data "just in case"
- Under-fetching leading to N+1 API calls