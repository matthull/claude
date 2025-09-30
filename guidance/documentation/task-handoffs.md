---
type: guidance
status: current
category: documentation
---

# Task Handoffs

## Purpose
Bridge between planning and execution. Extract implementation details for current work.
Enforce phase completion gates and testing discipline.

## When to Create
- Pausing work mid-task
- Handing off to another developer
- Complex multi-step implementation
- Extracting phase from larger spec
- Groups of related tasks
- Phase completion checkpoint
- Before stakeholder review

## Handoff Template

```markdown
# [Phase/Feature] Handoff
**Branch**: {branch} | **Date**: {date} | **Tasks**: T###-T###
**Goal**: {specific deliverable}
**Implementation Context**: [MVP|Production] | **Timeline**: [e.g., "2 weeks"]

## Quick Context
```bash
# Load ONLY relevant sections
grep -A 30 "Phase X.Y" specs/feature/tasks.md
grep "T041\|T042\|T043" specs/feature/tasks.md

# Key files
cat app/services/target.rb | sed -n '45,120p'

# Verification script (MANDATORY)
./specs/[###-feature]/verify-specs.sh
```

## Current State
- Done: {completed items}
- Next: {immediate steps}
- Blocked: {any blockers}
- Deferred: {items pushed to next phase with reasons}

## Task Details

### T###: [Task Name] [P]
**Location**: `exact/file/path.rb`
**Scope**: [MVP: minimal | Production: full error handling]
**Method Signature**:
```ruby
def method_name(params)
  # Use existing pattern
  # Return expected type
end
```
**Test Scenarios**:
- Success case with expected result
- Error handling for X condition
- Edge case Y behavior

**Reference**: research.md:26-34 (pattern explanation)

## Dependencies
- T001-T002 before T003
- [P] tasks can run in parallel

## Task Completion Gate (MANDATORY)

### Loop 1: TDD Inner Loop
```bash
# Per change - < 5 seconds
docker exec app bundle exec rspec spec/specific/file_spec.rb
```

### Loop 2: Project-Wide Verification
```bash
# MANDATORY before marking ANY task complete - < 30 seconds
# Run the feature-specific verification script created in Phase 1
./specs/[###-feature]/verify-specs.sh

# OR if script not present, use inline find:
docker exec app bash -c "bundle exec rspec $(find spec -path '*feature*' -name '*_spec.rb' | paste -sd' ')"
```

**Verification Script**: Created in Phase 1, dynamically finds ALL specs for this feature
**Location**: `specs/[###-feature]/verify-specs.sh`
**Must Run**: Before every commit during implementation

### Failure Protocol
- FAILING SPECS = INCOMPLETE TASK
- FIX IMMEDIATELY
- NO EXCEPTIONS
- NO PROCEEDING
- If script missing: ERROR "Phase 1 incomplete - create verify-specs.sh"

## Success Criteria
- [ ] Loop 1: Unit tests passing
- [ ] Loop 2: All project tests passing
- [ ] No breaking changes in dependent services
- [ ] Implementation matches polish level
```

## Phase Boundaries

Mark clear transition points:
```markdown
## Phase 1 Complete
- [ ] All Phase 1 tasks done
- [ ] Loop 2 verification passing
- [ ] Stakeholder review complete
- [ ] Ready for Phase 2

Next: [Description of Phase 2]
```

## Spec-Driven Extraction

### Selective Loading Commands
```bash
# Task-specific
grep -E "T041|T044|T049" specs/feature/tasks.md

# Section with context
grep -B 2 -A 10 "Token Refresh" specs/feature/research.md

# Multiple patterns
grep -E "Frontend|Storybook" specs/feature/plan.md

# File excerpts
sed -n '45,120p' app/services/file.rb
```

### Target Size
- 200-300 lines from 1000+ line specs
- Current phase only
- Skip future phases

## Content Rules

### INCLUDE
- Method signatures, not implementations
- Test scenarios, not full test code
- API contracts, not internal logic
- Line references: `file.rb:45-120`
- Grep patterns with context: `-A 10`

### EXCLUDE
- Full file contents
- Complete implementations
- Internal logic details
- Entire spec files
- Unfiltered listings

## Task Grouping

### By Phase
- Setup/Prerequisites
- Core Implementation
- Frontend Components
- Integration & Polish

### By Component
- All backend for Feature X
- All frontend for Feature Y

### By Parallel Work
- Mark with [P]
- Group together
- Note shared resources

## Deferred Items Tracking

```markdown
## Deferred to Next Phase
| Task | Reason | Target |
|------|--------|--------|
| T045: Bulk operations | Not MVP critical | Phase 2 (Week 3) |
| T048: Advanced filtering | Basic search sufficient | Phase 2 |
```

Document WHY each item was deferred
Track WHEN it should be revisited
Update plan.md deferred section

## Good Example

```markdown
### T004: Create Folder [P]
**Location**: `app/services/seismic/client.rb`
**Scope**: MVP: minimal error handling
**Method Signature**:
```ruby
def create_folder(teamsite_id, parent_folder_id, name)
  # Use make_request pattern
  # Return folder_id
end
```
**Test Scenarios**:
- Creates folder, returns ID
- Handles 409 conflict (exists)
- Handles 404 (invalid teamsite)
**Reference**: research.md:26-34

**Before Commit**:
```bash
./specs/001-seismic/verify-specs.sh
```
```

## Bad Example (Too Much Detail)

```markdown
### T004: Create Folder ❌
**Full Implementation**:
```ruby
def create_folder(teamsite_id, parent_folder_id, name)
  url = "#{base_url}/integration/v2/..."
  body = { name: name, parentFolderId: parent_folder_id }
  response = make_request(:post, url, body)
  # ... complete implementation ...
end
```
```

## Living Documentation Updates

Track discoveries during implementation:
```markdown
## API Discoveries
- Endpoint returns 400 not 409 for duplicates
- Token refresh requires /auth not /oauth/token
- Rate limit: 100 req/min (not documented)

Update in: specs/feature/lessons.md
```

## Quality Checklist
- [ ] Under 300 lines total
- [ ] Grep commands provided
- [ ] Line ranges specified
- [ ] [P] tasks marked
- [ ] verify-specs.sh script referenced
- [ ] Loop 2 verification enforced
- [ ] Deferred items documented with reasons
- [ ] No full implementations

## Anti-patterns
- Loading entire specs with cat
- Copying full implementations
- Missing line references
- No verify-specs.sh script
- No Loop 2 verification commands
- Mixing unrelated tasks
- Marking task complete with failing specs
- Not documenting deferred items
- Skipping context (MVP vs Production)
- Not tracking API discoveries
- Committing without running verify-specs.sh