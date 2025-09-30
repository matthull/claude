# /complete-plan

## Purpose
Complete an implementation phase: archive planning docs, update spec status, generate completion summary.

## Usage
```
/complete-plan
```

## Prerequisites
- Must be run from feature directory (contains spec.md)
- Phase implementation must be substantially complete
- All tests should be passing (verify-specs.sh)

## Interactive Process

### 1. Phase Identification
- Parse spec.md to list existing phases
- Ask: "Which phase is complete?"
- Validate phase exists in spec

### 2. Completion Assessment
- Ask: "Completion percentage (0-100)?"
- Ask: "List completed components (one per line, end with empty line)"
- Ask: "Reference tasks.md? (List task numbers completed)"
- Ask: "Any remaining work? (describe or 'none')"

### 3. Deferred Items Check
- Check if deferred.md exists
- Ask: "Items deferred from this phase? (see plan.md deferred section)"
- Document in archive

### 4. Lessons Learned
- Ask: "Key discoveries to add to lessons.md? (y/n)"
- If yes: Prompt for learnings
- Append to lessons.md with phase marker

### 5. Archive Creation

Execute archival operations:

```bash
# Create archive directory
DATE=$(date +%Y-%m-%d)
PHASE_NUM="N"  # Replace with actual phase number
ARCHIVE_DIR="archive/${DATE}-phase-${PHASE_NUM}-complete"
mkdir -p "$ARCHIVE_DIR"

# Move phase-specific docs
mv plan.md "$ARCHIVE_DIR/" 2>/dev/null || echo "plan.md not found"
mv research.md "$ARCHIVE_DIR/" 2>/dev/null || echo "research.md not found"
mv data-model.md "$ARCHIVE_DIR/" 2>/dev/null || echo "data-model.md not found"
mv quickstart.md "$ARCHIVE_DIR/" 2>/dev/null || echo "quickstart.md not found"
mv tasks.md "$ARCHIVE_DIR/" 2>/dev/null || echo "tasks.md not found"
mv contracts/ "$ARCHIVE_DIR/" 2>/dev/null || echo "contracts/ not found"

# Copy (don't move) verify-specs.sh
cp verify-specs.sh "$ARCHIVE_DIR/" 2>/dev/null || echo "verify-specs.sh not found"

# Archive ALL current task-handoffs
mkdir -p "$ARCHIVE_DIR/task-handoffs"
if [ -d "task-handoffs" ]; then
  find task-handoffs -maxdepth 1 -type f -name "*.md" -exec mv {} "$ARCHIVE_DIR/task-handoffs/" \; 2>/dev/null
  echo "Archived task handoffs"
fi
```

### 6. Generate Completion Summary

Create `phase-completion-summary.md` in archive:

```markdown
# Phase N Completion Summary: [Phase Name]

**Date**: [Current Date]
**Status**: [XX]% Complete ([Y] of [Z] tasks)

## What Was Completed

[List of completed components from user input]

## What Remains

[Description of remaining work from user input]

## Deferred Items

See archived plan.md deferred section or link to current deferred.md

## Key Learnings

[If provided during interactive session, or note "See lessons.md"]
```

### 7. Update spec.md

Update the Implementation Status Summary section for the completed phase:

**Status Line Changes**:
- Emoji: ✅ COMPLETE or 🚧 PARTIALLY COMPLETE (based on percentage)
- Percentage: Update to actual completion
- Date: Add completion date

**Format**:
```markdown
### Phase N: [Phase Name] ✅ COMPLETE (XX%)
**Implementation completed on YYYY-MM-DD with Y of Z tasks finished**

**Components Implemented**:
- Component 1 description
- Component 2 description
[... generated from user input]

**Remaining Work** (if < 100%):
- [Items from user input]
```

Also update the top-level **Status** line in spec.md header to reflect current overall state.

### 8. Lessons.md Update

If user provided new learnings:
- Append to lessons.md under new section header
- Format: `## Phase N Completion: [Phase Name]`
- Add date marker
- Include discoveries in bullet format

### 9. Generate Completion Report

Display summary to user:

```markdown
## Phase N Completion Report

**Archived To**: archive/YYYY-MM-DD-phase-N-complete/

**Files Archived**:
- plan.md
- research.md
- data-model.md
- quickstart.md
- tasks.md
- contracts/ (X files)
- verify-specs.sh (copied, not moved)
- task-handoffs/ (Y files)

**spec.md Updated**: Phase N marked XX% complete

**Next Steps**:
1. Review archive/YYYY-MM-DD-phase-N-complete/phase-completion-summary.md
2. Ready to begin next phase planning with /plan
```

## Archive Structure

Result after running:
```
specs/[###-feature]/
├── spec.md                      # Updated with completion status
├── lessons.md                   # Updated with phase learnings
├── implementation-guidelines.md # Unchanged
├── verify-specs.sh             # Still active
├── deferred.md                 # Unchanged if exists
├── task-handoffs/              # Cleared of completed handoffs
│   └── archives/
└── archive/
    └── YYYY-MM-DD-phase-N-complete/
        ├── phase-completion-summary.md
        ├── plan.md
        ├── research.md
        ├── data-model.md
        ├── quickstart.md
        ├── tasks.md
        ├── verify-specs.sh
        ├── contracts/
        └── task-handoffs/
```

## Edge Cases

- **Phase already complete**: WARN user, confirm to continue
- **Missing files**: Note in summary, continue archival
- **Empty task-handoffs**: Skip handoffs section
- **No lessons.md**: Create new one with header
- **No deferred.md**: Note as "No deferred items"

## Anti-patterns

- DON'T archive spec.md (living document)
- DON'T archive lessons.md (living document)
- DON'T archive implementation-guidelines.md (living document)
- DON'T delete files, only move to archive
- DON'T move verify-specs.sh (copy only, keep active)
- DON'T modify deferred.md directly

## Quality Checks

Before completing:
- [ ] Archive directory created with correct naming pattern
- [ ] All phase-specific docs moved (including plan.md)
- [ ] phase-completion-summary.md generated with user input
- [ ] spec.md status updated correctly
- [ ] verify-specs.sh still accessible (copied, not moved)
- [ ] No living documents accidentally archived
- [ ] Task handoffs moved to archive
- [ ] Completion report shown to user