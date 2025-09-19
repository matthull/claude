---
type: guidance
status: current
category: setup
---

# Git Symlink Workarounds

## CLAUDE.md Symlink Configuration

### Current Setup
- Symlink: `CLAUDE.md -> ~/.claude/CLAUDE.musashi.md`
- Git flag: `skip-worktree` (not `assume-unchanged`)
- Purpose: Use personal CLAUDE.md without committing changes

### Common Issues

#### Branch Switching Error
```
error: Your local changes to the following files would be overwritten by checkout: CLAUDE.md
```

**Fix:**
```bash
# Remove symlink, switch branch, restore symlink
rm CLAUDE.md && \
git checkout <branch> && \
ln -s ~/.claude/CLAUDE.musashi.md CLAUDE.md && \
git update-index --skip-worktree CLAUDE.md
```

#### Check Skip-worktree Status
```bash
git ls-files -v | grep CLAUDE.md
# "S CLAUDE.md" = skip-worktree is set
# "H CLAUDE.md" = normal tracking
```

#### Re-apply Skip-worktree
```bash
git update-index --no-skip-worktree CLAUDE.md
git update-index --skip-worktree CLAUDE.md
```

### Initial Setup (For New Clones)
```bash
# Replace project CLAUDE.md with symlink
rm CLAUDE.md
ln -s ~/.claude/CLAUDE.musashi.md CLAUDE.md
git update-index --skip-worktree CLAUDE.md
```

### Removing Setup
```bash
# Restore original file
git update-index --no-skip-worktree CLAUDE.md
rm CLAUDE.md
git checkout CLAUDE.md
```

## Skip-worktree vs Assume-unchanged

### skip-worktree (Recommended)
- Tells Git to completely ignore file in working tree
- Survives most git operations
- Designed for this use case
- May need re-application after some operations

### assume-unchanged (Not Recommended)
- Performance optimization flag
- Git may still check file
- Can be lost during merges
- Not designed for permanent local changes