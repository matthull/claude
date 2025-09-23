---
type: guidance
status: current
category: documentation
---

# Task Handoffs

## Purpose
Bridge between planning and execution. Extract implementation details for current work.

## When to Create
- Pausing work mid-task
- Handing off to another developer
- Complex multi-step implementation
- Extracting phase from larger spec
- Groups of related tasks

## Handoff Template

```markdown
# [Phase/Feature] Handoff
**Branch**: {branch} | **Date**: {date} | **Tasks**: T###-T###
**Goal**: {specific deliverable}

## Quick Context
```bash
# Load ONLY relevant sections
grep -A 30 "Phase X.Y" specs/feature/tasks.md
grep "T041\|T042\|T043" specs/feature/tasks.md

# Key files
cat app/services/target.rb | sed -n '45,120p'
```

## Current State
- Done: {completed items}
- Next: {immediate steps}
- Blocked: {any blockers}

## Task Details

### T###: [Task Name] [P]
**Location**: `exact/file/path.rb`
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

## Verification
```bash
docker exec app rspec spec/path/file_spec.rb
grep -n "expected_pattern" app/
```

## Success Criteria
- [ ] Tests passing
- [ ] Specific outcome verified
- [ ] Performance target met
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

## Good Example

```markdown
### T004: Create Folder [P]
**Location**: `app/services/seismic/client.rb`
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

## Quality Checklist
- [ ] Under 300 lines total
- [ ] Grep commands provided
- [ ] Line ranges specified
- [ ] [P] tasks marked
- [ ] Verification commands included
- [ ] No full implementations

## Anti-patterns
- Loading entire specs with cat
- Copying full implementations
- Missing line references
- No verification steps
- Mixing unrelated tasks