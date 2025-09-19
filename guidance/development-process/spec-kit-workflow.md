---
type: guidance
status: current
category: development-process
---

# Spec-Kit Workflow Patterns

## Spec Directory Structure
```
specs/{###-feature}/
├── spec.md              # Feature specification
├── plan.md              # Implementation plan (from /plan)
├── research.md          # Technical decisions
├── data-model.md        # Entity definitions
├── contracts/           # API specifications
├── quickstart.md        # Test scenarios
└── tasks.md            # Task decomposition (from /tasks)
```

## Selective Context Loading

### Load Tasks Without Full Specs
```bash
# Current phase only
grep -A 30 "Phase 3.5" specs/001-feature/tasks.md

# Specific tasks
grep -E "T041|T042|T043" specs/001-feature/tasks.md

# Task with context
grep -B 5 -A 20 "T041.*token refresh" specs/001-feature/tasks.md
```

### Extract Implementation Details
```bash
# Critical notes only
grep -A 40 "Critical Implementation Notes" specs/001-feature/tasks.md

# Technical decisions
grep -A 15 "Token Strategy" specs/001-feature/research.md

# Test scenarios
grep -A 10 "Scenario [5-6]" specs/001-feature/quickstart.md
```

## Implementation Flow

1. **Check Prerequisites**
```bash
.specify/scripts/bash/check-task-prerequisites.sh --json
```

2. **Load Minimal Context**
```bash
grep "Phase X.Y" specs/feature/tasks.md
```

3. **Create/Load Handoff**
```bash
cat task-handoffs/feature/phase-X.Y-handoff.md
```

4. **Progressive Loading**
```bash
cat app/services/target.rb | head -100
grep "similar_pattern" app/services/*.rb
```

## Spec-Kit Commands
- `/specify` - Create feature specification
- `/plan` - Generate implementation plan
- `/tasks` - Create task decomposition

## Common Loading Patterns

### Frontend Phases
```bash
grep "Phase.*Frontend" specs/feature/tasks.md
grep "Storybook\|Component\|Vue" specs/feature/*.md
```

### Backend Phases
```bash
grep "Phase.*Backend\|Services" specs/feature/tasks.md
grep "Controller\|Model\|Service" specs/feature/*.md
```

### Testing Phases
```bash
grep "Phase.*Test\|Validation" specs/feature/tasks.md
cat specs/feature/quickstart.md
```

## Context Budget
- **Initial**: ~200 lines (handoff + phase tasks)
- **Progressive**: +100-150 lines per file
- **Maximum**: ~800 lines total