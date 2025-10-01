---
type: guidance
status: current
category: development-process
tags:
- software-dev
---

# 🚨 CRITICAL: NEVER GUESS INTERFACES 🚨

## THE IRON RULE
**STOP. SEARCH. VERIFY. OR ASK.**

Never guess:
- Model properties
- Function signatures
- API endpoints
- Database fields
- Configuration keys
- Library methods

## MANDATORY WORKFLOW

### 1. SEARCH FIRST
```bash
# ALWAYS run these before writing code:
grep -r "ClassName" --include="*.rb" --include="*.js"
grep -r "function_name(" --include="*.py"
grep -r "/api/endpoint" --include="*.js" --include="*.ts"
```

### 2. READ ACTUAL CODE
```bash
# Find real usage, not your imagination:
cat app/models/user.rb          # See ACTUAL attributes
cat src/api/endpoints.js        # See REAL endpoints
cat db/schema.rb                # See TRUE schema
```

### 3. ASK IF UNSURE
```
"I need to verify the User model properties.
Could you show me the model definition or schema?"
```

## FORBIDDEN PATTERNS

### ❌ NEVER DO THIS:
```ruby
# Guessing model has 'name' field
user.name = "John"  # WRONG - you didn't verify

# Assuming API path exists
fetch('/api/users/profile')  # WRONG - you didn't check

# Inventing function signature
processData(data, options, callback)  # WRONG - you didn't search
```

### ✅ ALWAYS DO THIS:
```bash
# First: grep -r "User" app/models/
# Then: cat app/models/user.rb
# ONLY THEN write code using verified attributes
```

## RED FLAGS IN YOUR THINKING

STOP if you think:
- "It probably has..."
- "Usually this would..."
- "Standard practice is..."
- "It should have..."
- "I'll assume..."

INSTEAD:
- "Let me search for..."
- "I'll verify by reading..."
- "I need to check..."

## ENFORCEMENT

**BEFORE EVERY CODE EDIT:**
1. Did I search for this interface?
2. Did I read the actual definition?
3. Am I 100% certain, or guessing?

**If guessing → STOP → SEARCH → VERIFY**

No exceptions. Ever.