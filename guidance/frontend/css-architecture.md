---
type: guidance
status: current
category: frontend
---

# CSS Architecture Principles

## Overview
Maintainable, scalable CSS architecture that avoids specificity wars and promotes component reusability.

## Core Concepts

### Specificity Management
- **Never use !important** - Use CSS layers or refactor instead
- **Avoid deep nesting** - Maximum 3 levels, prefer flat
- **Target classes, not elements** - More maintainable and predictable
- **Component isolation** - Styles shouldn't leak between components

### Design System Integration
- **No hardcoded values** - Use design tokens/variables
- **Consistent spacing scale** - 4px, 8px, 16px, 24px, etc.
- **Colors from palette only** - No arbitrary color values
- **Typography scale** - Predefined sizes, not arbitrary

### Naming & Organization
- **Semantic class names** - Describe purpose, not appearance
- **Consistent methodology** - BEM, atomic, or utility-first
- **Predictable file structure** - Components, utilities, base styles
- **Clear inheritance hierarchy** - Base → Theme → Component

## When to Apply
- Creating new components or features
- Refactoring existing styles
- Setting up design systems
- Resolving specificity conflicts
- Implementing theming/dark mode

## Implementation Patterns

### Variable Architecture
1. **Design tokens** - Raw values (colors, sizes)
2. **Semantic variables** - Purpose-based (primary, background)
3. **Component variables** - Scoped customization points

### Component Boundaries
- Components don't set external margins
- Parent controls child spacing
- Use composition over inheritance
- Prefer CSS custom properties for theming

### Responsive Strategy
- Mobile-first approach
- Use relative units (rem, em, %)
- Container queries over media queries where possible
- Fluid typography and spacing

## Anti-patterns
- Using IDs for styling
- Styling HTML elements directly
- !important declarations
- Inline styles for layout
- Deep selector nesting (.a .b .c .d)
- Hardcoded colors or dimensions
- Component styles affecting siblings
- Mixing concerns (layout in components)

