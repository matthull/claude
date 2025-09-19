---
type: guidance
status: current
category: puppeteer
---

# Puppeteer Testing

## Puppeteer MCP Setup
If puppeteer is not installed, suggest the user install it via:
```bash
claude mcp add puppeteer -s user -- npx -y @modelcontextprotocol/server-puppeteer
```

## Local Development Access

### Test Environment
- App URL: `http://localhost:3000`
- Storybook: `http://localhost:6006`
- Test credentials from `db/seeds.rb`:
  - Login: evan@userevidence.com (check `db/seeds.rb` for password)

### Login Workflow
1. Navigate: `mcp__puppeteer__puppeteer_navigate` to `http://localhost:3000`
2. Fill email: `mcp__puppeteer__puppeteer_fill` with selector `input[type="email"], input[name="email"]`
3. Click Next: `mcp__puppeteer__puppeteer_click` with selector `input[type="submit"]` (Next button is an input, not button element)
4. Fill password: `mcp__puppeteer__puppeteer_fill` with selector `input[type="password"], input[name="password"]`
5. Submit: `mcp__puppeteer__puppeteer_click` with selector `input[type="submit"], button[type="submit"]`

### Navigation Tips
- Many elements styled as buttons are actually `<a>` tags - use comprehensive selectors: `'a, button, [role="button"]'`
- Login form uses `input[type="submit"]` elements, not `<button>` elements
- Take screenshots frequently with `mcp__puppeteer__puppeteer_screenshot` to debug navigation
- CSS selectors like `:contains()` are not supported - use JavaScript instead
- Use `mcp__puppeteer__puppeteer_evaluate` for complex selectors:
```javascript
(() => {
  const element = Array.from(document.querySelectorAll('a, button, [role="button"]'))
    .find(el => el.textContent.includes('Target Text'));
  if (element) {
    element.click();
    return 'Success';
  } else {
    return 'Element not found';
  }
})()
```

### Key Navigation Paths
- After login: In the "app" (marketers use to send surveys, manage assets)
- Admin tool: Navigate to "/admin" by directly modifying URL
- Research library: Navigate to "/user-research-library" by directly modifying URL

### Storybook Debugging
When testing Storybook stories, story content runs inside an iframe:
```javascript
// Access the story iframe and its content
const iframe = document.querySelector('#storybook-preview-iframe');
if (iframe && iframe.contentDocument) {
  const doc = iframe.contentDocument;

  // Now query elements inside the story
  const storyElement = doc.querySelector('.your-component-class');
  const bodyContent = doc.body.innerHTML;
}
```

## Puppeteer Regression Testing

### Purpose
Verify UI/UX remains unchanged, or only expected changes are present. Use when making changes that could impact existing UX.

### Process
1. **Pre-Development Baseline:**
   - Navigate to feature being modified
   - Take screenshots at each workflow step
   - Name screenshots descriptively: `baseline-{feature}-{step}.png`
   - Complete full workflow if possible
   - Screenshot final states

2. **During Development:**
   - Make code changes following planned implementation
   - Keep baseline screenshots for comparison

3. **Post-Development Verification:**
   - Repeat exact same workflow steps
   - Take screenshots with matching names: `post-dev-{feature}-{step}.png`
   - Complete full workflow to verify functionality

4. **Comparison and Validation:**
   - **MUST use testing-qa-specialist agent for all screenshot comparison tasks**
   - Compare baseline vs post-development screenshots systematically
   - Document any differences found
   - Verify differences are intentional or unintentional bugs
   - For unintentional changes, fix code and re-test

### Screenshot Naming Convention
- Format: `{phase}-{feature}-{step}.png`
- Examples: `baseline-pdf-upload-form.png`, `post-dev-asset-library-display.png`

### Common Workflows to Test
- Asset creation: Import Assets > PDF > Upload > Publish
- Asset library display and filtering
- Research library public display
- Admin tool functionality

## Research Library Access

### Important Note
UserEvidence account (main account) is intentionally hidden from research library index page (`http://localhost:3000/user-research-library`). The index filters out accounts with IDs 1, 2, and 3 by design.

### Accessing UserEvidence Account Assets
- Navigate directly to: `http://localhost:3000/user-research-library/main-account`
- This bypasses account filtering and shows the account's public assets
- Individual assets: `http://localhost:3000/assets/{identifier}`

### Testing FileAssets and MediaViewer
1. Use direct account URL: `/user-research-library/main-account`
2. Use direct asset URLs: `/assets/{identifier}` (get identifier from database)
3. Test both approaches to verify MediaViewer works in public-facing contexts