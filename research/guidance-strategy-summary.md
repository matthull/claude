# Guidance Creation & Validation Strategy Summary

## Key Insights from Core Mandates Research

### 1. Three-Tier Guidance Architecture

**System Prompt (Highest Priority)**
- Location: `~/.claude/prompts/core-mandates.md`
- Loaded: Via shell alias `--append-system-prompt`
- Purpose: Non-negotiable behavioral constraints
- Token cost: ~500 tokens on every invocation
- Use for: Testing discipline, verification gates, permission requirements

**CLAUDE.md (Auto-loaded Context)**
- Location: `~/.claude/CLAUDE.md` or `./.claude/CLAUDE.md`
- Loaded: Automatically at startup as first user message
- Purpose: Project workflows, preferences, modular guidance loading
- Token cost: Variable, on every conversation start

**Context Guidance (On-demand)**
- Location: `~/.claude/guidance/` or `.claude/guidance/`
- Loaded: Via @-references when needed
- Purpose: Implementation patterns, best practices, domain knowledge
- Token cost: Only when explicitly loaded

### 2. Decision Framework

**When to use System Prompt:**
- Behavioral constraints (NEVER do X, ALWAYS do Y)
- Permission gates (require user approval)
- Testing discipline (non-negotiable)
- Verification requirements (must search before using)
- Formal protocols (STOP and Ask)

**When to use CLAUDE.md:**
- Workflow preferences
- Environment details
- Guidance loading instructions
- Project-specific conventions

**When to use Context Guidance:**
- Implementation patterns
- Code quality standards
- Framework-specific techniques
- Domain knowledge

**Decision Test**: Does this constrain Claude's behavior (→ System Prompt) or provide information for Claude to use (→ Guidance)?

### 3. Linguistic Patterns for Maximum Adherence

**Strength Hierarchy:**
1. Section headers: (ABSOLUTE), (NON-NEGOTIABLE), (CRITICAL)
2. Primary keywords: MUST NEVER, MUST ALWAYS, MUST IMMEDIATELY STOP
3. Emphasis: NO EXCEPTIONS, ABSOLUTELY
4. Triggers: IF/WHEN [condition], THEN [action]

**Effective Structures:**
- Conditional: `IF [trigger]: MUST IMMEDIATELY STOP and [protocol]`
- Absolute: `MUST NEVER [action] for any reason, under any circumstance`
- Required: `MUST ALWAYS [action]`
- Prohibited: `MUST NOT rationalize, reinterpret, or seek exceptions`

**Repetition Strategy:**
- Repeat key concepts in different phrasings
- Use strong keywords consistently
- Reinforce with consequences ("constitutes critical operational failure")

### 4. Anti-Rationalization Techniques

**Meta-Directive Pattern:**
```markdown
You **MUST NOT** rationalize, reinterpret, or seek exceptions to these mandates.
There are **NO EXCEPTIONS**.
```

**Explicit Consequences:**
```markdown
Any attempt to circumvent these mandates constitutes a critical operational failure.
```

**Red Flag Detection:**
Include explicit examples of prohibited thinking:
- "It probably has..."
- "Usually this would..."
- "Just this once..."
- "It's faster if I..."

### 5. Formal Protocol Pattern

**STOP and Ask Protocol:**
```markdown
When required to STOP:
1. HALT current task
2. State which mandate triggered
3. Explain exact blocker
4. Request specific guidance
5. AWAIT explicit instruction
```

Benefits:
- Removes ambiguity about what to do
- Provides structured communication format
- Prevents guessing or workarounds

### 6. Validation Testing Strategies

**Behavioral Constraints:**
- ✅ **Bypass Test**: Try to rationalize exception (should fail)
- ✅ **Ambiguity Test**: Check for multiple interpretations (should have one)
- ✅ **Trigger Test**: Verify clear application conditions (should be obvious)
- ✅ **Consequence Test**: Confirm explicit outcomes (should be stated)

**Context Guidance:**
- ✅ **Conciseness Test**: Remove 50% of words (if possible, do it)
- ✅ **Actionability Test**: Can someone immediately apply? (should be yes)
- ✅ **Specificity Test**: Examples concrete? (should be yes)
- ✅ **Universality Test**: Works across projects? (for global: yes)

**Red-Team Testing:**
Attempt bypass with:
- "Just this once..."
- "It's faster if I..."
- "The user probably wants..."
- "Standard practice is..."

If directive can be rationalized away, strengthen it.

### 7. Token Economics

**System Prompt Trade-offs:**
- ✅ Pros: Highest priority, most "sticky", hardest to override
- ❌ Cons: Loaded every invocation, ~500 token cost on all conversations
- 📊 Decision: Only use for truly universal, critical constraints

**Context Guidance Trade-offs:**
- ✅ Pros: Only loaded when needed, granular control
- ❌ Cons: Lower priority, easier to ignore
- 📊 Decision: Use for implementation details, patterns, domain knowledge

### 8. One-Line Rationale Exception

**For System Prompts Only:**
After directive blocks, include brief rationale:
```markdown
**RATIONALE:** [One sentence explaining consequence/risk]
```

This is the ONLY acceptable explanatory content in behavioral directives.

**Why it helps:**
- Provides context for WHY rule exists
- Reinforces seriousness
- Aids in edge case decisions

**Keep it to ONE sentence** - resist explanation creep.

### 9. Conciseness vs Clarity Trade-off

**Standard Guidance:** Ultra-concise (50% reduction test)
**Behavioral Directives:** Repetition and emphasis required

This is a deliberate exception - behavioral constraints need:
- Multiple phrasings for same concept
- Emphatic keywords
- Explicit consequences
- Formal protocols

**Don't apply conciseness rules to system prompt directives.**

### 10. Reality Check on Effectiveness

**No directive is 100% unbypassable** via prompting alone.

Research shows:
- Prompt injection: 86% success rate
- Constitutional AI (training-time): Reduces to 4.4%
- Multi-layered defenses: 95%+ protection

**True enforcement requires:**
1. System prompt directives (95% adherence)
2. Automated gates (CI/CD blocking on test failures)
3. Process enforcement (hooks, monitoring)
4. User discipline (red-team testing, feedback)

**Set realistic expectations:** System prompts create strong defaults, not perfect compliance.

---

## Recommended Workflow

### Creating New Behavioral Constraints

1. **Identify the constraint** - What behavior needs to be prevented/enforced?
2. **Test the decision framework** - Does this constrain behavior or provide info?
3. **Choose the tier** - System prompt (universal) or CLAUDE.md (project)?
4. **Write with maximum strength** - Use MUST/NEVER/ALWAYS patterns
5. **Add formal protocol** - What exactly happens when triggered?
6. **Include one-line rationale** - Why does this matter?
7. **Red-team test** - Try to bypass it
8. **Strengthen if needed** - Add anti-rationalization if bypassed

### Creating New Context Guidance

1. **Identify the pattern** - What knowledge needs to be conveyed?
2. **Ultra-concise it** - Apply 50% reduction test
3. **Make it actionable** - Clear triggers and examples
4. **Test universality** - Global or project-specific?
5. **Add to appropriate bundle** - Foundation/Domain/Practice/Technique
6. **Document in README** - Add to discovery

### Maintaining the System

**Monthly Review:**
- Check if directives are being followed
- Identify new bypass attempts
- Strengthen weak points
- Remove obsolete rules

**Token Audit:**
- Measure context usage
- Identify redundancy
- Consolidate when possible
- Balance effectiveness vs cost

**User Feedback:**
- What behaviors are still problematic?
- What directives are too restrictive?
- What's missing?
