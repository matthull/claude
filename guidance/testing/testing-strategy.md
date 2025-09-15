---
type: guidance
status: current
category: testing
---

# Testing Strategy

## Overview
Comprehensive testing approach ensuring code quality through multiple layers of verification.

## Core Concepts

### Tests Are Part of the Feature
- **Never optional** - Every feature includes tests
- **Written alongside code** - Not as afterthought
- **Living documentation** - Tests show intended usage
- **Maintained with code** - Updated when behavior changes

### Testing Pyramid
- **Unit Tests (70%)** - Fast, isolated, numerous
- **Integration Tests (20%)** - Key workflows
- **E2E Tests (10%)** - Critical user paths only

### Test Structure
- **Arrange** - Set up test context
- **Act** - Execute behavior
- **Assert** - Verify outcome
- **Cleanup** - Reset if needed

## When to Apply
- New feature development
- Bug fixes (write failing test first)
- Refactoring (ensure tests exist first)
- API contract changes
- Performance optimizations

## Testing Principles

### What to Test
- Happy path functionality
- Edge cases and boundaries
- Error conditions
- Security and authorization
- Performance requirements
- Integration points

### What NOT to Test
- Framework functionality
- Third-party libraries
- Implementation details
- Private/internal methods directly

### Test Quality
- **Fast** - Milliseconds for unit tests
- **Isolated** - No test depends on another
- **Repeatable** - Same result every run
- **Self-validating** - Clear pass/fail
- **Timely** - Written with the code

## Anti-patterns
- Tests that depend on execution order
- Testing multiple behaviors in one test
- Hardcoded test data
- Tests slower than 1 second (unit)
- Always-passing tests
- Flaky/intermittent failures
- Excessive mocking
- No assertions

