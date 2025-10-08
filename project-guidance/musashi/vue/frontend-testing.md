---
type: guidance
status: current
category: vue
---

# Frontend Testing Patterns

## Test Environment Setup

### Running Tests
- Vitest: `docker exec musashi-web-1 yarn test`
- Single file: `docker exec musashi-web-1 npx vitest app/javascript/src/lib/file_name.test.ts`
- ESLint: `docker exec musashi-web-1 yarn eslint`
- Always run inside Docker for consistency

### Test File Organization
- Component tests: Next to component files
- Utility tests: In `__tests__` directories
- Use `.test.ts` or `.spec.ts` extensions
- Mirror source directory structure

## Storybook Development

### Story-Driven Workflow
- Create/update story before implementing
- Use stories as visual TDD tool
- Check stories frequently during development
- Access at `localhost:6006`
- Use Chrome MCP to verify story rendering

### Story Structure
- Include all component states
- Provide realistic data
- Cover edge cases
- Document component props
- Show error states

### Backend Model Coordination
- Search for stories when models change
- Update story data to match new structure
- Include new fields to prevent runtime errors
- Test all story variations still work
- Keep stories as living documentation

### Storybook Debugging
- Story content runs inside iframe
- Access with: `document.querySelector('#storybook-preview-iframe')`
- Query story elements through iframe's contentDocument
- Essential for Chrome MCP testing of stories

## Component Testing Strategy

### Primary Testing Approach: Storybook
**IMPORTANT**: For Vue components, Storybook serves as our primary testing mechanism. We DO NOT write component tests in Vitest for Vue components.

- **Storybook = Component Tests**: Each story validates component behavior
- **Visual Testing**: Stories verify rendering across different states
- **Integration Testing**: Stories test component with real props/data
- **Living Documentation**: Stories serve as both tests and documentation
- **Manual QA**: Stories enable quick visual verification

### When to Use Vitest
Use Vitest ONLY for:
- **Utility functions**: Pure JavaScript/TypeScript utilities
- **Composables**: Vue composition API logic
- **Store modules**: Vuex/Pinia store logic
- **Services**: API clients and business logic services
- **Helpers**: Non-component helper functions

### Why Storybook for Component Testing
- **Visual Regression**: Immediately see if components break
- **Real Browser Environment**: Tests run in actual browser context
- **Designer Collaboration**: Stories are accessible to non-developers
- **Faster Development**: No need to maintain separate test files
- **Interactive Testing**: Can manually interact with components

## API Integration Testing

### Mocking API Responses
- Mock data must match actual API structure
- Update mocks when API changes
- Test success and failure responses
- Test loading states
- Handle timeout scenarios

### Testing Data Flow
- Component receives API data correctly
- Updates trigger appropriate API calls
- Error responses handled gracefully
- Optimistic updates work correctly
- Cache invalidation happens appropriately

## Visual Testing

### Component Appearance
- Use Storybook for visual testing
- Test at different viewport sizes
- Verify theme application
- Check dark mode if applicable
- Test with different data volumes

### Regression Testing
- Take screenshots before changes
- Compare after implementation
- Use Chrome MCP for automation
- Document expected visual changes
- Flag unintended modifications

## Testing Vue Specifics

### Reactivity Testing
- Data changes trigger updates
- Computed properties recalculate
- Watchers fire appropriately
- v-model binding works
- Refs accessed correctly

### Lifecycle Testing
- Components mount properly
- Data fetches on mount
- Cleanup in unmounted
- Updates trigger correctly
- Error boundaries work

### Event Testing
- Custom events emit correctly
- Event payloads are correct
- Native events handled
- Event modifiers work
- Propagation controlled properly

## Performance Testing

### Component Performance
- Measure render time
- Check for unnecessary re-renders
- Verify virtual scrolling works
- Test with large datasets
- Monitor memory usage

### Bundle Size Impact
- Check component bundle size
- Verify tree shaking works
- Test lazy loading
- Monitor dependency size
- Use dynamic imports appropriately

## Accessibility Testing

### Automated Checks
- Run accessibility linters
- Test keyboard navigation
- Verify ARIA attributes
- Check focus management
- Test screen reader compatibility

### Manual Verification
- Tab order makes sense
- Focus indicators visible
- Color contrast sufficient
- Interactive elements accessible
- Error messages announced

## Common Testing Scenarios

### Form Testing
- Validation triggers correctly
- Error messages display
- Submit handling works
- Reset functionality
- Field interactions

### List/Table Testing
- Sorting works correctly
- Filtering applies properly
- Pagination functions
- Selection works
- Empty states display

### Modal/Dialog Testing
- Opens and closes correctly
- Focus trapped properly
- Escape key works
- Backdrop clicks handled
- Content scrolls if needed

## Anti-patterns to Avoid

### Test Smells
- Testing implementation details
- Brittle selectors
- Not waiting for async operations
- Over-mocking losing realism
- Testing framework behavior

### Maintenance Issues
- Not updating stories with components
- Ignoring console errors in tests
- Skipping accessibility tests
- Not testing error states
- Missing loading states