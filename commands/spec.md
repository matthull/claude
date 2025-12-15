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

## Phase 0: Research Coordination (CRITICAL FIRST STEP)

**The main conversation's primary role at spec start is RESEARCH COORDINATOR.**

Before writing any specification, you must gather solid evidence for the approach. The type of research depends on context:

### Research Assessment Matrix

| Context | Primary Research Focus | Method |
|---------|----------------------|--------|
| **Adding to existing codebase** | Conventions, patterns, existing code | Explore agents, Grep, Read existing files |
| **External services (new to project)** | Official docs, community patterns, examples | `/request-research` → `/research` or external |
| **External services (established in project)** | Existing integration patterns + any updates | Both internal exploration AND external research |
| **Industry-standard patterns** | Best practices, security considerations | Heavy external research before specifying |
| **Novel/custom features** | Similar solutions in other projects | Moderate external research |

### When to Create Research Requests

**Use `/request-research` liberally.** Create research requests when ANY of these apply:

1. **First-time integration** with a service/library (Supabase, PowerSync, Stripe, etc.)
2. **Security-sensitive features** (auth, RLS, encryption, secrets management)
3. **Industry-standard patterns** where best practices exist (multi-tenancy, caching, etc.)
4. **Uncertainty about approach** - if you're not confident, research first
5. **Multiple valid approaches** - research helps choose between them
6. **Framework/library updates** - patterns may have changed since last use

### Research Request Targets

Research requests are portable documents. They can be executed via:
- **Local `/research` command** - Parallel subagent approach
- **Claude.ai web research** - Alternative research path
- **Other research tools** - Any capable agent

Create requests that work for ANY research executor (no internal file references).

### Research Coordination Workflow

1. **Assess research needs** using the matrix above
2. **Create research requests** via `/request-research` for each external topic
3. **Execute research** through appropriate channels (local and/or external)
4. **Analyze reference projects** if available (clone repos, read their patterns)
5. **Synthesize findings** into evidence base
6. **THEN proceed to spec writing** - only after research is complete

### Research Quality Checklist

Before proceeding to spec writing:
```
□ All external services/libraries researched via official docs?
□ Community patterns and best practices identified?
□ Reference repos/starter packs analyzed (if available)?
□ Security considerations researched (if applicable)?
□ Research findings documented (in research/findings/ or spec folder)?
□ Confidence level high enough to specify approach?
```

**If confidence is low, do more research. Specs built on assumptions fail during implementation.**

---

## Traceability (MANDATORY)

**Every requirement in the spec MUST be tagged with its evidence source.**

### Traceability Tags

| Tag | Meaning | When to Use |
|-----|---------|-------------|
| `[R:filename]` | **Research-backed** | Requirement comes from research docs |
| `[B:context]` | **Business requirement** | From roadmap, user stories, stakeholder input |
| `[D:reason]` | **Decision** | Implementation choice not from research (explain why) |
| `[E:existing]` | **Extends existing** | Builds on existing code/pattern in codebase |
| `[U:topic]` | **Unbacked** | No research found - flagged for validation |

### Why Traceability Matters

1. **Accountability** - Know WHY each requirement exists
2. **Validation** - Unbacked items get flagged for review
3. **Change management** - When research updates, know what specs to revisit
4. **Debugging** - When implementation differs from spec, trace back to source
5. **Knowledge transfer** - New team members understand rationale

### Traceability Examples

**Good - Tagged with source:**
```markdown
### Session Storage
- Use MMKV with encryption `[R:auth-flow-session.md]`
- Encryption key in SecureStore `[R:auth-flow-session.md]`
- Separate instance for auth vs preferences `[D:separation-of-concerns]`
```

**Bad - No traceability:**
```markdown
### Session Storage
- Use MMKV with encryption
- Encryption key in SecureStore
- Separate instance for auth vs preferences
```

### Extraction Step (Recommended for Complex Features)

For features with significant research, create an extraction doc BEFORE the spec:

1. Create `specs/<feature>/<phase>-extraction.md`
2. Map each requirement area to research coverage
3. Identify gaps (items with no research backing)
4. Resolve gaps via decisions or additional research
5. Flag remaining unbacked items with `[U:topic]`

**Extraction doc structure:**
```markdown
## 1. [Requirement Area]

### Research Coverage: COMPLETE | PARTIAL | NONE

**What's documented:**
- [List items from research with source]

**Gaps identified:**
- [ ] [Missing item] - needs research or decision

### Resolution
- [How gaps were resolved or flagged]
```

### Traceability Audit

Before finalizing spec, verify:
```
□ Every schema field tagged?
□ Every configuration value tagged?
□ Every behavior/contract tagged?
□ All [U:*] items explicitly acknowledged?
□ Research file references are accurate?
```

---

## Workflow

### 1. Context Gathering

Parse the feature description and clarify with user:
- Output location (suggest `specs/<feature-name>/` or project convention)
- Scope boundaries if description is ambiguous
- Any existing specs to update vs. new spec needed
- **Research needs assessment** (see Phase 0 matrix)

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
□ Extraction doc created (if complex feature with research)
□ Interfaces defined (API contracts, method signatures, data shapes)
□ Responsibilities clear (what each component does)
□ Dependencies identified (existing code to use/extend)
□ Data flow described (how information moves between components)
□ Test scenarios listed (behaviors to verify)
□ Out of scope defined (explicit exclusions)
□ Every requirement tagged with traceability [R/B/D/E/U]
```

### 4. Generate verify-specs.sh (Backend Work)

**If the spec involves backend work (Ruby/Rails, services, controllers, models):**

Generate a `verify-specs.sh` script that provides a focused test loop during implementation. This is critical because full test suites often take 10+ minutes.

**IMPORTANT:** The spec document MUST reference the verify script in its header metadata. Example:
```markdown
**Verify Script:** `specs/<feature>/verify-specs.sh`
```

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

### 6. Include Retrospective Section

**Every spec MUST include a "Retrospective" section** that defines what to review when the feature is complete.

**Why:** Implementation produces valuable learnings captured in task handoffs. Without explicit review, these insights are lost instead of improving documentation, plans, skills, and workflows.

**Template:**
```markdown
## Retrospective

When this feature is complete, review all task handoffs and extract:

### Documentation Updates
- [ ] Architecture decisions that should be documented
- [ ] Patterns discovered that others should know about
- [ ] Environment/tooling gotchas worth capturing

### Project Plan Updates
- [ ] Scope changes that affect the roadmap
- [ ] New dependencies or constraints discovered
- [ ] Estimates vs actuals for future planning

### Workflow Improvements
- [ ] Skills or commands that could be created/updated
- [ ] Template sections that were missing or unclear
- [ ] Process friction points to address

### Knowledge Capture
- [ ] Reusable code patterns to document
- [ ] External API quirks worth noting
- [ ] Testing strategies that worked well
```

**Adapt the checklist** based on feature type - not all items apply to every feature.

---

## Spec Quality Checklist

Before finalizing, verify:

```
RESEARCH GROUNDING
□ Research requests created for external services/libraries?
□ Official documentation consulted and cited?
□ Community patterns/best practices identified?
□ Reference projects analyzed (if available)?
□ Research findings documented and referenced in spec?

TRACEABILITY
□ Traceability legend included in spec header?
□ Every requirement tagged with [R/B/D/E/U]?
□ Extraction doc created (if complex feature)?
□ All gaps identified and resolved or flagged [U:*]?
□ Research file references accurate and verifiable?
□ No unbacked items without explicit acknowledgment?

SPEC CONTENT
□ Focused on WHAT not HOW?
□ No implementation code (only type shapes/signatures)?
□ Brownfield discovery completed and documented?
□ Existing patterns/models identified for extension?
□ Third-party APIs researched and documented (if applicable)?
□ verify-specs.sh created (if backend work)?
□ verify-specs.sh referenced in spec header (if created)?
□ Avoided pre-planning services/helpers?
□ Clear contracts between components?
□ Test scenarios describe behaviors, not implementations?
□ Retrospective section included with review checklist?
```

---

## Output

Create the spec file(s) in the agreed location. Common structures:
- Single file: `specs/<feature>/spec.md`
- With supporting docs: `specs/<feature>/requirements.md`, `specs/<feature>/api-contracts.md`
- With third-party integration: `specs/<feature>/api-reference.md` (external API docs)
- With research extraction: `specs/<feature>/<phase>-extraction.md` (research-to-requirement mapping)
- With backend work: `specs/<feature>/verify-specs.sh` (make executable with `chmod +x`)

**Spec header should include:**
```markdown
# [Feature] Specification

**Phase:** [if applicable]
**Status:** Draft
**Created:** [date]
**Extraction Doc:** `specs/<feature>/<phase>-extraction.md` (if created)

---

## Traceability Legend

| Tag | Meaning |
|-----|---------|
| `[R:filename]` | Research-backed |
| `[B:context]` | Business requirement |
| `[D:reason]` | Decision |
| `[E:existing]` | Extends existing |
| `[U:topic]` | Unbacked |

---
```

Remind user to review before implementation begins.
