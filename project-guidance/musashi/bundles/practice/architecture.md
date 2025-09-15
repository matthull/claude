---
type: bundle
layer: practice
parent: domain/coding.md
context: Musashi system architecture and integration patterns
estimated_lines: 250
---
# Practice: Architecture (Musashi)

Musashi-specific architecture patterns and integration guidelines, extending global architecture principles.

## Global Architecture Foundation
@~/.claude/guidance/bundles/practice/architecture.md

## Musashi-Specific Architecture

### Integration Patterns
Core integration patterns and practices for the Musashi system:
@../../integration-patterns.md

### System Overview
Musashi serves as a unified integration layer, coordinating between multiple services
and providing a consistent interface for downstream consumers.

### Key Architectural Decisions
- Event-driven architecture for service communication
- Saga pattern for distributed transactions
- CQRS for read/write separation in high-throughput scenarios
- Circuit breaker pattern for external service resilience

### Service Boundaries
- Clear separation between integration logic and business logic
- Adapter pattern for external service interfaces
- Repository pattern for data access abstraction
- Domain events for cross-service communication