---
type: guidance
status: current
category: frontend
tags:
- frontend
focus_levels:
- design
- implementation
---

# Frontend Debugging Workflow

## Page Load Protocol

### Always on Page Load
- Check browser console for errors immediately
- Note any console errors before proceeding

## Browser Issue Protocol

### Check Order
1. Browser console for JS errors
2. Network tab for failed requests
3. Rails logs for backend errors (if network error)

### Never
- Work on page without checking console
- Guess without checking console
- Skip network tab inspection
- Assume frontend-only issue

### Always
- Check console on every page load
- Check browser console first for issues
- Inspect network errors
- Verify Rails logs for 4xx/5xx responses