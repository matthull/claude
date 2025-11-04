---
type: guidance
status: current
category: vue

# Automatic triggers
file_triggers:
  - "*.vue"
  - "*.scss"
  - "*.css"
directory_triggers:
  - "src/components/**"
  - "app/assets/stylesheets/**"
---

# Frontend Styling Patterns

## CSS Architecture Principles

### Specificity Management
- Avoid using !important - use CSS layers for third-party overrides
- Prefer class selectors over element selectors
- Avoid deep selectors that are fragile
- Keep specificity as low as possible
- Use CSS cascade intentionally

### Selector Strategy
- Target classes instead of HTML tags
- Use specific, semantic class names
- Avoid overly complex selectors
- Prefer composition over nesting
- Document unusual selectors

## Bootstrap Integration

### Framework Usage
- Use Bootstrap CSS classes extensively
- Understand Bootstrap's utility classes
- Leverage Bootstrap's grid system
- Use Bootstrap's responsive helpers
- Extend Bootstrap through Sass variables

### Component Libraries
- Use native Bootstrap CSS over component libraries
- Avoid Bootstrap-Vue in new components
- Migrate away from deprecated libraries gradually
- Prefer CSS solutions over JavaScript when possible
- Document any exceptions

## Sass Best Practices

### Variable Usage
- Use Sass variables from `_variables.sass`
- Never hardcode colors directly
- Follow hierarchical variable system
- Use most specific variable available (e.g., `$border-color` over `$ueLightGray`)
- Document custom variables

### Variable Hierarchy
- Arbitrary values → Brand variables → Theme variables
- Never use theme variables to define brand variables
- Keep variable names semantic
- Group related variables together
- Document variable purposes

### CSS Custom Properties
- Prefer CSS variables over SASS variables
- Use custom properties for theming
- Keep custom property names consistent
- Document custom property contracts
- Provide fallback values

## Spacing and Layout

### Margin Philosophy
- Components don't set their own external margins
- Parent components control child spacing
- Prefer top margins over bottom margins
- Use consistent spacing scale
- Document spacing exceptions

### Layout Patterns
- Use CSS Grid for 2D layouts
- Use Flexbox for 1D layouts
- Avoid absolute positioning when possible
- Let content determine dimensions
- Test responsive behavior

### Spacing Scale
- Use consistent spacing units
- Follow Bootstrap's spacing utilities
- Document custom spacing needs
- Avoid arbitrary spacing values
- Maintain vertical rhythm

## Responsive Design

### Breakpoint Strategy
- Use Bootstrap's breakpoint system
- Design mobile-first
- Test at all breakpoints
- Avoid breakpoint-specific hacks
- Document breakpoint decisions

### Responsive Patterns
- Use responsive utilities classes
- Hide/show elements appropriately
- Adjust typography for readability
- Maintain functionality across sizes
- Test touch interactions

## Icon Management

### Icon Systems
- Use Bootstrap Icons as primary icon set: `<i class="bi bi-activity" />`
- **NEVER** use BootstrapVue icons
- **NEVER** use custom icons from `app/javascript/src/components/graphics`
- Avoid "Max Icons" unless documented exception
- Load icons efficiently
- Keep icon usage consistent
- Provide text alternatives

### SVG Handling
- Import SVGs with proper suffix for raw import
- Use v-html with svg prefix for inline SVGs
- Optimize SVGs before importing
- Keep SVG markup clean
- Document custom SVG usage

## Performance Optimization

### CSS Efficiency
- Minimize CSS bundle size
- Remove unused styles
- Use CSS containment when appropriate
- Optimize critical rendering path
- Lazy load non-critical styles

### Animation Performance
- Use CSS transforms for animations
- Avoid animating expensive properties
- Use will-change sparingly
- Test animation performance
- Provide reduced motion alternatives

## Theming Support

### Theme Architecture
- Structure styles for easy theming
- Use CSS custom properties for theme values
- Keep theme logic centralized
- Test all theme variations
- Document theme customization

### Dark Mode Considerations
- Design with dark mode in mind
- Use semantic color variables
- Test contrast ratios
- Handle images appropriately
- Provide smooth transitions

## Accessibility in Styling

### Visual Accessibility
- Ensure sufficient color contrast
- Don't rely on color alone
- Make focus indicators visible
- Support zoom without breaking layout
- Test with accessibility tools

### Motion Accessibility
- Respect prefers-reduced-motion
- Provide alternatives to motion
- Keep animations subtle
- Avoid rapid flashing
- Document motion requirements

## Code Organization

### File Structure
- Keep component styles with components
- Organize global styles logically
- Separate utilities from components
- Document style architecture
- Maintain consistent structure

### Style Documentation
- Comment complex styles
- Document magic numbers
- Explain browser workarounds
- Note performance optimizations
- Maintain style guide

## Testing Styles

### Visual Testing
- Use Storybook for component styles
- Test responsive behavior
- Verify cross-browser compatibility
- Check print styles
- Validate accessibility

### Regression Prevention
- Take screenshots for comparison
- Test style changes thoroughly
- Document expected behavior
- Monitor CSS bundle size
- Review style changes carefully

## Anti-patterns to Avoid

### CSS Smells
- Using !important (use CSS layers for 3rd party overrides if needed)
- Inline styles in templates
- Global styles from components (always use `scoped` directive in Vue components)
- Hardcoded dimensions
- Hardcoded color values (always use sass variables from _variables.sass)
- Hardcoded margins in component templates (let parent context control spacing)
- HTML tag selectors (target classes instead)
- Deep selectors (prefer `.save-button` over `.content div .buttons button#save`)
- Magic numbers without explanation
- Overly nested selectors
- Duplicate style definitions
- Browser-specific hacks
- Absolute positioning for layout
- Fixed pixel values for responsive design
- Bottom margins (prefer top margins for spacing)

### Maintenance Issues
- Undocumented workarounds
- Inconsistent spacing
- Mixed unit types
- Unclear class names
- Missing responsive considerations
- Ignored accessibility
- Untested browser compatibility
- Fragile selectors