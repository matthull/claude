# Plan: Subagent Architecture for /handoff Template Constraint Enforcement

**Date**: 2025-10-29
**Context**: Pattern contamination in long sessions causing template constraint violations
**Analysis**: Based on T014-T015 investigation and TEMPLATE-DEGRADATION-ANALYSIS.md

---

## Problem Statement

The `/handoff` command suffers from **pattern contamination** in long sessions:
- 9 consecutive backend handoffs established RSpec test pattern
- 10th handoff (Vue component) should use Storybook but got Vitest tests instead
- Template constraints present (frontmatter correct) but violated in content generation
- Root cause: Pattern momentum from session context overrides template constraints

## Solution: Generation Subagent with Fresh Context Isolation

### Architecture (Option A - Recommended)

```
/handoff invoked
    ↓
Main Agent: Task analysis (detect technology, prerequisites)
    ↓
Main Agent: Template selection (which sections to include)
    ↓
Main Agent: Launch Task tool → "handoff-generator" subagent
    ↓
Subagent: Read templates FRESH (no session context bleed)
Subagent: Extract CRITICAL constraints
Subagent: Compose document with constraint awareness
Subagent: Generate TDD examples matching template requirements
Subagent: Self-validate against constraints
Subagent: Return complete handoff
    ↓
Main Agent: Save to file, report to user
```

### Why This Works

1. **Fresh Context**: Subagent starts clean, reads templates fresh without 9 backend handoffs in context
2. **Constraint Extraction**: Parses templates for MUST NEVER/MUST ALWAYS during generation
3. **Self-Validation**: Checks generated content against extracted constraints before returning
4. **Proven Pattern**: Follows successful `/task-review` subagent architecture

---

## Implementation Plan

### Phase 1: Create Generator Subagent (~2-3 hours)

**CRITICAL**: Use `/agents create handoff-generator` command to create properly structured subagent

**Location**: `.claude/agents/handoff-generator/` (created by /agents command)

**Subagent Structure** (per Claude Code requirements):
```
.claude/agents/handoff-generator/
├── agent.json          # Agent metadata and configuration
└── instructions.md     # Agent prompt and instructions
```

**Agent Configuration** (`agent.json`):
```json
{
  "name": "handoff-generator",
  "description": "Generates task handoff documents with fresh template context and constraint enforcement",
  "version": "1.0.0",
  "tools": ["Read", "Grep", "Glob"],
  "temperature": 0.7,
  "max_tokens": 8000
}
```

**Instructions File** (`instructions.md` ~400-500 lines):

**Key Sections**:
1. **Role and Expertise**
   - Specialized in handoff generation
   - Expert at template constraint extraction
   - Technology-aware (Ruby/Rails, Vue, API patterns)

2. **Constraint Extraction Rules**
   - Parse CRITICAL sections from templates
   - Extract MUST NEVER → Forbidden actions
   - Extract MUST ALWAYS → Required actions
   - Build internal constraint checklist

3. **Technology-Specific Generation**
   - **Ruby/Rails**: RSpec test patterns, fixture_builder usage
   - **Vue Components**: Storybook stories (NEVER Vitest for components)
   - **API Integration**: Documentation extraction first, security checks
   - Each with explicit examples and anti-patterns

4. **Template Composition Process**
   - Read core-task-template.md
   - Read selected section templates
   - Insert sections at SECTION HOOKs
   - Fill variables ({DATE}, {TASK_ID}, {CANONICAL_EXAMPLE_COMMANDS})
   - Generate TDD Cycle examples matching technology
   - Generate verification commands from templates

5. **Self-Validation Checklist**
   - Verify NO MUST NEVER violations
   - Verify ALL MUST ALWAYS requirements met
   - Check technology patterns match templates
   - Confirm no pattern contamination
   - ONLY return when fully compliant

6. **Examples of Correct Generation**
   - Ruby/Rails task → RSpec patterns
   - Vue component task → Storybook patterns
   - API integration task → Doc extraction patterns
   - Side-by-side comparisons of correct vs incorrect

7. **Anti-Patterns to Avoid**
   - Pattern contamination examples
   - Backend patterns applied to frontend
   - Missing CRITICAL constraints
   - Forbidden patterns present

8. **Output Format**
   - Complete markdown document
   - Validation status confirmation
   - Notes on constraints applied

### Phase 2: Update /handoff Command (~1 hour)

**Modify**: `.claude/commands/handoff.md`

**Changes**:
- Keep: Task analysis, template selection, prerequisite checking (steps 0-3)
- Replace: Direct composition (steps 4-7) with subagent invocation
- Add: Subagent launch via Task tool
- Add: Result validation and reporting

**New Composition Section** (replace lines 190-325):

```markdown
### 4. Launch Generator Subagent

**CRITICAL**: Use subagent for composition to ensure fresh template context

**Process**:
1. Prepare subagent context:
   ```
   Task Description: {from step 1}
   Technology Detected: {from step 1}
   Selected Templates: {from step 2}
     - core-task-template.md
     - sections/{technology}.md
     - sections/{domain}.md
   Canonical Examples: {from step 3}
   Prerequisites Read: {from step 0}
   Task ID: {determined or prompt user}
   Date: {current date}
   ```

2. Launch Task tool with handoff-generator subagent:
   ```
   subagent_type: "handoff-generator"
   description: "Generate task handoff"
   prompt: "
     Generate a task handoff document with the following context:

     Task Description: {description}
     Technology: {technology}
     Templates to include: {template_list}

     Read these templates FRESH:
     {for each template: full path}

     Extract CRITICAL constraints from templates.
     Generate content matching technology requirements.
     Self-validate before returning.

     Return complete handoff markdown with validation status.
   "
   ```

3. Receive generated handoff:
   - Full markdown document
   - Validation status: PASS/FAIL
   - Constraint notes

4. Verify validation_status: PASS
   - If FAIL: Report violations to user, ask to retry
   - If PASS: Proceed to save

5. Determine save location (existing logic from step 5)

6. Save handoff to file

7. Report to user:
   ```
   ✅ Created task handoff: {save_path}

   Prerequisites read:
     - {prerequisite_list}

   Templates used:
     - {template_list}

   Canonical examples included:
     - {example_list}

   ✅ Template constraint validation: PASS
     - Verified against all templates
     - No CRITICAL violations
     - Technology patterns correct

   Next steps:
   1. Review handoff and fill remaining variables
   2. Read canonical examples before implementing
   3. Follow TDD cycle: RED → GREEN → REFACTOR
   ```
```

**No Changes to**:
- Step 0: Prerequisite reading (lines 18-63)
- Step 1: Task detection (lines 66-95)
- Step 2: Template selection (lines 96-154)
- Step 3: Canonical examples (lines 156-189)
- Step 5: Save location (lines 229-254)
- Error handling (lines 327-366)

### Phase 3: Optional Validation Subagent (~1-2 hours)

**CRITICAL**: Use `/agents create handoff-validator` command

**Location**: `.claude/agents/handoff-validator/`

**Purpose**:
- Independent validation of any handoff (generated or manual)
- Safety check after generation
- Audit historical handoffs
- Development/debugging of generator

**Agent Configuration** (`agent.json`):
```json
{
  "name": "handoff-validator",
  "description": "Validates task handoff documents against template constraints",
  "version": "1.0.0",
  "tools": ["Read", "Grep", "Glob"],
  "temperature": 0.3,
  "max_tokens": 4000
}
```

**Instructions File** (`instructions.md` ~300 lines):

**Key Sections**:
1. **Role**: Template constraint validator
2. **Constraint Extraction**: Parse templates for CRITICAL sections
3. **Pattern Matching**: Regex patterns for violations
4. **Validation Logic**: Check MUST NEVER/MUST ALWAYS
5. **Reporting**: Structured violation reports with line numbers
6. **Pattern Library**: Technology-specific violation patterns

**Use Cases**:
- Post-generation safety check
- Manual handoff validation
- Batch audit of existing handoffs
- Development feedback for generator

### Phase 4: Testing & Documentation (~1 hour)

**Test Cases**:

1. **Fresh Session Test**
   ```bash
   # New session, single Vue handoff
   /handoff update SeismicIntegration component for sync config
   # Expected: Storybook patterns, no Vitest
   ```

2. **Long Session Test** (Critical)
   ```bash
   # Same session: 9 backend + 1 frontend
   /handoff implement model method (x9)
   /handoff update Vue component (x1)
   # Expected: Frontend handoff still uses Storybook, no contamination
   ```

3. **Technology Switch Test**
   ```bash
   # Rapid switches
   /handoff backend task
   /handoff frontend task
   /handoff backend task
   # Expected: Each uses correct patterns
   ```

4. **Validation Test**
   ```bash
   # Validate corrected T014-T015
   /validate specs/003-seismic-automated-sync/task-handoffs/T014-T015-update-seismic-vue-components.md
   # Expected: PASS with Storybook patterns
   ```

**Documentation Updates**:

1. **Update /handoff help** (`.claude/commands/handoff.md`):
   - Add "Architecture" section explaining subagent approach
   - Add "Constraint Enforcement" section
   - Add troubleshooting for validation failures

2. **Create architecture doc** (`~/.claude/research/handoff-architecture.md`):
   - Subagent isolation explanation
   - Constraint extraction approach
   - Pattern matching logic
   - Debugging guide

3. **Add examples** (`~/.claude/examples/handoff-generation/`):
   - Ruby/Rails backend example
   - Vue component example
   - API integration example
   - Each with correct patterns

---

## Files to Create/Modify

### New Agents (via /agents command)

1. `.claude/agents/handoff-generator/`
   - `agent.json` (configuration)
   - `instructions.md` (400-500 lines)

2. `.claude/agents/handoff-validator/` (optional)
   - `agent.json` (configuration)
   - `instructions.md` (300 lines)

### Modified Files

1. `.claude/commands/handoff.md` (~50 line changes)
   - Replace composition section (lines 190-325)
   - Add subagent invocation logic
   - Update reporting section

### Documentation Files

1. `~/.claude/research/handoff-architecture.md` (new)
2. `~/.claude/examples/handoff-generation/*.md` (new)

### No Changes

- All templates remain as-is (constraints already correct)
- No changes to project structure
- No changes to existing handoffs
- No changes to other commands

---

## Expected Outcomes

### Immediate Benefits

- ✅ Fresh context per handoff (no pattern contamination)
- ✅ Template constraints enforced during generation
- ✅ Self-validation before returning
- ✅ Works in sessions of any length

### Quality Improvements

- Zero CRITICAL constraint violations in generated handoffs
- Storybook patterns for Vue components (never Vitest)
- RSpec patterns for Ruby backend (never confused)
- Consistent template adherence regardless of session history

### Process Improvements

- Can generate 100 backend handoffs → 1 frontend handoff without contamination
- Technology changes handled cleanly
- Template updates automatically reflected in generation
- Independent validation capability for audit/review

---

## Timeline

- **Phase 1 (Generator Subagent)**: 2-3 hours
  - Create agent structure: 30 min (via /agents command)
  - Write instructions.md: 1.5-2 hours
  - Initial testing: 30 min

- **Phase 2 (Update /handoff)**: 1 hour
  - Modify command: 30 min
  - Integration testing: 30 min

- **Phase 3 (Validator - Optional)**: 1-2 hours
  - Create agent structure: 30 min (via /agents command)
  - Write instructions.md: 1 hour
  - Testing: 30 min

- **Phase 4 (Testing & Docs)**: 1 hour
  - Long session testing: 30 min
  - Documentation: 30 min

**Total**: 5-7 hours (or 4-5 hours without optional validator)

---

## Rollout Strategy

### Step 1: Create Generator Agent
```bash
# Use /agents command to create properly structured agent
/agents create handoff-generator

# Edit instructions.md with constraint extraction and generation logic
# Test in isolation with single invocation
```

### Step 2: Update /handoff Command
```bash
# Modify .claude/commands/handoff.md
# Replace composition section with subagent invocation
# Keep all other logic unchanged
```

### Step 3: Test Long Session
```bash
# Critical test: Does it prevent contamination?
# Generate 9 backend handoffs
# Then 1 frontend handoff
# Verify frontend uses Storybook, not Vitest
```

### Step 4: Add Validator (Optional)
```bash
# Use /agents command
/agents create handoff-validator

# Edit instructions.md with validation logic
# Add validation step to /handoff (optional safety check)
```

### Step 5: Document and Deploy
```bash
# Update documentation
# Add examples
# Create troubleshooting guide
# Ready for production use
```

---

## Success Criteria

- [ ] Generator subagent created via /agents command
- [ ] Generator properly structured in .claude/agents/
- [ ] Instructions.md includes constraint extraction
- [ ] Instructions.md includes technology-specific patterns
- [ ] /handoff command updated to use subagent
- [ ] Long session test: No pattern contamination
- [ ] Vue handoff generates Storybook (not Vitest)
- [ ] Backend handoff generates RSpec (not confused)
- [ ] All CRITICAL constraints enforced
- [ ] Self-validation catches violations
- [ ] Documentation complete

---

## Alternative: Quick Win with Validator Only

If you want a **faster initial solution** (1-2 hours):

1. Skip generator subagent (Phase 1)
2. Only create validator subagent (Phase 3)
3. Add validation step to /handoff after current generation
4. Catches violations reactively (not proactively)
5. Provides immediate safety net while planning full solution

**Trade-offs**:
- ✅ Faster to implement
- ✅ Immediate violation detection
- ❌ Still has contamination (just catches it)
- ❌ Requires main agent to fix violations
- ❌ Two-pass process (generate, then validate)

**Recommendation**: Full solution (generator + optional validator) for complete fix.

---

## Key Implementation Notes

### Critical Requirements

1. **MUST use /agents command**
   - Do NOT manually create agent directories
   - /agents ensures proper structure
   - Follows Claude Code agent conventions

2. **Agent location: .claude/agents/**
   - NOT .claude/commands/handoff-subagents/
   - Agents are separate from commands
   - Commands invoke agents via Task tool

3. **Subagent invocation pattern**
   ```markdown
   Task tool with:
   - subagent_type: "handoff-generator"
   - description: Short description
   - prompt: Full context and instructions
   ```

4. **Template reading**
   - Subagent uses Read tool
   - Fresh reads (not from session context)
   - Full template paths provided in prompt

5. **Constraint extraction**
   - Parse CRITICAL sections
   - Extract MUST NEVER/MUST ALWAYS
   - Build validation checklist
   - Check during generation

### Technology Pattern Requirements

**Ruby/Rails**:
- TDD RED: RSpec tests
- Loop 1: `bundle exec rspec spec/path/file_spec.rb`
- NEVER: Vitest, Jest, or other JS test frameworks

**Vue Components**:
- TDD RED: Storybook stories
- Loop 1: `npm run storybook` → Browser verification
- Loop 2: Verify ALL stories manually
- NEVER: Vitest component tests (mount, wrapper)
- NEVER: Options API patterns

**API Integration**:
- MUST: Documentation extraction first
- MUST: Security checklist
- MUST: VCR cassette patterns
- NEVER: Skip doc extraction

### Validation Pattern Requirements

**Constraint Severity**:
- CRITICAL: Zero tolerance, must fix
- WARNING: Should fix, quality issues
- INFO: Nice to have, suggestions

**Report Format**:
- List passed constraints
- Detail violations with line numbers
- Quote problematic code
- Provide fix recommendations
- Give PASS/FAIL verdict

---

## References

- **Analysis**: `specs/003-seismic-automated-sync/task-handoffs/TEMPLATE-DEGRADATION-ANALYSIS.md`
- **Postmortem**: `specs/003-seismic-automated-sync/task-handoffs/T014-T015-POSTMORTEM.md`
- **Templates**: `~/.claude/templates/task/`
- **Existing Command**: `.claude/commands/handoff.md`
- **Subagent Guidelines**: `.claude/commands/claude-code-subagent-design-guidelines.md`
- **Task Review Example**: `.claude/commands/task-review` (lines 30-199)

---

## Status

- [x] Problem analyzed
- [x] Root cause identified (pattern contamination)
- [x] Solution designed (generation subagent)
- [x] Architecture documented
- [x] Implementation plan created
- [ ] Generator subagent created
- [ ] /handoff command updated
- [ ] Testing completed
- [ ] Documentation finished
- [ ] Deployed to production

**Next Action**: Create generator subagent using `/agents create handoff-generator`
