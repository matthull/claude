---
type: task-template
section: vue-component
description: Vue component patterns, Storybook development, CSS architecture
applies_to: vue
source_guidance:
  global:
    - frontend/css-architecture
    - frontend/debugging-workflow
    - code-quality/immediately-runnable-code
---

## CRITICAL: Storybook is MANDATORY for Components (ABSOLUTE)

**You MUST NEVER skip Storybook stories for presentational components**

**RATIONALE:** Storybook is the primary development and verification tool for Vue components. Without stories, components cannot be properly developed or reviewed.

**Testing Strategy for Vue**:
- **Vitest tests**: ONLY for JavaScript utility modules/composables (NOT components)
- **Storybook stories**: MANDATORY for ALL presentational components
- **Loop 2 verification**: Check ALL modified component stories (like verify-specs.sh)

**You MUST NEVER**:
- ❌ Skip creating Storybook stories for components
- ❌ Write Vitest tests for presentational components
- ❌ Develop components without Storybook running

**You MUST ALWAYS**:
- ✅ Create Storybook stories BEFORE implementing component
- ✅ Use Storybook for visual development (Loop 1)
- ✅ Write Vitest tests ONLY for utilities/composables (Loop 1 only)
- ✅ Verify ALL component stories in Loop 2

---

## Vue Component Implementation Details

### Component Structure

```vue
<script setup lang="ts">
{COMPONENT_SCRIPT}
</script>

<template>
  {COMPONENT_TEMPLATE}
</template>

<style scoped>
{COMPONENT_STYLES}
</style>
```

**Pattern Examples**:
```vue
<script setup lang="ts">
// Props with TypeScript interface
interface Props {
  title: string
  items: Item[]
  variant?: 'primary' | 'secondary'
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary'
})

// Emits (typed)
const emit = defineEmits<{
  select: [item: Item]
  close: []
}>()

// Reactive state
const selectedItem = ref<Item | null>(null)

// Computed
const hasItems = computed(() => props.items.length > 0)

// Methods
function handleSelect(item: Item) {
  selectedItem.value = item
  emit('select', item)
}
</script>

<template>
  <div :class="['component-name', `component-name--${variant}`]">
    <h2>{{ title }}</h2>
    <ul v-if="hasItems">
      <li
        v-for="item in items"
        :key="item.id"
        @click="handleSelect(item)"
      >
        {{ item.name }}
      </li>
    </ul>
    <p v-else class="component-name__empty">No items available</p>
  </div>
</template>

<style scoped>
/* Use design tokens, never hardcoded values */
.component-name {
  padding: var(--spacing-md);
  background: var(--color-background);
}

.component-name--primary {
  border: 1px solid var(--color-primary);
}

.component-name__empty {
  color: var(--color-text-muted);
}
</style>
```

### Loop Commands

**Loop 1: Storybook Development Loop (for components) OR Vitest (for utilities)**

**For Components**:
```bash
npm run storybook
# Browser: http://localhost:6006
# Navigate to: Components → {ComponentName}
# Verify: Component renders and interactions work
# Test: All stories display correctly
```

**For Utilities/Composables**:
```bash
vitest src/utils/{utilityName}.spec.ts
# OR
vitest src/composables/{composableName}.spec.ts
```

**Purpose**: Primary development loop - Storybook for UI, Vitest for logic

**Loop 2: Storybook Story Verification (MANDATORY)**

```bash
# Open Storybook
npm run storybook

# Browser: http://localhost:6006
# Manually verify ALL created/modified component stories:
# 1. Navigate to each modified component
# 2. Check ALL stories render without errors
# 3. Verify interactions work in each story
# 4. Check console for errors (F12)
```

**MANDATORY before marking ANY task complete**

**Verification Checklist**:
- [ ] All created components have stories
- [ ] All modified components' stories checked
- [ ] No console errors in any story
- [ ] All story variants render correctly
- [ ] Interactive elements work in Storybook

**Note**: Vitest is NOT run in Loop 2 (local environment issues). Only utility tests run in Loop 1.

**Loop 3: Browser Verification (OPTIONAL - requires user approval to skip)**

**When Loop 3 is REQUIRED**:
- ✅ Multi-step user flows (forms, wizards)
- ✅ Complex state management across routes
- ✅ Browser-specific behavior (scroll, focus, resize)
- ✅ Integration with backend APIs
- ✅ Responsive layout verification

**When Loop 3 MAY BE SKIPPED** (with user approval):
- ⚠️ Simple presentational components with complete Storybook coverage
- ⚠️ Pure UI components with no backend integration
- ⚠️ Storybook stories provide 100% confidence

**Stop and Ask Protocol**:
```
Before skipping Loop 3, you MUST ask:
"This component is [description]. Storybook stories provide [level] confidence.
May I skip Loop 3 browser verification, or would you like me to perform manual QA?"
```

**Browser Verification Procedure**:
```bash
npm run dev
# Browser: http://localhost:{PORT}

# CRITICAL: Check console FIRST (frontend debugging workflow)
# 1. Open browser DevTools (F12)
# 2. Check console for errors BEFORE any interaction
# 3. Check network tab for failed requests
# 4. If errors found, check Rails logs for backend issues

# Navigate to: {ROUTE_PATH}
# Test: {MANUAL_VERIFICATION_STEPS}
```

### Storybook Stories Structure (MANDATORY)

**File**: `src/components/{ComponentName}.stories.ts`

**You MUST create stories for**:
- Default/typical state
- Empty state (if applicable)
- Loading state (if applicable)
- Error state (if applicable)
- Edge cases (long text, many items, etc.)

```typescript
import type { Meta, StoryObj } from '@storybook/vue3'
import ComponentName from './ComponentName.vue'

const meta: Meta<typeof ComponentName> = {
  title: 'Components/ComponentName',
  component: ComponentName,
  tags: ['autodocs'],
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary']
    },
    onSelect: { action: 'select' },
    onClose: { action: 'close' }
  }
}

export default meta
type Story = StoryObj<typeof ComponentName>

// Default state (REQUIRED)
export const Default: Story = {
  args: {
    title: 'Example Title',
    items: [
      { id: 1, name: 'Item 1' },
      { id: 2, name: 'Item 2' }
    ]
  }
}

// Empty state (REQUIRED if applicable)
export const Empty: Story = {
  args: {
    title: 'No Items',
    items: []
  }
}

// Variants (REQUIRED if component has variants)
export const Secondary: Story = {
  args: {
    ...Default.args,
    variant: 'secondary'
  }
}

// Edge cases (REQUIRED)
export const ManyItems: Story = {
  args: {
    title: 'Many Items',
    items: Array.from({ length: 20 }, (_, i) => ({
      id: i + 1,
      name: `Item ${i + 1}`
    }))
  }
}

export const LongText: Story = {
  args: {
    title: 'Very Long Title That Should Handle Text Wrapping Gracefully',
    items: [
      { id: 1, name: 'Item with very long name that tests text overflow behavior' }
    ]
  }
}
```

### Utility/Composable Test Structure (ONLY for non-component code)

**File**: `src/composables/{composableName}.spec.ts`

**Only write Vitest tests for**:
- Utility functions (formatting, validation, etc.)
- Composables (useApi, useLocalStorage, etc.)
- Business logic helpers
- NOT for Vue components

```typescript
import { describe, it, expect } from 'vitest'
import { useItemSelection } from './useItemSelection'

describe('useItemSelection', () => {
  it('initializes with no selection', () => {
    const { selected } = useItemSelection(ref([]))

    expect(selected.value).toBeNull()
  })

  it('selects item when select called', () => {
    const items = ref([{ id: 1, name: 'Item 1' }])
    const { selected, select } = useItemSelection(items)

    select(items.value[0])

    expect(selected.value).toEqual({ id: 1, name: 'Item 1' })
  })
})
```

### Code Quality Checklist

**Before Completing Task**:
- [ ] **CRITICAL: Storybook stories created for ALL presentational components**
- [ ] **CRITICAL: ALL component stories verified in Storybook (Loop 2)**
- [ ] **NO Vitest tests for components** (only for utilities/composables)
- [ ] **NO hardcoded CSS values** (use design tokens/variables only)
- [ ] **NO !important in styles**
- [ ] **Console checked on page load** (frontend debugging workflow)
- [ ] TypeScript types defined for all props and emits
- [ ] No `any` types (use proper type definitions)
- [ ] No console.log statements
- [ ] Component complexity reasonable (< 200 lines per file)
- [ ] Accessibility attributes (aria-labels, roles, etc.)
- [ ] Responsive design (mobile-first approach)
- [ ] CSS follows semantic naming

### CSS Architecture Principles

**Design System Integration** (MANDATORY):
```vue
<style scoped>
/* GOOD: Use design tokens */
.component {
  padding: var(--spacing-md);
  color: var(--color-text-primary);
  font-size: var(--font-size-base);
}

/* BAD: Hardcoded values */
.component {
  padding: 16px;        /* ❌ Use var(--spacing-md) */
  color: #333;          /* ❌ Use var(--color-text-primary) */
  font-size: 14px;      /* ❌ Use var(--font-size-base) */
}
</style>
```

**Specificity Management**:
- Maximum 3 levels of nesting
- Target classes, not elements
- Component isolation (no leaking styles)
- Never use !important

**Responsive Strategy**:
- Mobile-first approach
- Use relative units (rem, em, %)
- Fluid typography and spacing

### Vue/TypeScript Patterns

**Props Definition**:
```typescript
// GOOD: Strongly typed with interface
interface Props {
  title: string
  count?: number
  variant?: 'primary' | 'secondary'
}
const props = withDefaults(defineProps<Props>(), {
  count: 0,
  variant: 'primary'
})

// BAD: No types
const props = defineProps(['title', 'count'])  // ❌
```

**Emits Definition**:
```typescript
// GOOD: Typed emits
const emit = defineEmits<{
  update: [value: string]
  close: []
}>()

// BAD: Untyped
const emit = defineEmits(['update', 'close'])  // ❌
```

### Canonical Examples (Project-Specific)

**These are exemplar implementations. Read and follow their patterns.**

#### Components

**Form Components** - Read: `src/components/forms/SeismicFolderSelector.vue`
```
Use when: Form inputs, selectors, form controls
Patterns:
- v-model implementation
- Form validation
- Error state handling
- Accessibility (labels, aria)
- Storybook stories with form states
```

**List Components** - Read: `src/components/lists/AssetList.vue`
```
Use when: Lists of items with interactions
Patterns:
- v-for with :key
- Selection/hover states
- Empty states
- Loading states
- Storybook stories for all states
```

**Modal Components** - Read: `src/components/dialogs/ConfirmDialog.vue`
```
Use when: Overlays, modals, dialogs
Patterns:
- Focus trapping
- ESC key handling
- Click outside to close
- Portal/teleport usage
- Storybook with interaction addon
```

#### Composables

**Data Fetching** - Read: `src/composables/useApi.ts`
```
Use when: Fetching data from APIs
Patterns:
- Loading/error state management
- Reactive data updates
- Cleanup on unmount
- Vitest tests for composable logic
```

**State Management** - Read: `src/stores/assetStore.ts`
```
Use when: Sharing state across components
Patterns:
- Pinia store setup
- Actions and getters
- Type-safe state access
```

#### Storybook Examples

**Component Stories** - Read: `src/components/SeismicFolderSelector.stories.ts`
```
Use when: Writing any component stories
Patterns:
- Story structure and args
- Interactive controls
- Multiple variants
- Edge case coverage
```

### Common Anti-patterns to Avoid

**You MUST NEVER**:
- ❌ **Skip Storybook stories for presentational components**
- ❌ **Skip Loop 2 story verification** (ALL modified components must be checked)
- ❌ **Write Vitest tests for components** (Storybook is the test)
- ❌ **Use hardcoded CSS values** (use design tokens only)
- ❌ **Use !important in styles**
- ❌ **Skip console check before debugging** (check console FIRST)
- ❌ Use `any` type (define proper TypeScript types)
- ❌ Mutate props directly (props are readonly)
- ❌ Use Vue 2 patterns (Options API, $emit, etc.)
- ❌ Put business logic in components (use composables)
- ❌ Use inline styles for layout
- ❌ Nest selectors more than 3 levels deep

**Prefer**:
- ✅ Storybook for component development and verification
- ✅ Manual story verification in Loop 2 (like verify-specs.sh)
- ✅ Vitest only for utilities/composables (Loop 1 only)
- ✅ Composition API with `<script setup>`
- ✅ TypeScript for all components
- ✅ Design tokens for all CSS values
- ✅ Composables for shared logic
- ✅ Scoped styles with semantic class names
- ✅ Mobile-first responsive design
- ✅ Check console first when debugging
