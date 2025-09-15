---
type: bundle
layer: practice
parent: domain/coding.md
context: Musashi frontend development with Vue.js and Rails integration
estimated_lines: 300
---
# Practice: Frontend (Musashi)

Musashi-specific frontend patterns using Vue.js within a Rails application context.

## Global Frontend Foundation
@~/.claude/guidance/bundles/practice/frontend.md

## Musashi Frontend Architecture

### Vue.js Patterns
All project-specific Vue.js patterns and guidelines:
@../../vue/component-patterns.md
@../../vue/styling-patterns.md

### Rails-Vue Integration
Patterns for integrating Vue.js within the Rails asset pipeline:
@../../rails-vue/integration-patterns.md

### Key Frontend Decisions
- Vue 3 Composition API for all new components
- Bootstrap CSS for utility-first styling
- Pinia for state management
- Vite for build tooling and HMR
- TypeScript for type safety in complex components

### Component Architecture
- Single File Components (SFC) for all Vue components
- Composables for shared logic between components
- Props validation with TypeScript interfaces
- Event-driven communication between components
- Scoped slots for flexible component composition

### State Management Strategy
- Pinia stores for global application state
- Component-local state for UI-only concerns
- Rails backend as single source of truth
- Optimistic updates with rollback on failure

### Testing Approach
- Vitest for unit testing Vue components
- Testing Library for component integration tests
- Cypress for E2E testing critical user flows
- Visual regression testing with Percy
