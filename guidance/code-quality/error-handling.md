---
type: guidance
status: current
category: code-quality
---

# Error Handling Principles

## Overview
Structured approach to error handling that provides meaningful user feedback while maintaining system stability and debuggability.

## Core Concepts

### User-Facing Errors
- **Never use console/print for user errors** - Users don't check debug output
- **Never use modal alerts** - Disrupts user experience
- **Provide actionable messages** - What went wrong and what to do
- **Use appropriate UI patterns** - Toast notifications, inline errors, status messages

### Developer-Facing Logging
- **Structured error reporting** - Consistent format with context
- **Central error tracking** - Aggregate errors in one place
- **Include relevant context** - User ID, action, timestamp, request data
- **Different verbosity by environment** - Verbose in dev, concise in production

### Error Categories
- **Validation errors** - User can fix by changing input
- **Authorization errors** - User lacks permission
- **System errors** - Infrastructure/network issues
- **Logic errors** - Bugs that need developer attention

## When to Apply
- All user-facing operations that can fail
- API endpoints and service boundaries
- Data validation and processing
- External service integrations
- Background job processing

## Implementation Patterns

### Error Response Structure
- Consistent error format across system
- Include error type/code for programmatic handling
- Human-readable message for display
- Additional details/context when helpful
- Request/correlation ID for tracking

### Recovery Strategies
- **Retry with backoff** - For transient failures
- **Fallback values** - Graceful degradation
- **Circuit breakers** - Prevent cascade failures
- **Error boundaries** - Contain failures to components

## Anti-patterns
- Swallowing errors silently
- Generic "Something went wrong" messages
- Exposing internal details to users
- Logging sensitive data (passwords, tokens)
- Using exceptions for control flow
- Not distinguishing error types
- Inconsistent error formats

