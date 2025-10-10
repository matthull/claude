# Handoff Template Improvements

**Date**: 2025-10-10
**Context**: First test of handoff system revealed excess verbiage and planning guidance mixed with implementer guidance

## Issues Identified in T011b Handoff

### 1. Planning Guidance Mixed with Implementer Guidance

**Problem**: Sections meant for handoff PLANNERS appearing in final document
- "CRITICAL: Code Guidance Format" section (lines 30-40)
- Source guidance frontmatter (lines 10-19)
- Notes about canonical examples (line 93)

**Solution**: Move planning guidance to template comments or separate planning doc
- Use HTML comments `<!-- PLANNER NOTE: ... -->` in templates
- Strip these during generation
- Keep frontmatter minimal (just task_id, date, status)

### 2. Irrelevant Sections Included

**Problem**: Migrations section included when task doesn't involve migrations (lines 153-171)
- Takes 19 lines for content not applicable to task

**Solution**: Conditional inclusion based on task type
- Only include migrations section if task involves database changes
- Add task type detection in handoff generation
- Use flags: `needs_migration: false`, `needs_new_class: false`

### 3. Canonical Examples Overuse

**Problem**: Canonical examples included for modifying existing class (lines 344-368)
- Not needed when updating existing service
- Takes 25 lines

**Solution**: Include canonical examples ONLY when:
- Creating NEW class/module
- Heavy rewrite (>50% of file)
- Task explicitly requests pattern reference

### 4. Wrong Test Commands

**Problem**: Full test suite in Loop 2 (line 285, 733)
- `docker exec musashi-web-1 bundle exec rspec` = 30+ minutes
- Never run locally

**Solution**: Always use scoped test commands
- Loop 2: `./specs/{spec-name}/verify-specs.sh`
- Or: `docker exec musashi-web-1 bundle exec rspec spec/services/` (scoped)
- Never full suite

### 5. Excess Verbiage Throughout

**Problem**: Not following ultra-concise principles
- Long explanations in multiple sections
- Redundant information
- Verbose instructions

**Examples**:
- Lines 119-126: Problem statement could be 2 lines
- Lines 455-481: Error handling patterns too verbose
- Lines 547-625: Test scenarios overly detailed

**Solution**: Apply ultra-concise enforcement
- Delete explanatory sentences
- Use bullet lists not paragraphs
- Commands over descriptions

### 6. Inconsistent Core Mandate Keywords

**Problem**: Not consistently using MUST/NEVER/ALWAYS keywords from core-mandates.md
- Sometimes uses "should" or "need to" instead of MUST
- Stop and Ask protocol present but could be more prominent

**Solution**: Enforce core mandate patterns
- **MUST NEVER** for prohibitions
- **MUST ALWAYS** for requirements
- **MUST IMMEDIATELY STOP** for blockers
- **Stop and Ask** protocol prominent in every handoff
- Use RATIONALE sparingly (only for critical items)

## Proposed Template Structure (Ultra-Concise)

```markdown
# Task: {ID}

**Goal**: {One line}
**Status**: Ready

## CRITICAL: Stop and Ask Protocol (ABSOLUTE)

**You MUST IMMEDIATELY STOP if codebase differs from handoff.**

**RATIONALE:** Wrong assumptions = wrong implementation.

```
STOP immediately.
Report: Expected X, found Y
Impact: Cannot proceed
Need: Should I... OR...?
AWAIT user decision.
```

## Context

```bash
# Relevant files only
grep -r "SpecificClass" app/
cat app/services/specific_file.rb
```

## Task

**Fix**: {Problem in one line}
**File**: `app/services/specific.rb`

**Requirements**:
- First sync: Create, persist ID
- Re-sync: Update using ID
- 404: Clear ID, recreate

## Implementation

### Service Method
```ruby
def call
  # Check seismic_id
  # Present: update_existing
  # Nil: create_new
end
```

### Tests
```ruby
context 'no seismic_id' # creates
context 'has seismic_id' # updates
context '404' # recreates
```

## Verification

**Loop 1**: `rspec spec/services/seismic/sync_service_spec.rb`
**Loop 2**: `./specs/001-seismic/verify-specs.sh`
**Loop 3**: Required (API integration)

**You MUST NEVER proceed with failing tests.**

## Success Criteria
- [ ] Creates on first sync
- [ ] Updates on re-sync
- [ ] Handles 404
- [ ] All tests pass
```

## Template Improvements Needed

### Core Template Changes

1. **Remove from core template**:
   - "Code Guidance Format" section (move to HTML comment for planners)
   - Extensive notes about guidance
   - Generic canonical examples section
   - Source guidance frontmatter lists

2. **Make conditional**:
   - Canonical examples (only if `needs_canonical: true`)
   - Migration warnings (only if `needs_migration: true`)
   - Full verification commands (use task-specific)

3. **Ultra-concise**:
   - Quick Context → Context
   - Current State → Status (only if complex multi-step)
   - Reduce all explanatory text by 50%+

4. **Enforce core mandates**:
   - MUST/NEVER/ALWAYS keywords throughout
   - Stop and Ask protocol always prominent
   - RATIONALE only for critical items

### Section Template Changes

#### ruby-rails-code.md
1. **Make conditional**:
   - Migrations section (only if `needs_migration: true`)
   - Canonical examples (only if `needs_canonical: true`)
   - Full fixture builder section (only if creating fixtures)

2. **Fix test commands**:
   - Never include full test suite
   - Use verify-specs.sh pattern
   - Scope to service/controller directories

3. **Apply core mandates**:
   - Change "should" → "MUST"
   - Change "avoid" → "MUST NEVER"

#### api-integration.md
1. **Condense**:
   - API contract to essential fields only
   - Error handling to one-liners
   - Remove verbose explanations

2. **Core mandates**:
   - Security requirements use MUST ALWAYS
   - Anti-patterns use MUST NEVER

#### testing.md
1. **Ultra-concise scenarios**:
   - One line per scenario
   - Code blocks only for complex cases
   - Remove debugging steps (implementer knows)

2. **Enforce failure protocol**:
   - "You MUST NEVER proceed with failing tests"
   - No hedging language

## Implementation Plan

### Phase 1: Core Template
- [ ] Remove planning guidance sections
- [ ] Move planner notes to HTML comments
- [ ] Add conditional flags system
- [ ] Enforce MUST/NEVER/ALWAYS keywords
- [ ] Apply ultra-concise to all text

### Phase 2: Section Templates
- [ ] Add conditional inclusion logic
- [ ] Fix test command patterns
- [ ] Remove verbose explanations
- [ ] Enforce core mandate keywords
- [ ] Reduce all sections by 50%+

### Phase 3: Generation Logic
- [ ] Detect task type from description
- [ ] Set flags: needs_migration, needs_canonical, etc.
- [ ] Strip planner comments during generation
- [ ] Validate core mandate keyword usage

## Success Metrics

**Before**: 811 lines (T011b handoff)
**Target**: < 300 lines for same task
**Reduction**: 60%+ less context

## Key Principles

1. **Implementer-focused**: Only what agent needs to code
2. **Conditional content**: Include only what applies
3. **Ultra-concise**: Every word must earn its place
4. **Commands not prose**: Show, don't explain
5. **No planning artifacts**: Strip meta-guidance
6. **Core mandates enforced**: MUST/NEVER/ALWAYS consistently
7. **Stop and Ask prominent**: Never buried in text

## Example Transformations

### Before (Verbose)
```markdown
When implementing this feature, you should consider checking
whether the seismic_id already exists on the asset. If it does
exist, then you'll want to use the update endpoint instead of
creating a new asset. This helps prevent duplicates.
```

### After (Ultra-Concise + Core Mandates)
```markdown
**You MUST check seismic_id.**
- Present: Update existing
- Nil: Create new
```

### Before (Soft Language)
```markdown
It's recommended to write tests before implementation following
TDD practices. Try to avoid proceeding if tests are failing.
```

### After (Core Mandates)
```markdown
**You MUST write tests first (TDD).**
**You MUST NEVER proceed with failing tests.**
```

## Validation Checklist for Templates

Before releasing updated templates:

- [ ] All planning guidance in HTML comments or removed
- [ ] MUST/NEVER/ALWAYS used consistently (no "should")
- [ ] Stop and Ask protocol prominent in core template
- [ ] Conditional sections properly flagged
- [ ] Test commands never include full suite
- [ ] All sections reduced by 50%+ in length
- [ ] Commands shown, not described
- [ ] No benefits/explanations sections