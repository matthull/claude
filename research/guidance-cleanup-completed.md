# Guidance Cleanup Completed

Date: 2025-10-08

## Summary

Cleaned up guidance library based on Gemini's review to remove redundancies with `prompts/core-mandates.md` and strengthen language patterns.

## Changes Made

### 1. DELETED (Fully Redundant)

**File**: `development-process/no-interface-guessing.md`
- **Reason**: 95%+ redundant with core-mandates.md Section III (Verification Principle)
- **What was covered**:
  - "STOP. SEARCH. VERIFY. OR ASK." → Now in Section III
  - Never guess interfaces/APIs/endpoints → Section III mandate
  - RED FLAGS for guessing → Duplicated in Section III
  - MANDATORY WORKFLOW → Covered by "MUST ALWAYS search and verify"
- **Recoverable**: Yes, via git history if needed

### 2. SIMPLIFIED (Removed Redundant Sections)

#### `testing/test-driven-development.md`
**Removed**:
- "Critical Workflow" section (lines 95-99)
- First two Anti-patterns: "Skip tests" and "Proceed with failing tests"

**Reason**: Covered by core-mandates.md Section II (Testing Discipline)

**Kept**:
- TDD Cycle methodology (RED-GREEN-REFACTOR)
- Testing Pyramid (70/20/10 split)
- Test Structure (AAA pattern)
- Test Doubles and Mocking Rules
- FIRST principles
- Remaining anti-patterns (implementation-specific)

**Token savings**: ~120 tokens

---

#### `development-process/brownfield-development.md`
**Removed**:
- "Ask user before new patterns" from Core Rules
- "Ask user if infrastructure seems broken" from Investigation Protocol
- Entire "When to Ask User" section

**Reason**: Covered by core-mandates.md Section IV (Collaboration & Permission Gates)

**Kept**:
- Assume existing code works
- Pattern Discovery commands
- Investigation Protocol (minus user consultation)
- Planning Anti-Patterns (brownfield-specific)
- Checklist

**Token savings**: ~90 tokens

---

#### `code-quality/immediately-runnable-code.md`
**Action**: Complete rewrite using Gemini's strengthened version

**Removed**:
- Redundant "Completeness Standards" that duplicated Section V
- Redundant "Always Include" that duplicated Section V
- Verbose explanations

**Strengthened**:
- All directives now use "You **MUST ALWAYS**" / "You **MUST NEVER**" patterns
- Clearer separation: WHAT standards vs HOW to achieve them
- Focused on practical implementation guidance

**Token savings**: ~300 tokens

---

### 3. STRENGTHENED (Language Improvements)

#### `development-process/tdd-human-review-cycle.md`
**Changes**:
- "**ALWAYS** stop" → "You **MUST ALWAYS** stop"
- "**NEVER** proceed" → "You **MUST NEVER** proceed"
- "**SHOW**" → "You **MUST SHOW**"
- "**WAIT**" → "You **MUST WAIT**"
- "**ASK**" → "You **MUST ASK**"
- "human" → "user" (consistency)

**Reason**: Align with ultra-concise-enforcement.md directive patterns

**No content removed**: All sections kept, just language strengthened

---

#### `code-quality/code-review-principles.md`
**Changes**:
- "ALWAYS provide pros and cons" → "You **MUST ALWAYS** provide pros and cons"
- "NEVER be a 'yes man'" → "You **MUST NEVER** be a 'yes man'"
- Added explicit "You **MUST**" / "You **MUST NEVER**" throughout
- Clarified: "Request design changes" must be done with user approval beforehand (links to Section IV)
- Added severity levels to feedback categories

**Reason**: Consistency with core-mandates.md patterns

**No content removed**: All valuable guidance retained

---

#### `communication/balanced-analysis.md`
**Changes**:
- "ALWAYS provide pros and cons" → "You **MUST ALWAYS** provide pros and cons"
- "NEVER be a 'yes man'" → "You **MUST NEVER** be a 'yes man'"
- Added **explicit link to STOP-and-Ask protocol**: "If pushing back blocks completion, you **MUST IMMEDIATELY STOP** and initiate the 'STOP and Ask' protocol"
- Strengthened all directives with MUST/NEVER patterns

**Reason**: Align with core-mandates.md and make protocol references explicit

**No content removed**: All sections kept, links to STOP protocol added

---

## Total Token Savings

**From deletions and simplifications**: ~510 tokens

**Notes**:
- Savings only apply when guidance is explicitly loaded via @-references
- Token cost is not on every conversation (unlike system prompt)
- Reduced cognitive load - less duplication between files

## Side Effects / Breaking Changes

### Bundle Files May Need Updates
If any bundle files reference the deleted `no-interface-guessing.md`, they'll need updating:
```bash
grep -r "no-interface-guessing" ~/.claude/guidance/bundles/
```

**Check**: `bundles/foundation/software-dev.md` and `bundles/domain/coding.md`

### @-References Need Checking
Any CLAUDE.md or other files that reference deleted guidance:
```bash
grep -r "@.*no-interface-guessing" ~/.claude/
grep -r "@.*no-interface-guessing" ~/code/*/
```

## Quality Improvements

### 1. Consistency
All guidance now uses uniform language patterns:
- "You **MUST ALWAYS**" for requirements
- "You **MUST NEVER**" for prohibitions
- Explicit protocol references (STOP-and-Ask)

### 2. Clarity
Clear separation between:
- **Behavioral constraints** (system prompt): "Never skip tests"
- **Implementation guidance** (context files): "Here's how to structure tests"

### 3. Reduced Redundancy
No longer duplicating:
- Testing discipline rules
- Verification requirements
- Collaboration gates
- Completion standards

These are now in ONE authoritative place (core-mandates.md)

## Testing Recommendations

### 1. Verify Bundle References
```bash
cd ~/.claude/guidance/bundles
grep -r "no-interface-guessing" .
```
If found, update bundle files to remove references.

### 2. Check CLAUDE.md References
```bash
grep "no-interface-guessing" ~/.claude/CLAUDE.md
grep "no-interface-guessing" ~/code/*/.claude/CLAUDE.md
```

### 3. Functional Test
Load modified guidance files via @-references and verify:
- Content still makes sense
- No missing information
- Strengthened language works as expected

### 4. Red-Team Test
Try to bypass directives in updated files:
- "Just this once..."
- "It's faster if I..."
- "The user probably wants..."

Verify the strengthened language holds up.

## Next Steps (If Needed)

### Optional Follow-Up Reviews
Gemini didn't review all guidance files. Could review:
- `architecture/api-integration.md`
- `security/validation-and-authorization.md`
- `documentation/task-handoffs.md`
- All bundle files
- Remaining domain-specific guidance

### Bundle Updates
Check and update:
- `bundles/foundation/software-dev.md` - may reference deleted file
- `bundles/domain/coding.md` - may reference deleted file

### Documentation Updates
Update README.md if it references deleted files (already updated with new structure).

## Files Changed

**Deleted**: 1
- `development-process/no-interface-guessing.md`

**Modified**: 6
- `testing/test-driven-development.md`
- `development-process/brownfield-development.md`
- `development-process/tdd-human-review-cycle.md`
- `code-quality/immediately-runnable-code.md`
- `code-quality/code-review-principles.md`
- `communication/balanced-analysis.md`

**Total files affected**: 7

## Success Criteria Met

✅ Removed redundancy with core-mandates.md
✅ Strengthened language with MUST/NEVER patterns
✅ Applied ultra-concise-enforcement.md principles
✅ Maintained all unique, valuable guidance
✅ Improved consistency across guidance library
✅ Linked context guidance to STOP-and-Ask protocol
✅ Token savings achieved (~510 tokens)
✅ All changes recoverable via git

## Recommendations

1. **Source the alias** to activate core-mandates.md:
   ```bash
   source ~/.zshrc
   ```

2. **Test in real usage** before doing more cleanup

3. **Monitor effectiveness** - does the system prompt actually enforce better?

4. **Red-team test** periodically to find new bypasses

5. **Consider Phase 2** review of remaining files once Phase 1 is validated
