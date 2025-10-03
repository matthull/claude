---
type: guidance
status: current
category: architecture
tags:
- architecture
focus_levels:
- strategic
- design
---

# Cross-Layer Impact Analysis

## Impact Analysis Framework

### 1. Data Flow Mapping
- Trace data source to consumption
- Document transformation points
- Identify validation layers
- Map format changes

### 2. Contract Changes
- Identify affected APIs
- Document schema updates
- List interface boundaries
- Plan versioning strategy

### 3. Dependency Chain
- Map downstream consumers
- Identify upstream providers
- Document transitive dependencies
- Consider cascade effects

### 4. Breaking Change Detection
- Identify compatibility issues
- Document migration paths
- Plan deployment coordination
- Consider feature flags

### 5. Integration Points
- Document layer connections
- Identify failure modes
- Plan error handling
- Consider timeout/retry

## Implementation Sequence
1. **Data Layer** - Schema, models
2. **Business Logic** - Services, domain
3. **API Layer** - Controllers, contracts
4. **Presentation** - UI components
5. **Integration Tests** - Validation

## Critical Questions

### Impact
- How does change affect APIs?
- What contracts modified?
- Which systems need updates?

### Integration
- How will layers handle changes?
- Timing dependencies?
- Single layer failure handling?

### Testing
- What tests span layers?
- How validate integration?
- What regression updates?

### Deployment
- Breaking changes?
- Independent deployment?
- Rollback strategy?

### Risk
- Optimal sequence?
- Highest-risk points?
- Monitoring needs?

## Trade-off Criteria
- **Coupling**: Connection tightness
- **Flexibility**: Evolution ease
- **Performance**: Latency impact
- **Complexity**: Understanding difficulty
- **Maintenance**: Long-term burden

## Decision Process
1. Document options
2. Evaluate against criteria
3. Consider short/long term
4. Plan migration if interim
5. Document rationale

## Anti-patterns
- NEVER: Big bang all-layer changes
- NEVER: Skip intermediate layers
- NEVER: Implicit contracts
- NEVER: Direct DB access from UI
- NEVER: Missing abstractions