---
type: guidance
status: current
category: vue

# Automatic triggers
file_triggers:
  - "*.vue"
directory_triggers:
  - "src/components/**"
  - "app/javascript/components/**"
---

# Vue Component Patterns

## Component Design Principles

### Naming Conventions
- Component names must be multi-word to avoid conflicts with HTML elements
- Use PascalCase for component names in scripts
- Use kebab-case for component names in templates
- Name components after what they represent, not what they do
- Group related components with consistent prefixes

### Component Scope
- Always use `scoped` directive in component styles
- Keep component styles focused on the component itself
- Let parent components control spacing and positioning
- Avoid global style modifications from components
- Use CSS modules for truly isolated styles when needed

### Props and Data
- Validate all props with appropriate types
- Provide default values for optional props
- Keep component state minimal and focused
- Derive computed values instead of storing redundant data
- Document complex props with comments

## TypeScript Integration

### Import Patterns
- Use TypeScript path aliases for all imports
- Never use relative imports beyond current directory
- Import types separately from values
- Define component prop types explicitly
- Export types that other components might need

### Type Safety
- Define interfaces for complex data structures
- Type all component methods and computed properties
- Use enums for fixed sets of values
- Avoid using `any` type except when absolutely necessary
- Document type assumptions with comments

## Styling Patterns

### CSS Organization
- Use scoped styles to prevent leakage
- Organize styles logically within component
- Use CSS custom properties for dynamic values
- Prefer CSS Grid and Flexbox over positioning
- Keep media queries close to affected styles

### Class Naming
- Use semantic class names that describe purpose
- Avoid generic names like 'container' or 'wrapper'
- Use BEM methodology for complex components
- Keep class names consistent with component name
- Document unusual styling decisions

### Spacing Philosophy
- Components shouldn't define their own external margins
- Parent components control child spacing
- Use padding for internal spacing
- Use CSS Grid or Flexbox gap for consistent spacing
- Document spacing requirements in component

## Error Handling

### User-Facing Errors
- Use toast notifications for user messages
- Provide actionable error messages
- Don't expose technical details to users
- Offer recovery actions when possible
- Log errors for debugging

### Development Errors
- Use proper error boundaries
- Report errors to error tracking service
- Include component context in error reports
- Fail gracefully with fallback UI
- Test error scenarios explicitly

## State Management

### Local vs Global State
- Prefer local component state for UI-specific data
- Use global state only for truly shared data
- Keep component state close to where it's used
- Avoid prop drilling through many levels
- Document state dependencies clearly

### Data Flow
- Follow unidirectional data flow principles
- Emit events for parent communication
- Use provide/inject sparingly and document it
- Avoid mutating props directly
- Keep data transformations pure

## Component Composition

### Slots and Content Distribution
- Use slots for flexible content injection
- Provide sensible slot defaults
- Name slots descriptively
- Document slot expectations
- Use scoped slots for complex data passing

### Component Reusability
- Design components to be reusable from the start
- Avoid tight coupling to specific contexts
- Use props for configuration over hard-coding
- Provide flexible styling hooks
- Document usage examples

## Performance Considerations

### Rendering Optimization
- Use v-show vs v-if appropriately
- Implement virtual scrolling for long lists
- Lazy load heavy components
- Memoize expensive computations
- Use functional components for simple presentational needs

### Bundle Size
- Code split at route level
- Lazy load components that aren't immediately needed
- Avoid importing entire libraries
- Tree-shake unused code
- Monitor bundle size impact

## Accessibility

### ARIA and Semantic HTML
- Use semantic HTML elements appropriately
- Add ARIA labels where needed
- Ensure keyboard navigation works
- Test with screen readers
- Provide alternative text for images

### Focus Management
- Manage focus for dynamic content
- Provide skip links for navigation
- Ensure focus indicators are visible
- Test tab order
- Handle focus trapping in modals

## Testing Strategies

### TDD Component Development Workflow
When implementing new components, follow this TDD-style loop:
1. **Write Storybook story first** - Define the component's expected interface
2. **Create minimal component** - Just enough to render in Storybook
3. **Load in browser via Chrome MCP** - Verify component renders correctly
4. **Iterate with live feedback** - Develop component while checking in browser
5. **Add interaction tests** - Test user interactions via Chrome MCP
6. **Refactor once working** - Clean up with confidence

### Component Testing
- Test component public interface
- Test prop validation
- Test event emissions
- Test computed properties
- Test error states

### Storybook Integration
- Create stories for all components
- Include stories for different states
- Document component usage in stories
- Test responsive behavior in stories
- Keep stories synchronized with component changes

### Chrome MCP Browser Testing
- Use Chrome MCP to load Storybook stories during development
- Verify visual rendering matches expectations
- Test component interactions programmatically
- Check responsive behavior at different viewports
- Validate accessibility with automated tools

## Anti-patterns to Avoid

### Component Smells
- Components doing too much (god components)
- Deep prop drilling
- Mutating props directly
- Using refs excessively
- Tight coupling between components
- Missing error boundaries
- Inline styles instead of classes
- Direct DOM manipulation
- Global event listeners without cleanup
- Memory leaks from subscriptions

### Maintenance Issues
- Undocumented complex logic
- Inconsistent naming conventions
- Missing prop validation
- No error handling
- Hardcoded values
- Duplicate state
- Circular dependencies
- Over-engineering simple components