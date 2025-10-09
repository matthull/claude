---
type: guidance
status: current
category: vue
tags:
- frontend
- code-quality
focus_levels:
- implementation
---

# Frontend Code Quality Standards

## Date Handling
- Use `dayjs` for all date formatting (installed globally)
- Consistent date format across application
- Handle timezones explicitly

## Common Utilities

### Bootstrap Framework
- Use Bootstrap 4 CSS extensively
- Leverage utility classes
- Use grid system
- Follow Bootstrap conventions

### Component Standards
- Always use `scoped` directive
- Avoid deep selectors
- Multi-word component names required

## Code Comments
- Avoid useless comments
- Code should be self-documenting
- Comment complex business logic only
- Document workarounds with rationale

## Linting Requirements

### ESLint
- Run: `docker exec musashi-web-1 yarn eslint`
- All warnings in new code **MUST** be resolved
- Existing warnings resolved unless scope increases significantly

### Auto-fix
- Use ESLint auto-fix where applicable
- Review auto-fix changes before committing
- Some issues require manual resolution

## Anti-patterns
- Never use useless comments
- Never ignore ESLint warnings in new code
- Never hardcode values that should be configurable
- Never duplicate utility functions
