---
type: guidance
status: current
category: git
---

# Commit Verification Workflow

## Overview
Systematic approach to creating high-quality, atomic commits with user verification at every step.

## Core Principles

### Verification Before Action
- **Always pause before commits** - Show changes for review
- **Never commit without approval** - Wait for explicit confirmation
- **Apply to all commits** - Not just squashes or merges

### Commit Quality Standards
- **Atomic changes** - Each commit does one thing
- **Descriptive messages** - Explain "why" not just "what"
- **Clean diffs** - No unrelated changes
- **Buildable state** - System works after each commit

## Standard Workflow

### Step 1: Review Changes
```bash
git status
git diff --cached
```

### Step 2: Show User the Diff
```bash
git diff --color=always --cached
git diff --cached --stat  # For large diffs
```

### Step 3: Request Verification
"Here are the changes to be committed. Please review:
- Are all changes intentional?
- Is anything missing?
- Should any changes be separated?

Shall I proceed with the commit?"

### Step 4: Craft Commit Message
Format: `<type>: <subject>`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code restructuring
- `docs`: Documentation
- `test`: Testing
- `chore`: Maintenance

### Step 5: Execute Commit
```bash
# Only after explicit approval
git commit -m "type: descriptive message

Explanation of why this change was made."
```

## Special Cases

### Large Changes
1. Show summary statistics first
2. Offer to review by directory
3. Consider splitting into multiple commits
4. Highlight risky changes

### Merge Commits
- Explain what's being merged
- Show both parents' changes
- Verify conflict resolutions
- Document merge strategy

### Hotfixes
1. Show minimal diff
2. Explain urgency
3. Get rapid verification
4. Document thoroughly

## Anti-patterns

### Never Do
- Commit without showing diff
- Bundle unrelated changes
- Use vague messages like "fixes" or "updates"
- Commit broken code
- Skip verification for "simple" changes

### Always Do
- Show colored diffs
- Wait for explicit approval
- Write clear "why" in messages
- Keep commits atomic
- Verify tests pass

## GitHub Integration

### Pull Requests
```bash
# Show PR changes before creation
gh pr diff

# Verify PR description
gh pr create --draft --title "Type: Description"
```

### Pre-push Verification
```bash
# Show what will be pushed
git log origin/main..HEAD --oneline
git diff origin/main..HEAD --stat
```

## Emergency Procedures

### Undoing Commits
```bash
# Before push - safe to rewrite
git reset --soft HEAD~1

# After push - create revert
git revert HEAD
```

### Fixing Messages
```bash
# Last commit only
git commit --amend

# Older commits - requires force push
# Get approval before force pushing
```