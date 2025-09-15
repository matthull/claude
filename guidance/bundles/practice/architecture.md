---
type: bundle
layer: practice
parent: domain/coding.md
context: General system architecture and design patterns
estimated_lines: 200
---
# Practice: Architecture (Global)

Universal architecture patterns and design principles.

## Parent Bundle
@../domain/coding.md

## Core Architecture Principles

### Separation of Concerns
- Clear boundaries between layers
- Single responsibility per component
- Dependency injection for flexibility
- Interface-based design

### Scalability Patterns
- Horizontal scaling over vertical
- Stateless service design
- Caching strategies at multiple levels
- Async processing for heavy operations

### Security by Design
- Defense in depth
- Principle of least privilege
- Input validation at boundaries
- Audit logging for sensitive operations

## Direct Includes
@../../architecture/clean-architecture.md
@../../architecture/microservices-patterns.md
@../../architecture/event-driven-design.md
@../../security/secure-architecture.md