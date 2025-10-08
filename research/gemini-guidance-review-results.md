# Gemini Guidance Review Results

Date: 2025-10-08
Reviewer: Gemini via gemini-bridge MCP

## Summary of Findings

Reviewed guidance files against `prompts/core-mandates.md` to identify redundancies and improvement opportunities.

## Critical Findings

### Files with Significant Redundancy (High Priority)

#### 1. `development-process/no-interface-guessing.md` - **DELETE ENTIRELY**

**Redundancy Level**: 95%+ overlap with core-mandates.md Section III

**Overlapping Content**:
- "STOP. SEARCH. VERIFY. OR ASK." → Covered by Section III
- "Never guess: Model properties, Function signatures, API endpoints..." → Exact match
- "MANDATORY WORKFLOW" → Covered by "MUST ALWAYS actively search and verify"
- "RED FLAGS IN YOUR THINKING" → Duplicated in Section III
- "ENFORCEMENT: No exceptions. Ever." → Covered by meta-directive

**Recommendation**: Delete entirely. Core mandates already enforce this with stronger language and STOP-and-Ask protocol.

**What to Keep**: Could extract the specific bash search examples to a "how-to" guide if needed, but the directive itself is fully covered.

---

#### 2. `testing/test-driven-development.md` - **SIMPLIFY**

**Redundancy Level**: ~40% overlap with Section II

**Remove These Sections**:
```markdown
## Critical Workflow
1. Make ANY change (code/docs/formatting)
2. Run relevant tests
3. Fix failures immediately
4. Only proceed when green

## Anti-patterns
- NEVER: Skip tests for "harmless" changes
- NEVER: Proceed with failing tests
```

**Why**: Directly covered by Section II testing discipline mandates.

**Keep These Sections**:
- TDD Cycle (RED-GREEN-REFACTOR)
- Testing Pyramid specifics (70/20/10 split)
- Test Structure (AAA pattern)
- When to Use Each Level (Unit/Integration/E2E)
- Test Doubles and Mocking Rules
- FIRST principles

**Reasoning**: These provide specific TDD methodology details not in core mandates. Focus on "how to do TDD" not "you must test".

---

#### 3. `development-process/brownfield-development.md` - **SIMPLIFY**

**Redundancy Level**: ~30% overlap with Section IV

**Remove These Sections**:
```markdown
## Core Rules
- Ask user before new patterns  # Covered by Section IV

## When to Ask User
- New architectural patterns     # Covered by Section IV
- Infrastructure-wide issues
- New models/tables
- Deviating from conventions
```

**Keep These Sections**:
- Assume existing code works
- Pattern Discovery commands
- Investigation Protocol (minus "ask user" parts)
- Planning Anti-Patterns (over-specification, premature abstraction)
- Checklist for brownfield work

**Reasoning**: Unique brownfield-specific patterns remain valuable. Remove collaboration/permission aspects now in core mandates.

---

#### 4. `development-process/tdd-human-review-cycle.md` - **SIMPLIFY & STRENGTHEN**

**Redundancy Level**: ~25% overlap with Section II

**Strengthen (using MUST/NEVER patterns)**:

**Before**:
```markdown
## Human Review Requirements
- ALWAYS stop after GREEN phase
- NEVER proceed to refactor without explicit human approval
- SHOW current test status and minimal implementation
- WAIT for human confirmation before refactoring
- ASK "Ready to refactor?" or "Proceed to next cycle?"
```

**After**:
```markdown
## Human Review Requirements
- You **MUST ALWAYS** stop after GREEN phase.
- You **MUST NEVER** proceed to refactor without explicit user approval.
- You **MUST SHOW** current test status and minimal implementation to the user.
- You **MUST WAIT** for user confirmation before refactoring.
- You **MUST ASK** "Ready to refactor?" or "Proceed to next cycle?"
```

**Keep**: This specific workflow is unique and valuable. Just strengthen the language.

---

### Files Needing Strengthening (Medium Priority)

#### 5. `code-quality/immediately-runnable-code.md` - **SIMPLIFY**

**Redundancy Level**: ~50% overlap with Section V

**Remove**:
- "Full implementations - No placeholder functions" → Section V
- "All imports included" → Section V
- "Error handling present" → Section V
- Common incompleteness patterns for TODOs/placeholders → Section V

**Keep & Strengthen**:
- Code completeness checklist (practical application)
- Specific error handling patterns
- When pseudocode is acceptable (exceptions to the rule)
- Anti-patterns list (implementation-specific)

**Proposed Rewrite**: Gemini provided full strengthened version focusing on HOW to achieve completion standards, not WHAT the standards are.

---

#### 6. `code-quality/code-review-principles.md` - **STRENGTHEN LANGUAGE**

**Redundancy Level**: Minimal (no direct overlap)

**Changes**: Apply MUST/NEVER patterns throughout:
- "ALWAYS provide pros and cons" → "You **MUST ALWAYS** provide pros and cons"
- "NEVER be a yes man" → "You **MUST NEVER** be a yes man"
- "DON'T Request design changes in review" → "You **MUST NEVER** request major architectural changes; these **MUST** be discussed with user beforehand"

**Keep**: All content is valuable and complements Section IV. Just strengthen language for consistency.

---

#### 7. `communication/balanced-analysis.md` - **STRENGTHEN LANGUAGE**

**Redundancy Level**: ~20% overlap (one core principle duplicated)

**Overlap**: "ALWAYS provide pros and cons" is restated in Section IV.

**Changes**:
- Strengthen all directives with MUST/NEVER
- Explicitly link "When to Push Back" to STOP-and-Ask protocol
- Keep detailed guidance on HOW to do balanced analysis

**Keep**: Serves as detailed implementation guide for Section IV's "present options" mandate.

---

## Prioritized Action Items

### High Priority (Do First)

1. **DELETE**: `development-process/no-interface-guessing.md`
   - 95%+ redundant with Section III
   - Already enforced in system prompt
   - No unique value remaining

2. **SIMPLIFY**: `testing/test-driven-development.md`
   - Remove "Critical Workflow" section (redundant)
   - Remove "Anti-patterns" for test skipping (redundant)
   - Keep TDD methodology specifics

3. **SIMPLIFY**: `development-process/brownfield-development.md`
   - Remove "When to Ask User" section
   - Remove "ask user" bullets from other sections
   - Keep brownfield-specific patterns

### Medium Priority (Do Next)

4. **SIMPLIFY**: `code-quality/immediately-runnable-code.md`
   - Use Gemini's proposed rewrite
   - Remove overlap with Section V
   - Focus on practical implementation

5. **STRENGTHEN**: `development-process/tdd-human-review-cycle.md`
   - Apply MUST/NEVER throughout
   - Keep all content (unique workflow)

6. **STRENGTHEN**: `code-quality/code-review-principles.md`
   - Apply MUST/NEVER throughout
   - No deletions needed

7. **STRENGTHEN**: `communication/balanced-analysis.md`
   - Apply MUST/NEVER throughout
   - Link to STOP-and-Ask protocol
   - Keep all content

### Low Priority (Future)

8. Review remaining guidance files not yet analyzed:
   - `architecture/api-integration.md`
   - `security/validation-and-authorization.md`
   - `documentation/task-handoffs.md`
   - Bundle files

---

## Key Patterns Identified

### 1. Directive Hierarchy Emerging

**System Prompt (core-mandates.md)**:
- Behavioral constraints: "You MUST NEVER..."
- Non-negotiable rules
- STOP-and-Ask protocols

**Context Guidance**:
- Implementation details: "How to do X"
- Specific patterns and examples
- Domain knowledge

**Clear Separation**: "Don't skip tests" vs "Here's how to write good tests"

### 2. Language Strengthening Opportunities

Many guidance files use:
- ❌ "ALWAYS do X" (softer)
- ❌ "NEVER do Y" (less formal)

Should use:
- ✅ "You **MUST ALWAYS** do X"
- ✅ "You **MUST NEVER** do Y"

This creates consistency with ultra-concise-enforcement.md patterns.

### 3. STOP-and-Ask Integration

Several files have implicit "ask user" or "stop" points that should explicitly reference the formal STOP-and-Ask protocol:
- "When to Push Back" in balanced-analysis.md
- "Ask user if..." in brownfield-development.md
- "Wait for confirmation" in tdd-human-review-cycle.md

---

## Token Savings Estimate

**Deletions**:
- `no-interface-guessing.md`: ~100 lines = ~600 tokens saved

**Simplifications** (removing redundant sections):
- `test-driven-development.md`: ~20 lines = ~120 tokens saved
- `brownfield-development.md`: ~15 lines = ~90 tokens saved
- `immediately-runnable-code.md`: ~50 lines = ~300 tokens saved

**Total Estimated Savings**: ~1,110 tokens from high-priority changes

**When these are loaded**: Savings occur only when guidance is explicitly loaded via @-references.

---

## Implementation Notes

### Before Making Changes

1. **Backup current guidance**:
   ```bash
   cp -r ~/.claude/guidance ~/.claude/guidance-backup-$(date +%Y%m%d)
   ```

2. **Test after each change**: Verify guidance still works when loaded

3. **Update bundles**: If guidance files are referenced in bundles, update those references

### Testing Strategy

After changes, test by:
1. Loading modified guidance via @-references
2. Verifying no information loss
3. Checking if behavioral changes are as expected
4. Running red-team tests (try to bypass directives)

---

## Questions for User

1. **Immediate deletion?** Should we delete `no-interface-guessing.md` immediately, or keep as reference until core-mandates.md is proven effective?

2. **Backup strategy?** Keep deleted content in an archive folder vs truly delete?

3. **Bundle updates?** Several bundle files reference guidance that will change. Update bundles as part of this work or separately?

4. **Phased rollout?** Do all changes at once, or test high-priority items first?
