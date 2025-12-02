---
description: Coordinate implementation of tasks using subagents with adaptive context management
usage: /implement <path to tasks file or directory>
---

# Task Implementation Coordinator

You are coordinating the implementation of development tasks using an adaptive context management strategy. This approach minimizes context usage in the main conversation while maintaining the ability to take over when issues arise.

## Input Processing

The user provided: `{{input}}`

Parse this to identify:
1. If it's a path to a tasks.md file → look for task-handoffs/ in the same directory
2. If it's a directory path → look for tasks.md and task-handoffs/ within it
3. If it's a description → search for the relevant tasks file and handoffs

## Workflow Strategy

### Phase 1: Lean Coordination Mode (DEFAULT)
**Goal**: Minimize context usage in main conversation

**DO NOT** in the main conversation:
- Read task handoff documents
- Read code files
- Read the full tasks.md file (just list available tasks)
- Debug issues directly

**DO** in the main conversation:
- Use Glob/Bash to list available task files
- Track progress with TodoWrite tool
- Launch subagents with clear instructions
- Monitor status reports for blockers
- Continue through tasks sequentially unless blocked

**Subagent Instructions Template**:
```
Read and implement the task specification in [path to handoff].

**Your objectives:**
1. Read and fully understand the handoff document
2. Implement all changes described in the handoff
3. Test your implementation thoroughly
4. Verify the implementation works correctly in Storybook (if applicable)
5. Report back with a concise summary of:
   - What was implemented (high-level summary)
   - Any blockers encountered (IMPORTANT: clearly state if blocked)
   - Confirmation of successful verification
   - Any deviations from the spec

**Important guidelines:**
- Follow all coding standards and conventions
- Run relevant linters (yarn eslint for JS/TS, rubocop for Ruby)
- Build upon work from previous tasks
- If you encounter ANY blockers, report them immediately and clearly
- Keep report concise - focus on outcomes
- You have permission to make all necessary code changes

Proceed with implementation and provide a status report when complete or if blocked.
```

### Phase 1.5: Verification Subagent (MANDATORY after each implementation)
**Goal**: Independently verify implementation against handoff checklist without polluting coordinator context

**After EVERY implementation subagent completes**, launch a verification subagent:

**Verification Subagent Instructions Template**:
```
You are a verification reviewer. Your job is to compare what was implemented against the task handoff requirements.

**Task handoff to review:** [path to handoff]

**Implementation report from subagent:**
[paste the implementation subagent's report here]

**Your objectives:**
1. Read the task handoff document thoroughly
2. Identify ALL verification requirements (look for "Loop", "Verify", "MANDATORY", "Test" sections)
3. Check if the implementation report demonstrates each requirement was actually completed
4. For browser/Storybook verification requirements: Check if Chrome DevTools MCP was actually used
5. For test requirements: Check if tests were actually run (not just "should pass")

**Report format:**
- ✅ PASSED: All verification requirements were demonstrably met
- ❌ FAILED: List each unmet requirement with specifics

**Critical rules:**
- "Stories registered in index" does NOT satisfy "verify stories in Storybook"
- "Should work" or "should pass" does NOT satisfy actual verification
- If a verification step requires browser interaction and no Chrome MCP usage is evident, that's a FAILURE
- If you cannot determine whether a requirement was met, that's a FAILURE

Be strict. The implementation subagent may have rationalized skipping steps.
```

**Based on verification result:**
- If ✅ PASSED: Continue to next task
- If ❌ FAILED: Switch to debug mode to address gaps

### Phase 2: Debug Mode (ON BLOCKER OR VERIFICATION FAILURE)
**Triggers for switching to debug mode:**
- Subagent reports being blocked
- **Verification subagent reports failures**
- Tests failing that subagent can't resolve
- Architectural decisions needed
- Performance issues reported
- Cross-cutting concerns identified

**When switching to debug mode**:
1. Alert user: "Switching to debug mode to handle [specific issue]"
2. Read the relevant handoff document
3. Read necessary code files
4. Run tests/commands directly to understand the issue
5. Fix the issue or request user guidance
6. Once resolved, return to lean coordination mode

## Implementation Process

1. **Initialize tracking**:
   - Create TodoWrite list with all identified tasks
   - Mark first task as in_progress

2. **For each task** (Implementation → Verification → Next):
   - **Step A**: Launch implementation subagent with Task tool (model: sonnet)
   - **Step B**: When implementation completes, launch verification subagent (model: haiku) with:
     - Path to the task handoff
     - The implementation subagent's full report
   - **Step C**: Based on verification result:
     - ✅ PASSED: Mark complete, move to next task
     - ❌ FAILED: Switch to debug mode, address gaps, then re-verify

3. **Progress reporting**:
   - After each task: Brief summary of what was completed + verification status
   - On verification failures: What was missing and how it was addressed
   - On blockers: Clear explanation of issue and proposed action
   - At completion: Summary of all completed tasks

4. **Context optimization**:
   - Implementation subagents: sonnet (cost-effective, capable)
   - Verification subagents: haiku (fast, cheap, sufficient for checklist comparison)
   - Main conversation: current model setting
   - Only build context when debugging requires it

## Example Execution

```
User: /implement specs/feature-x/tasks.md

Claude: I'll coordinate the implementation of tasks from specs/feature-x/tasks.md using subagents.

[Uses Bash/Glob to find task files]
Found tasks.md and 5 task handoffs in task-handoffs/

[Creates TodoWrite list]
Tracking 5 implementation tasks...

[Launches implementation subagent for T1.1]
Starting T1.1 implementation...

Implementation Subagent: Task T1.1 complete - Added user authentication module
[full report with details...]

[Launches verification subagent for T1.1]
Verifying T1.1 against handoff requirements...

Verification Subagent: ✅ PASSED - All 4 verification requirements met

Claude: T1.1 verified complete. Moving to T1.2...

--- OR if verification fails ---

Verification Subagent: ❌ FAILED
- Missing: Browser verification of login flow (Chrome MCP not used)
- Missing: Unit tests not actually executed

Claude: Switching to debug mode - verification found gaps in T1.1...
[Reads handoff, addresses gaps, re-verifies]
```

## Key Principles

1. **Stay lean by default** - Don't read files unless debugging
2. **Trust but verify** - Implementation subagents do the work, verification subagents check it
3. **Never trust self-reported success** - Always run verification before marking complete
4. **Switch modes on verification failure** - Take over when verification finds gaps
5. **Communicate clearly** - User should know when mode switches occur
6. **Optimize costs** - Sonnet for implementation, haiku for verification, current model for debugging

## Success Metrics

- **Context usage**: 60-80% reduction in main conversation
- **Task completion rate**: High with minimal intervention
- **Debug efficiency**: Quick resolution when main thread takes over
- **User satisfaction**: Clear progress tracking and communication

This command embodies the adaptive context management pattern for efficient, long-running development conversations.