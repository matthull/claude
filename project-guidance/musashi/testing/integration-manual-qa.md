---
type: guidance
status: current
category: testing
tags:
- backend
- integrations
---

# Integration and Manual QA Testing

## Chrome MCP Testing Patterns

### Local Development Access
- App: `http://localhost:3000`
- Storybook: `http://localhost:6006`
- Admin: `/admin`
- Research library: `/user-research-library`
- Test credentials: `db/seeds.rb`

### When to Include Browser Tests
Include for every implementation UNLESS:
- No visible web app impact (background jobs, instrumentation)
- Pure documentation updates
- Email templates with no UI impact
- Configuration-only changes

## Regression Testing Process

### Visual Regression Workflow
1. **Baseline Capture**
   - Navigate to feature before changes
   - Screenshot each workflow step
   - Name: `baseline-{feature}-{step}.png`
   - Complete full workflow
   - Capture final states

2. **Post-Development Verification**
   - Repeat exact workflow
   - Screenshot with matching names
   - Name: `post-dev-{feature}-{step}.png`
   - Complete full workflow

3. **Comparison**
   - Use testing-qa-specialist agent for comparison
   - Document all differences
   - Verify changes are intentional
   - Fix unintentional changes
   - Re-test after fixes

### Screenshot Naming Convention
- Format: `{phase}-{feature}-{step}.png`
- Baseline: `baseline-import-assets-dropdown.png`
- Post-dev: `post-dev-import-assets-dropdown.png`
- Keep descriptive and consistent
- Match user workflow steps

## Common Test Workflows

### Asset Management
- Import Assets → PDF → Upload → Publish
- Test file upload functionality
- Verify asset library display
- Check filtering and search
- Test asset metadata editing

### Research Library Testing
- UserEvidence account hidden by design (IDs 1, 2, 3)
- Direct access: `/user-research-library/main-account`
- Individual assets: `/assets/{identifier}`
- Test public-facing display
- Verify MediaViewer functionality

### Admin Tool Testing
- Navigate to `/admin` directly
- Test administrative functions
- Verify permission restrictions
- Check audit logs
- Test bulk operations

## External Integration Testing

### API Testing as External Consumer
- Create curl scripts for endpoints
- Test with various authentication states
- Verify rate limiting
- Test error responses
- Document API behavior

### Webhook Testing
- Simulate webhook deliveries
- Test payload processing
- Verify idempotency
- Test retry behavior
- Check signature validation

### Third-party Service Mocking
- Mock external service responses
- Test failure scenarios
- Verify timeout handling
- Test retry logic
- Check circuit breakers

## Manual QA Procedures

### Exploratory Testing
- Test beyond defined scenarios
- Look for edge cases
- Try unusual user paths
- Test with different data
- Document unexpected behaviors

### Cross-browser Testing
- Test in Chrome, Firefox, Safari
- Check mobile browsers
- Verify responsive design
- Test touch interactions
- Check browser-specific features

### Performance Testing
- Test with realistic data volumes
- Check page load times
- Monitor memory usage
- Test with slow connections
- Verify lazy loading works

### Accessibility Testing
- Navigate with keyboard only
- Test with screen readers
- Verify focus indicators
- Check color contrast
- Test with browser zoom

## Test Data Management

### Using Seed Data
- Login: evan@userevidence.com
- Password in `db/seeds.rb`
- Create test scenarios with seeds
- Reset database when needed
- Document test data dependencies

### Creating Test Scenarios
- Use realistic data
- Cover edge cases
- Test boundary conditions
- Include invalid data
- Test empty states

## Integration Test Coordination

### Backend-Frontend Integration
- Test API contract compliance
- Verify data flow end-to-end
- Test error propagation
- Check loading states
- Verify cache behavior

### Multi-system Testing
- Test across service boundaries
- Verify data consistency
- Test transaction boundaries
- Check cascade operations
- Monitor system interactions

## Quality Verification

### Acceptance Criteria
- Feature works as specified
- No regression in existing features
- Performance acceptable
- Accessibility maintained
- Security requirements met

### Bug Reporting
- Document steps to reproduce
- Include screenshots/videos
- Note environment details
- Specify expected vs actual
- Assign severity appropriately

## Common Testing Scenarios

### Form Workflows
- Test validation messages
- Verify submit handling
- Check error recovery
- Test field dependencies
- Verify data persistence

### Search and Filter
- Test search accuracy
- Verify filter combinations
- Check result pagination
- Test empty results
- Verify sort orders

### File Operations
- Test upload limits
- Verify file type restrictions
- Check progress indicators
- Test cancel operations
- Verify error handling

## Anti-patterns to Avoid

### Testing Mistakes
- Not testing error paths
- Ignoring edge cases
- Testing only happy path
- Not verifying cleanup
- Missing regression checks

### Process Issues
- Skipping exploratory testing
- Not documenting findings
- Testing in isolation only
- Ignoring performance
- Missing accessibility checks
