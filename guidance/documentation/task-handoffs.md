---
type: guidance
status: current
category: documentation
---

# Task Handoffs for Spec-Driven Development

## Creating Phase-Specific Handoffs

Extract ONLY implementation details for current phase from comprehensive specs. Target 200-300 lines from 1000+ line specs.

## Handoff Document Template

```markdown
# Phase X.Y Implementation Handoff
**Branch**: {branch} | **Date**: {date} | **Goal**: {specific objective}

## Quick Context Commands
```bash
# Load ONLY relevant sections using partial grep
grep -A 30 "Phase X.Y" specs/feature/tasks.md
grep -A 20 "Frontend Testing" specs/feature/quickstart.md
grep -B 5 -A 15 "Token Refresh" specs/feature/research.md
grep "T041\|T042\|T043" specs/feature/tasks.md

# Load implementation files
cat app/services/specific/service.rb | head -50
```

## Tasks [T###-T###]

### T001: {Task Description}
**File**: `app/services/exact/path.rb`
**Spec Context**: `grep -A 10 "T001" specs/feature/tasks.md`
**Implementation**:
```ruby
# Critical code pattern or snippet
```
**Requirements**:
- {specific requirement 1}
- {specific requirement 2}

## Required Files
- `app/services/file.rb:45-120` - Token refresh logic
- `spec/services/file_spec.rb:200-250` - Test patterns

## Validation Checklist
- [ ] {measurable outcome}
- [ ] {test coverage requirement}
- [ ] {performance metric}

## Known Issues
**{Issue}**: {one-line solution}
```

## Selective Loading Patterns

### Task-Specific Loading
```bash
# Load multiple specific tasks from tasks.md
grep -E "T041|T044|T049" specs/feature/tasks.md

# Load task with context lines
grep -B 2 -A 10 "T041.*token refresh" specs/feature/tasks.md

# Load phase summary only
grep "## Phase 3.5" specs/feature/tasks.md | head -20
```

### Section Extraction
```bash
# Extract specific sections from different specs
grep -A 15 "Token Security" specs/feature/research.md
grep -A 20 "Scenario 5.*OAuth" specs/feature/quickstart.md
grep -A 30 "As-Needed Token Refresh" specs/feature/tasks.md

# Combine multiple patterns
grep -E "Frontend|Storybook|Component" specs/feature/plan.md
```

### Implementation Notes Loading
```bash
# Load critical implementation notes only
grep -A 40 "Critical Implementation Notes" specs/feature/tasks.md
grep -B 5 -A 10 "IMPORTANT\|CRITICAL\|WARNING" specs/feature/*.md
```

## Content Selection Rules

### INCLUDE
- Partial grep commands for spec sections
- Line ranges for file excerpts (file.rb:100-150)
- Task-specific search patterns
- Cross-file grep combinations
- Context line specifications (-A, -B, -C)

### EXCLUDE
- Full file cats when partials suffice
- Entire spec file loading
- Unfiltered directory listings
- Broad wildcard searches
- Full document contexts

## Handoff Types

### Phase-Based
```
phase-3.5-3.7-handoff.md    # Multiple related phases
phase-frontend-handoff.md    # UI implementation
phase-backend-handoff.md     # API services
```

### Feature-Based
```
oauth-implementation-handoff.md
token-refresh-handoff.md
validation-testing-handoff.md
```

### Priority-Based
```
critical-path-handoff.md    # Blocking features
post-launch-handoff.md      # Deferrables
```

## Loading Strategy

```bash
# 1. Start with handoff only
cat task-handoffs/{feature}/phase-handoff.md

# 2. Load specific task details
grep -A 15 "T041" specs/feature/tasks.md

# 3. Load file sections being modified
sed -n '45,120p' app/services/target.rb

# 4. Search for patterns across specs
grep -n "delegation.*callback" specs/feature/*.md

# 5. Load test scenarios selectively
grep -A 10 "Scenario [3-5]" specs/feature/quickstart.md
```

## Directory Structure

```
task-handoffs/
├── {feature}/
│   ├── phase-{X.Y}-handoff.md
│   ├── critical-path-handoff.md
│   ├── testing-checklist.md
│   └── session-logs/
│       └── YYYY-MM-DD-{topic}.md
```

## Creating Effective Handoffs

1. **Map grep patterns** to each phase's needs
2. **Specify line ranges** for partial file loads
3. **Combine searches** for related concepts
4. **Use context flags** (-A/-B/-C) wisely
5. **Chain greps** to filter progressively

## Anti-Patterns

**NEVER**:
- Load entire spec files with cat
- Use recursive grep without limits
- Include full file contents
- Load all phases at once
- Omit line number hints

**ALWAYS**:
- Use partial grep with context lines
- Specify exact search patterns
- Include line ranges for files
- Provide multiple search examples
- Keep total context under 500 lines