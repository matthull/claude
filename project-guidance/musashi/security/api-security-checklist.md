---
type: guidance
status: current
category: security
tags:
- backend
- security
- api
focus_levels:
- strategic
- design
- implementation
---

# API Security Checklist (MANDATORY)

## Authentication & Authorization (CRITICAL)

### Controller Requirements
You **MUST NEVER** merge code with:
- Missing authentication checks
- Missing authorization checks
- Client-side-only access control

**RATIONALE:** Unauthenticated/unauthorized access = data breach.

### Verification Pattern
```ruby
before_action :authenticate_user!
before_action :authorize_resource

def authorize_resource
  @resource = current_user.resources.find(params[:id])
end
```

## Input Validation (ABSOLUTE)

### Strong Parameters
You **MUST ALWAYS**:
- Use strong parameters
- Never use `permit!`
- Validate parameter types
- Sanitize string inputs

### SQL Safety
You **MUST NEVER**:
- Write raw SQL queries
- Interpolate user input into SQL
- Use `find_by_sql` with user data

**RATIONALE:** SQL injection = complete database compromise.

## Data Exposure Prevention

### Response Filtering
- Never expose password hashes
- Never expose internal IDs unnecessarily
- Never expose admin-only fields
- Never expose raw error messages
- Check jbuilder files for leaks

### Error Handling
- Never leak stack traces
- Never reveal database structure
- Never expose internal logic
- Use generic error messages publicly
- Log detailed errors internally

## Authorization Patterns

### Resource Ownership
```ruby
# CORRECT: Scope by current user
@resources = current_user.resources

# WRONG: Global scope
@resources = Resource.all
```

### Nested Resources
```ruby
# CORRECT: Verify parent ownership
@project = current_user.projects.find(params[:project_id])
@task = @project.tasks.find(params[:id])

# WRONG: Trust URL parameters
@task = Task.find(params[:id])
```

## Rate Limiting

### Sensitive Endpoints
- Login/logout endpoints
- Password reset
- Search endpoints
- Export operations
- Email sending

## Security Review Checklist
- [ ] Authentication required
- [ ] Authorization verified
- [ ] Strong parameters used
- [ ] No raw SQL
- [ ] No sensitive data in responses
- [ ] Error messages sanitized
- [ ] Rate limits on sensitive endpoints
- [ ] Input validated server-side
- [ ] Client data never trusted
