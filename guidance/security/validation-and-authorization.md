---
type: guidance
status: current
category: security
tags:
- security
focus_levels:
- design
- implementation
---

# Validation and Authorization Principles

## Core Concepts

### Input Validation
- **Never trust client data** - All validation must be server-side
- **Whitelist over blacklist** - Define what's allowed, reject everything else
- **Validate at boundaries** - Every entry point to the system
- **Sanitize for context** - Different rules for HTML, SQL, shell, URLs

### Authorization Principles
- **Check at every layer** - UI, API, service, database
- **Fail secure** - Default to denying access
- **Least privilege** - Minimum access required for operation
- **Separate authentication from authorization** - Different concerns

### Defense in Depth
- **Multiple validation layers** - Client (UX), server (security)
- **Assume breach** - What if first layer fails?
- **Audit everything** - Log security-relevant events
- **Time-based restrictions** - Consider when, not just who

## When to Apply
- Every user input point
- All API endpoints
- File uploads and downloads
- Database queries with user data
- Cross-service communication
- Administrative operations

## Implementation Patterns

### Validation Strategy
1. **Type checking** - Ensure correct data type
2. **Range validation** - Min/max values, string lengths
3. **Format validation** - Email, phone, URL patterns
4. **Business rules** - Domain-specific constraints
5. **Referential integrity** - Valid foreign keys

### Authorization Patterns
- **Role-based (RBAC)** - Users have roles, roles have permissions
- **Attribute-based (ABAC)** - Decisions based on attributes
- **Resource-based** - Check ownership and access rules
- **Hierarchical** - Inherited permissions from parent resources

### Common Attack Prevention
- **SQL Injection** - Use parameterized queries
- **XSS** - Context-aware output encoding
- **Path Traversal** - Validate and sandbox file paths
- **CSRF** - Token validation for state changes
- **Rate Limiting** - Prevent abuse and DoS

## Anti-patterns
- Client-side validation only
- Blacklisting bad input instead of whitelisting
- Mixing authorization with business logic
- Hardcoded credentials or permissions
- Logging sensitive data
- Generic error messages that leak info
- Trusting HTTP headers for security
- Using predictable tokens

