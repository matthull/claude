---
name: task-review
description: Review uncommitted code against task handoff quality gates and guidelines
tags:
  - code-review
  - quality-assurance
  - task-management
scope: project
gitignored: true
---

# /task-review

## Usage
```
/task-review [handoff-file-path]
```

**Examples:**
```bash
# Use handoff from current task
/task-review

# Specify handoff file explicitly
/task-review specs/tasks/T001-feature-name.md
```

## Implementation

Use Task tool with code-review-expert subagent.

### Auto-Detect Handoff (CRITICAL)

**You MUST identify which handoff file initialized current task.**

**RATIONALE:** Wrong handoff = incorrect quality standards.

**Detection:**
1. Check conversation memory for handoff used in this session
2. If no handoff in conversation: Ask user to specify

**If no handoff found:**
```
❌ No task handoff found in conversation.

Which handoff should I review against?
  /task-review specs/tasks/T001-your-task.md

Or create handoff first:
  /handoff [task description]
```

**You MUST NEVER**:
- ❌ Guess based on file modification time
- ❌ Use arbitrary handoff
- ❌ Proceed without knowing active task
- ❌ Review against wrong standards

### Subagent Prompt Template

You are launching a `code-review-expert` subagent with the following prompt:

```markdown
# Senior Software Engineer Code Review

You are a senior software engineer conducting a rigorous code review. Your role is to ensure quality gates are met and best practices are followed.

## Your Review Focus

**CRITICAL:** You are reviewing uncommitted changes against the task handoff quality standards. Act as a senior engineer who:
- Is thorough and detail-oriented
- Catches issues before they reach production
- Prioritizes security, correctness, and maintainability
- Provides specific, actionable feedback
- References exact file:line locations
- Categorizes issues by severity

## Task Context

The developer is working on a task with the following handoff document:

{HANDOFF_FILE_CONTENTS}

## Uncommitted Changes

{GIT_DIFF_OUTPUT}

## Review Checklist

Systematically verify EACH item in these sections from the handoff:

### 1. CRITICAL Directives Compliance
- [ ] Scan for ALL "CRITICAL:" sections in handoff
- [ ] Verify NO violations of "MUST NEVER" constraints
- [ ] Verify ALL "MUST ALWAYS" requirements met
- [ ] Check RATIONALE sections - are consequences avoided?

### 2. Code Quality Checklist Verification
- [ ] Locate "Code Quality Checklist" section(s)
- [ ] Verify EACH checkboxed item
- [ ] Flag any unchecked items with evidence

### 3. Anti-patterns Detection
- [ ] Locate "Anti-patterns to Avoid" section(s)
- [ ] Scan code for ANY listed anti-patterns
- [ ] Cite exact violations with file:line

### 4. Technology-Specific Requirements
- [ ] Ruby/Rails: Check migration safety, environment checks, fixtures
- [ ] API: Check auth/authz, strong params, SQL safety
- [ ] Vue: Check Composition API, deprecated libraries, error handling
- [ ] All: Check test coverage, documentation, style

### 5. Security Review (if API work)
- [ ] Authentication present (before_action :authenticate_user!)
- [ ] Authorization verified (resource scoped to user)
- [ ] Strong parameters used (no permit!)
- [ ] No raw SQL queries
- [ ] No sensitive data exposed in responses
- [ ] Error messages sanitized

### 6. Testing Verification
- [ ] Tests exist for new/modified functionality
- [ ] Tests follow TDD patterns from handoff
- [ ] No skipped/pending tests without explanation
- [ ] Test quality meets handoff standards

## Output Format

Provide your review in this structure:

### 🎯 Review Summary
[Brief overview of changes and overall assessment]

### ✅ Compliance Status
- **CRITICAL Directives**: [PASS/FAIL with count]
- **Quality Gates**: [X/Y items verified]
- **Anti-patterns**: [None detected / X issues found]
- **Security**: [PASS/FAIL/N/A]
- **Testing**: [PASS/FAIL with coverage summary]

### 🚨 CRITICAL Issues (MUST FIX)
[Issues violating CRITICAL directives, security, or breaking changes]

**Format:**
```
- **[CRITICAL: Constraint Name]** - file.rb:42
  Violation: [Specific violation]
  Required: [What handoff requires]
  Fix: [Specific remediation]
```

### ⚠️ Quality Gate Failures (MUST ADDRESS)
[Unchecked checklist items from Code Quality Checklist]

**Format:**
```
- **[Checklist Item]** - file.rb:42
  Expected: [What checklist requires]
  Found: [What code actually does]
  Fix: [How to address]
```

### ❌ Anti-patterns Detected (SHOULD FIX)
[Code matching "Anti-patterns to Avoid" section]

**Format:**
```
- **[Anti-pattern Name]** - file.rb:42
  Pattern: [What was detected]
  Why problematic: [From handoff rationale]
  Recommendation: [Better approach]
```

### 💡 Suggestions (NICE TO HAVE)
[Additional improvements beyond handoff requirements]

### ✨ Strengths
[Good patterns observed, requirements met well]

### 📋 Pre-Commit Checklist
**Before committing, verify:**
- [ ] All CRITICAL issues resolved
- [ ] All Quality Gate failures addressed
- [ ] Anti-patterns refactored or documented exceptions
- [ ] All tests passing
- [ ] No debug statements (binding.pry, console.log)
- [ ] Linter passing
- [ ] Ready for peer review

## IMPORTANT

- **Be thorough**: Check EVERY CRITICAL directive, EVERY checklist item
- **Be specific**: Include file:line references for all issues
- **Be actionable**: Provide clear fix instructions
- **Be objective**: Follow handoff standards, not personal preferences
- **Categorize correctly**: CRITICAL vs Quality Gate vs Anti-pattern vs Suggestion
- **Fail gracefully**: If handoff unclear, ask for clarification rather than skip checks
```

### Execution Steps

1. **Locate Handoff Document**
   - If path provided: Use it directly
   - If no path: Check `.current-task` marker
   - If no marker: ERROR and ask user to specify

2. **Read Handoff Contents**
   - Use Read tool on handoff file
   - Validate it's a task-handoff (check frontmatter)

3. **Get Uncommitted Changes**
   ```bash
   git diff HEAD
   # Include both staged and unstaged changes
   ```

4. **Validate Changes Exist**
   - If no changes: Report "No uncommitted changes to review"
   - Exit gracefully

5. **Launch Code Review Subagent**
   - Use Task tool with code-review-expert subagent
   - Pass handoff contents + git diff as context
   - Wait for comprehensive review

6. **Present Results**
   - Show review summary
   - Highlight CRITICAL issues count
   - Provide pre-commit checklist
   - Offer to fix issues if user approves

## Enforcement Levels

1. **CRITICAL Violations** (Zero tolerance)
   - Breaking migrations
   - Missing auth/authz
   - Security vulnerabilities
   - Deprecated libraries

2. **Quality Gates** (Mandatory)
   - All handoff checklist items
   - Test coverage
   - No debug statements
   - Linter compliance

3. **Anti-patterns** (Remediation required)
   - Patterns from handoff list
   - Contextual fixes
   - Alternative approaches

4. **Suggestions** (Optional)
   - Maintainability
   - Performance
   - Consistency

## Example Output

```
🎯 Review Summary
Reviewing 4 files with 156 lines changed against T001-seismic-sync.md handoff.
Overall: 2 CRITICAL issues, 1 quality gate failure, 3 anti-patterns detected.

✅ Compliance Status
- CRITICAL Directives: FAIL (2 violations)
- Quality Gates: 8/9 items verified (1 failure)
- Anti-patterns: 3 issues found
- Security: PASS
- Testing: PASS (12 new tests, all passing)

🚨 CRITICAL Issues (MUST FIX)

- **[CRITICAL: Safe Database Migrations]** - db/migrate/20250109_add_sync_status.rb:5
  Violation: Migration adds `sync_status` column and uses it in same deploy
  Required: Safe addition pattern (add column, deploy, then use in next PR)
  Fix: Remove column usage from this PR, use in subsequent PR after deploy

- **[CRITICAL: Rails Environment Checks]** - app/services/seismic/sync_service.rb:42
  Violation: Uses `Rails.env.production?`
  Required: Positive environment checks: `['development', 'test'].include?(Rails.env)`
  Fix: Replace with `!['development', 'test'].include?(Rails.env)`

⚠️ Quality Gate Failures (MUST ADDRESS)

- **No caching without justification** - app/services/seismic/sync_service.rb:67
  Expected: Documented justification for caching OR query optimization first
  Found: Rails.cache.fetch without justification comment
  Fix: Add comment explaining why caching needed, or optimize query instead

❌ Anti-patterns Detected (SHOULD FIX)

- **Shared constants between strong_params and jbuilder** - app/controllers/api/seismic_controller.rb:15
  Pattern: FIELDS constant used in both strong_params and jbuilder
  Why problematic: Input acceptance and output presentation are separate concerns
  Recommendation: Inline parameters in strong_params, keep jbuilder independent

- **Use instance variables instead of let** - spec/services/seismic/sync_service_spec.rb:12
  Pattern: @service = SyncService.new(integration)
  Why problematic: Less explicit, harder to track dependencies
  Recommendation: Use `let(:service) { SyncService.new(integration) }`

- **Write one spec per response attribute** - spec/requests/api/seismic_controller_spec.rb:45-67
  Pattern: Separate specs for name, status, created_at, etc.
  Why problematic: Inefficient, harder to maintain
  Recommendation: One comprehensive spec checking all attributes per scenario

📋 Pre-Commit Checklist
Before committing, verify:
- [ ] All CRITICAL issues resolved (2 remaining)
- [ ] All Quality Gate failures addressed (1 remaining)
- [ ] Anti-patterns refactored or documented exceptions (3 remaining)
- [ ] All tests passing ✅
- [ ] No debug statements ✅
- [ ] Linter passing ✅
- [ ] Ready for peer review ⏳ (after fixes)
```

## Workflow

**Before every commit:**
```bash
/task-review              # Review against current task
# Fix all CRITICAL issues
# Address quality gates
# Refactor anti-patterns
/git:commit               # Commit when clean
```

## Related

- `/handoff` - Create task handoff
- `/code-review` - General review (not task-specific)
- `/git:commit` - Commit changes

ARGUMENTS: {HANDOFF_FILE_PATH}
