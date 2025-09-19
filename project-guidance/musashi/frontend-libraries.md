---
type: guidance
status: current
category: frontend
---

# Frontend Libraries and Dependencies

## API Data Format - Snake Case
- **CRITICAL**: API responses from Rails use snake_case format exclusively
- There is NO translation layer to convert to camelCase
- Always access API response data using snake_case keys:
  - `response.user_name` NOT `response.userName`
  - `data.created_at` NOT `data.createdAt`
  - `item.is_active` NOT `item.isActive`
- This applies to all API responses: JSON, jbuilder views, error messages
- Component props and internal state can use camelCase, but API data access must use snake_case

## Vue 2 Dependencies
- Replace bootstrap-js-modal with UEModal.vue component
- Avoid Vue 2 libraries (flag when seen): vue-easy-toast, vue-select, vue-pagination-2, vue-clickaway, v-scroll-sync

## ESLint Warnings
- Resolve all warnings in new code
- Resolve existing warnings unless it significantly increases PR scope

## Imports & Paths
- Avoid relative path imports - use TypeScript aliases (@components/_, @lib/_, etc.)

## Error Handling
- **Never** use `console.log` or `alert` for user-facing errors
- Use toast system and `errorHandler.ts` for proper error reporting
```js
import { reportError } from '@lib/errorHandler'
process().catch((e) => {
  this.$toast.error('Something went wrong.')
  reportError(e, 'process', 'ComponentName')
})
```

## Framework Usage
- Use Bootstrap 4 CSS framework extensively
- **Never** use vue-bootstrap in new components
- Transition existing vue-bootstrap usage when modifying components

## Icons & SVGs
- Use Bootstrap icons: `<i class="bi bi-activity" />`
- **Never** use BootstrapVue icons
- Avoid custom icons unless absolutely necessary
- Avoid "Max Icons" from `app/javascript/src/components/graphics`
- For SVGs: import with `?raw` suffix and use `v-html` with "svg" prefix

## Date Formatting
- Use dayjs for all date formatting - it's installed and configured globally
- Global Vue filter available: `{{ date | dayjs('MMM D, YYYY') }}`
- Import in components: `import dayjs from 'dayjs'`
- Common formats: `MMM D, YYYY` (Jan 15, 2025), `MMM D` (Jan 15)

## Semantic Markup
- Use HTML tags for semantic meaning, CSS for appearance
- Example: Use correct heading hierarchy, style with CSS