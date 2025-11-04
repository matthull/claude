---
type: guidance
status: current
category: browser-automation
---

# Chrome MCP Browser Testing

## Setup
Chrome MCP provides browser automation for testing and visual verification.

## Local Development Access

### Test Environment
- App: `http://localhost:3000`
- Storybook: `http://localhost:6006` (runs automatically in Docker - never start manually)
- Test credentials: `db/seeds.rb` (evan@userevidence.com)

### Key Paths
- After login: App (marketers manage surveys/assets)
- Admin: `/admin`
- Research library: `/user-research-library`

### Storybook Testing
Access Storybook via Chrome MCP: `navigate to http://localhost:6006`

Story content renders in iframe `#storybook-preview-iframe`. Access via:
```javascript
const iframe = document.querySelector('#storybook-preview-iframe');
const doc = iframe.contentDocument;
```

## Regression Testing

### Workflow
1. **Baseline**: Navigate workflow, screenshot each step as `baseline-{feature}-{step}.png`
2. **Development**: Make code changes
3. **Verification**: Repeat workflow, screenshot as `post-dev-{feature}-{step}.png`
4. **Comparison**: Use testing-qa-specialist agent to compare, verify changes are intentional

### Screenshot Naming
Format: `{phase}-{feature}-{step}.png`

### Common Workflows
- Asset creation: Import Assets > PDF > Upload > Publish
- Asset library display/filtering
- Research library public display
- Admin functionality

## Research Library Access

### UserEvidence Account
Main account (IDs 1-3) hidden from index by design.

### Direct Access
- Account: `/user-research-library/main-account`
- Assets: `/assets/{identifier}`

### Testing MediaViewer
1. Use direct account URL
2. Use direct asset URLs (get identifier from database)
3. Verify MediaViewer in public contexts
