---
type: guidance
status: current
category: documentation
---

# Task Handoff Creation Guide

## Overview
Task handoffs are comprehensive but concise documents that provide everything needed to implement a group of related tasks. They serve as the bridge between planning and execution, ensuring smooth knowledge transfer and reducing context-switching overhead.

## Core Principles

### Purpose of Handoffs
- **Reduce Context Loading**: Provide all necessary information upfront
- **Enable Parallel Work**: Allow multiple developers to work independently
- **Capture Decisions**: Document technical choices and rationale
- **Define Success**: Clear verification criteria and dependencies
- **Reference, Don't Duplicate**: Use grep/line references for existing code

### When to Create Handoffs
- Groups of related tasks (e.g., by phase or component)
- Before parallel implementation by multiple developers
- Complex tasks requiring specific domain knowledge
- Integration points between systems or teams
- Critical implementation details not obvious from task descriptions

## Handoff Document Template

```markdown
# [Phase/Component] [Purpose] Handoff

**Date**: YYYY-MM-DD
**Tasks**: T[XXX]-T[YYY] (Brief description of task group)
**Status**: Ready for implementation | In Progress | Blocked
**Prerequisites**: List what must be complete before starting

## Overview
[2-3 sentences describing what this group of tasks accomplishes and how they fit into the larger system]

## Task Details

### T[XXX]: [Task Name] [P]
**Location**: `path/to/file.ext`
**Purpose**: [What this accomplishes]
**Implementation**:
```[language]
# Key code structure or interface
```
**TDD Approach** (if applicable):
- Test first: [What to test]
- Implementation: [Core logic needed]
- Refactor: [Optimization opportunities]

**References**:
- [Related doc] lines XX-YY
- `grep -n "pattern" path/` for existing examples

### T[XXX+1]: [Next Task] [P]
[Continue pattern...]

## Dependencies
- [Task/Component A] must complete before [Task/Component B]
- [External service] must be configured
- Parallel tasks marked with [P] can run simultaneously

## Common Patterns
```[language]
# Reusable code patterns for this task group
# Authentication helpers
# Error handling approaches
# Naming conventions
```

## Verification
```bash
# Commands to verify implementation
docker exec container-name test-command
grep -r "expected_pattern" target/directory/
curl -X GET http://localhost:3000/api/endpoint
```

## Success Criteria
- [ ] All tests passing
- [ ] Linting clean
- [ ] Performance targets met ([specify])
- [ ] API contracts satisfied
- [ ] Integration points verified

## Risk Areas
- **[Risk 1]**: [Description and mitigation]
- **[Risk 2]**: [Description and mitigation]

## Next Steps
[What happens after these tasks complete]
```

## Task Grouping Strategies

### By Phase
Group tasks that represent a complete implementation phase:
- Setup/Prerequisites (migrations, configurations)
- Core Implementation (models, services, controllers)
- Frontend Components (UI, state management)
- Integration (wiring, background jobs)
- Testing & Polish (integration tests, performance)

### By Component
Group tasks for a single component across layers:
- All backend tasks for Feature X
- All frontend tasks for Feature Y
- All API endpoints for Service Z

### By Dependency Chain
Group tasks that must be done sequentially:
- Database → Models → Services → Controllers
- API Design → Implementation → Client → UI

### By Developer/Team
Group tasks by who will implement:
- Backend team tasks
- Frontend team tasks
- DevOps tasks

## Content Guidelines

### Task Details Should Include
1. **Exact file paths** - No ambiguity about where code goes
2. **Key interfaces** - Method signatures, API contracts
3. **TDD approach** - Test examples before implementation
4. **Code snippets** - Enough to understand approach, not full implementation
5. **References** - Line numbers in related files, grep commands

### Use References Efficiently
Instead of copying large code blocks:
```markdown
**Reference**: research.md lines 15-23 (multipart upload pattern)
**Find examples**: `grep -n "upload_file" app/services/`
**Similar pattern**: backend-handoff.md lines 110-125
```

### Parallel Task Marking
- Mark with `[P]` for tasks that can run in parallel
- Explicitly state "can run in parallel" in overview
- Group parallel tasks together in the document
- Note any shared resources or potential conflicts

## Verification Patterns

### Code Verification
```bash
# Check migrations
docker exec app rails db:migrate:status | grep task_name

# Verify methods exist
grep -r "method_name" app/

# Test specific functionality
docker exec app rails console
> Model.new.respond_to?(:expected_method)
```

### API Verification
```bash
# Check routes
docker exec app rails routes | grep endpoint

# Test endpoint
curl -X GET http://localhost:3000/api/path \
  -H "Content-Type: application/json"
```

### Test Verification
```bash
# Run specific tests
docker exec app rspec spec/path/to/test_spec.rb

# Check coverage
docker exec app rspec --format documentation
```

## Anti-patterns to Avoid

### Don't
- Copy entire files (use references)
- Include implementation details that might change
- Create handoffs for trivial tasks
- Mix unrelated tasks in one handoff
- Forget to mark parallel tasks
- Omit verification steps
- Skip risk identification

### Do
- Keep handoffs focused and cohesive
- Provide just enough context
- Use concrete examples
- Include command-line verification
- Reference existing patterns
- Update if requirements change
- Consider the implementer's perspective

## Quality Checklist

Before finalizing a handoff, ensure:
- [ ] All task numbers match source task list
- [ ] Prerequisites clearly stated
- [ ] File paths are absolute, not relative
- [ ] Parallel tasks marked with [P]
- [ ] Dependencies explicitly listed
- [ ] Verification commands provided
- [ ] Success criteria measurable
- [ ] References use line numbers where helpful
- [ ] Risk areas identified with mitigations
- [ ] Overview provides clear context

## Examples of Good Handoffs

### Concise Task Detail
```markdown
### T015: Seismic::FolderManager [P]
**Location**: `app/services/seismic/folder_manager.rb`
**Purpose**: Create folder hierarchy on-demand
**TDD Specs First**:
- Creates folder hierarchy on demand
- Returns existing folder if present
- Handles permission errors gracefully
**Implementation**: Use client.create_folder from T004
**Reference**: research.md lines 26-34 (folder strategy)
```

### Clear Dependencies
```markdown
## Dependencies
- Migrations (T001-T002) before models (T013-T014)
- Models before services (T015-T017)
- Services before controllers (T018-T020)
- All [P] tasks in Phase 3.3 can run simultaneously
```

### Actionable Verification
```markdown
## Verification
After T025 completion:
```bash
docker exec app rails console
> helper.seismic_url(Asset.first)
=> "https://tenant.seismic.com/content/123"
```

## Continuous Improvement

### Gather Feedback
After implementation, ask:
- Was any critical information missing?
- Were there ambiguities that caused delays?
- Which sections were most helpful?
- What patterns should we standardize?

### Iterate the Template
- Add sections that prove repeatedly useful
- Remove sections that are consistently skipped
- Adjust detail level based on team needs
- Create specialized templates for common patterns

## Summary

Effective task handoffs balance completeness with conciseness. They provide enough context to start immediately, references to dig deeper when needed, and clear success criteria to know when done. The goal is to minimize back-and-forth questions and enable confident, independent implementation.