---
type: guidance
status: current
category: vue
tags:
- frontend
- vue
focus_levels:
- implementation
---

# Vue 3 Migration Rules (MANDATORY)

## Composition API Requirements

### New Components (ABSOLUTE)
You **MUST ALWAYS** use:
```vue
<script setup lang="ts">
// Composition API only
</script>
```

You **MUST NEVER** use:
```vue
<script>
export default {
  // Options API forbidden
}
</script>
```

**RATIONALE:** Options API = technical debt during migration.

## Deprecated Libraries (MUST REMOVE)

### Forbidden in New Code
- `vue-easy-toast`
- `vue-select`
- `vue-pagination-2`
- `vue-clickaway`
- `v-scroll-sync`
- `vue-bootstrap` (all components)
- BootstrapVue icons

### Replacements
- Toast: Use project toast system
- Select: Native or project component
- Pagination: Custom implementation
- Modal: `UEModal.vue` component
- Icons: Bootstrap Icons (`<i class="bi bi-activity" />`)

## Component Standards

### Naming
- Multi-word names required
- PascalCase in script
- kebab-case in templates

### Import Paths
You **MUST ALWAYS** use TypeScript aliases:
- `@components/*`
- `@lib/*`
- `@stores/*`

You **MUST NEVER** use relative imports:
```typescript
// WRONG
import Foo from '../../components/Foo.vue'

// CORRECT
import Foo from '@components/Foo.vue'
```

## Error Handling

### Toast + Error Reporter Pattern
```typescript
import { reportError } from '@lib/errorHandler'

async function process() {
  try {
    await apiCall()
  } catch (e) {
    this.$toast.error('Operation failed.')
    reportError(e, 'process', 'ComponentName')
  }
}
```

You **MUST NEVER**:
- Use `console.log` for errors
- Use `alert()` for user feedback
- Swallow errors silently

## Migration Checklist
- [ ] `<script setup lang="ts">` used
- [ ] No Options API
- [ ] No deprecated libraries
- [ ] TypeScript aliases used
- [ ] Multi-word component names
- [ ] Bootstrap Icons used
- [ ] UEModal for modals
- [ ] Toast + errorHandler for errors
- [ ] No console.log/alert
