---
description: Create or update the feature specification from a natural language feature description.
allowed-tools: Read, Glob, Grep, Task, Write, Edit, Bash(find:*), Bash(rg:*), AskUserQuestion
argument-hint: '<feature-name-or-description>'
---

# Technical Specification Command

Create a well-researched technical specification that defines WHAT to build, not HOW to build it.

## Input

Feature description: `$ARGUMENTS`

---

## Core Principles

### 1. WHAT, Not HOW

Specs define outcomes, contracts, and responsibilities - never implementation details.

| SPECIFY | DON'T SPECIFY |
|---------|---------------|
| API endpoints & response shapes | Service class internals |
| Data model fields & relationships | Helper method implementations |
| Component responsibilities | File organization |
| UI structure (wireframe-level) | CSS/styling details |
| Test scenarios (behaviors to verify) | Test implementation |
| Method signatures | Method bodies |

### 2. Minimal Code in Specs

Small reference snippets (1-5 lines) for context are acceptable. Full implementations are not.

**Acceptable:**
```typescript
// Response shape
{ total_engagements: number, unique_users: number }
```

**Not acceptable:**
```ruby
# Full service implementation
class EngagementService
  def initialize(account:, start_date:, end_date:)
    @account = account
    # ... 50 more lines
  end
end
```

### 3. Brownfield First (CRITICAL)

Before specifying ANYTHING new, exhaustively search for existing solutions.

@~/.claude/guidance/development-process/brownfield-development.md

**Discovery questions:**
- Does a similar pattern already exist?
- Can an existing model/service be EXTENDED instead of creating new?
- What conventions does the codebase follow for similar features?
- Are there tests covering related functionality to learn from?

**Pattern discovery:**
```bash
rg "SimilarPattern" --type ruby
rg "relatedEndpoint" --type ts
find app/ -name "*related*"
find spec/ -name "*similar*_spec.rb"
```

### 4. Let Abstractions Emerge

Don't pre-plan internal structure. Let complexity drive extraction.

| Anti-Pattern | Better Approach |
|--------------|-----------------|
| "Create UserEngagementService" | Describe the data contract; implementation structure emerges during coding |
| "Add helper module for X" | Describe what X does; extract helper only when complexity demands |
| "Organize into these files" | Describe responsibilities; file organization follows naturally |

### 5. Third-Party API Research

When specs involve external systems, research official documentation FIRST and create project-specific API reference docs.

@~/.claude/guidance/api-development/doc-extraction-mandatory.md

**Protocol:**
1. Identify all third-party APIs the feature will integrate with
2. WebFetch official API documentation
3. Extract and quote relevant endpoints, request/response formats
4. Create `specs/<feature>/api-reference.md` with project-specific docs
5. Reference this doc in the main spec

**Why create project-specific docs?**
- Official docs are often sprawling; extract only what's needed
- Provides quick reference during implementation
- Documents assumptions and decisions about API usage
- Creates reusable knowledge for future features

**API reference should include:**
```markdown
## [Service Name] API Reference

**Base URL:** [from docs]
**Auth:** [from docs]

### Endpoint: [Name]
- **Method:** [QUOTE from docs]
- **Path:** [QUOTE from docs]
- **Request:** [QUOTE from docs]
- **Response:** [QUOTE from docs]
- **Our usage:** [How we'll use this endpoint]
```

---

## Workflow

### 1. Context Gathering

Parse the feature description and clarify with user:
- Output location (suggest `specs/<feature-name>/` or project convention)
- Scope boundaries if description is ambiguous
- Any existing specs to update vs. new spec needed

### 2. Brownfield Discovery

Before writing, conduct thorough codebase research:

**Discovery checklist:**
- [ ] Searched for existing patterns solving similar problems
- [ ] Identified models/services that could be extended (not duplicated)
- [ ] Found similar implementations to learn conventions from
- [ ] Checked for existing tests covering related functionality
- [ ] Documented all findings

### 2b. Third-Party API Research (if applicable)

If the feature integrates with external systems:

- [ ] Identified all third-party APIs involved
- [ ] Fetched and read official documentation
- [ ] Extracted relevant endpoints and contracts
- [ ] Created `specs/<feature>/api-reference.md`

### 3. Specification Writing

Write the spec organically - structure varies by feature type. Ensure these are addressed:

**Completeness checklist:**
```
□ Brownfield discovery documented
□ Third-party API reference created (if applicable)
□ Interfaces defined (API contracts, method signatures, data shapes)
□ Responsibilities clear (what each component does)
□ Dependencies identified (existing code to use/extend)
□ Data flow described (how information moves between components)
□ Test scenarios listed (behaviors to verify)
□ Out of scope defined (explicit exclusions)
```

### 4. Generate verify-specs.sh (Backend Work)

**If the spec involves backend work (Ruby/Rails, services, controllers, models):**

Generate a `verify-specs.sh` script that provides a focused test loop during implementation. This is critical because full test suites often take 10+ minutes.

**See example:** `specs/usage-dashboard/verify-specs.sh`

**Script structure:**
```bash
#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================"
echo "Feature: [FEATURE_NAME] Verification"
echo "========================================"

# Track results
TESTS_PASSED=true
RUBY_LINT_PASSED=true

# Pattern-based spec discovery - CUSTOMIZE THESE PATTERNS
SPECS=$(find spec -type f -name '*_spec.rb' \( -path '*PATTERN1*' -o -path '*PATTERN2*' \) 2>/dev/null | sort)

if [ -n "$SPECS" ]; then
  echo "Running RSpec tests..."
  docker compose exec -T web bundle exec rspec $SPECS --format documentation || TESTS_PASSED=false
else
  echo -e "${YELLOW}No specs found yet (pre-implementation)${NC}"
fi

# Ruby linting - CUSTOMIZE THESE PATTERNS
RUBY_FILES=$(find app lib -type f -name '*.rb' \( -path '*PATTERN*' \) 2>/dev/null | head -20)
if [ -n "$RUBY_FILES" ]; then
  echo "Running Rubocop..."
  rubocop $RUBY_FILES --force-exclusion || RUBY_LINT_PASSED=false
fi

# Summary
echo "========================================"
echo "Verification Summary"
echo "========================================"
$TESTS_PASSED && echo -e "${GREEN}✓ Tests: PASSED${NC}" || echo -e "${RED}✗ Tests: FAILED${NC}"
$RUBY_LINT_PASSED && echo -e "${GREEN}✓ Ruby Lint: PASSED${NC}" || echo -e "${RED}✗ Ruby Lint: FAILED${NC}"
```

**Customize patterns for:**
- Spec files that will test the feature
- Ruby files that will be created/modified
- JavaScript files if applicable (add ESLint section)

### 5. Review with User

Present the spec and ask:
- Does this capture the intended scope?
- Any missing requirements?
- Any concerns about the proposed approach?

---

## Spec Quality Checklist

Before finalizing, verify:

```
□ Focused on WHAT not HOW?
□ No implementation code (only type shapes/signatures)?
□ Brownfield discovery completed and documented?
□ Existing patterns/models identified for extension?
□ Third-party APIs researched and documented (if applicable)?
□ verify-specs.sh created (if backend work)?
□ Avoided pre-planning services/helpers?
□ Clear contracts between components?
□ Test scenarios describe behaviors, not implementations?
```

---

## Output

Create the spec file(s) in the agreed location. Common structures:
- Single file: `specs/<feature>/spec.md`
- With supporting docs: `specs/<feature>/requirements.md`, `specs/<feature>/api-contracts.md`
- With third-party integration: `specs/<feature>/api-reference.md` (external API docs)
- With backend work: `specs/<feature>/verify-specs.sh` (make executable with `chmod +x`)

Remind user to review before implementation begins.
