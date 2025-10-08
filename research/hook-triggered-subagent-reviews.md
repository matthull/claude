# Hook-Triggered Subagent Code Reviews

## Concept

Leverage Claude Code hooks to create file-type-specific code review gates that:
- Trigger automatically when files are edited/written
- Use subagents with targeted guidance for review
- Keep guidance rules out of main context
- Provide clear pass/fail feedback like linting, but for non-deterministic quality checks

## Motivation

**Problem:** Guidance library has extensive rules for different file types (Rails services, React components, etc.), but loading all relevant guidance into main context:
- Wastes tokens on rules not relevant to current task
- Pollutes context with preventive instructions
- Makes it harder to enforce specific patterns consistently

**Solution:** Use hooks to detect when review is needed, then suggest Claude spawn a subagent with targeted guidance loaded.

## How It Works

### Architecture

```
File Edit (Edit/Write tool)
    ↓
PostToolUse Hook (detect-review-needed.sh)
    ↓
Write review context to /tmp/review_context.json
    ↓
UserPromptSubmit Hook (suggest-review.sh)
    ↓
Inject "Consider using Task tool for review..." into context
    ↓
Claude spawns code-review-expert subagent
    ↓
Subagent loads targeted guidance + reviews file
    ↓
Pass/Fail result returned to main agent
```

### Implementation Pattern

#### 1. Detection Hook (PostToolUse)

`.claude/hooks/detect-review-needed.sh`
```bash
#!/bin/bash

# Read hook input
json_input=$(cat)
file_path=$(echo "$json_input" | jq -r '.tool_input.file_path // empty')

# Exit if no file path
[ -z "$file_path" ] && exit 0

# Map file types to guidance and subagent config
review_config=""

if [[ "$file_path" =~ app/services/.*\.rb$ ]]; then
  review_config=$(cat <<EOF
{
  "file": "$file_path",
  "guidance": "@.claude/guidance/rails/service-objects.md",
  "subagent": "code-review-expert",
  "focus": "Service object patterns and dependencies"
}
EOF
)
elif [[ "$file_path" =~ app/controllers/.*\.rb$ ]]; then
  review_config=$(cat <<EOF
{
  "file": "$file_path",
  "guidance": "@.claude/guidance/rails/controllers.md",
  "subagent": "code-review-expert",
  "focus": "Controller responsibilities and fat controller antipatterns"
}
EOF
)
elif [[ "$file_path" =~ \.tsx?$ ]]; then
  review_config=$(cat <<EOF
{
  "file": "$file_path",
  "guidance": "@.claude/guidance/frontend/react-components.md",
  "subagent": "code-review-expert",
  "focus": "React best practices and hooks usage"
}
EOF
)
fi

# Write review context if config found
if [ -n "$review_config" ]; then
  echo "$review_config" > /tmp/review_context.json
fi

exit 0
```

#### 2. Suggestion Hook (UserPromptSubmit)

`.claude/hooks/suggest-review.sh`
```bash
#!/bin/bash

# Check if review context exists
if [ ! -f /tmp/review_context.json ]; then
  exit 0
fi

# Read review config
file=$(jq -r '.file' /tmp/review_context.json)
guidance=$(jq -r '.guidance' /tmp/review_context.json)
focus=$(jq -r '.focus' /tmp/review_context.json)

# Inject suggestion into context
cat <<EOF
SYSTEM REMINDER: File review recommended for: $file

Consider using Task tool to spawn code-review-expert with:
- Load guidance: $guidance
- Review focus: $focus
- Provide clear pass/fail with specific issues

This keeps review rules out of main context while ensuring quality gates.
EOF

# Clear the review context
rm /tmp/review_context.json

exit 0
```

#### 3. Configuration

`.claude/settings.local.json`
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "/home/matt/.claude/hooks/detect-review-needed.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/home/matt/.claude/hooks/suggest-review.sh"
          }
        ]
      }
    ]
  }
}
```

## Benefits

### Context Efficiency
- Main agent doesn't load Rails service rules when editing frontend code
- Guidance loaded only when needed, in isolated subagent
- Reduces token usage by 60-80% for guidance rules

### Consistent Quality Gates
- Like linting, but for patterns that require LLM judgment
- Clear pass/fail feedback
- Automated enforcement without manual requests

### Flexible and Extensible
- Easy to add new file type mappings
- Can reference any guidance in library
- Subagent can use multiple guidance modules

### Non-Intrusive
- Suggestion pattern doesn't block workflow
- Claude can choose to skip review if inappropriate
- User maintains control

## Limitations (per research)

1. **Not truly automatic** - Claude still decides whether to spawn subagent
2. **Requires next prompt** - Context injection happens on UserPromptSubmit
3. **No direct triggering** - Hooks can't programmatically call Task tool
4. **State file management** - Need to handle cleanup and race conditions

## Alternatives Considered

### Blocking Pattern (Rejected)
```bash
# SubagentStop hook
cat <<EOF
{
  "decision": "block",
  "reason": "Review required: spawn code-review-expert"
}
EOF
```
**Why rejected:** Interrupts workflow, requires user acknowledgment

### Direct Task Tool Call (Not Possible)
Hooks cannot programmatically invoke Task tool per GitHub Issue #4182

### MCP Tool Integration (Future)
Could potentially create MCP tool that triggers reviews, but similar limitations apply

## File Type Mapping Examples

| File Pattern | Guidance Module | Review Focus |
|--------------|----------------|--------------|
| `app/services/**/*.rb` | `rails/service-objects.md` | Dependencies, error handling |
| `app/controllers/**/*.rb` | `rails/controllers.md` | Fat controller antipatterns |
| `app/models/**/*.rb` | `rails/models.md` | ActiveRecord patterns |
| `spec/**/*_spec.rb` | `testing/rspec-patterns.md` | Test quality, coverage |
| `*.tsx` | `frontend/react-components.md` | Hooks, props, state |
| `**/api/**/*.ts` | `backend/api-design.md` | REST patterns, validation |

## Integration with Existing Hooks

Current hooks in `.claude/settings.local.json`:
- `run-spec-for-ruby-file.sh` - Run tests after edit
- `rubocop-lint-ruby-file.sh` - Lint Ruby files
- `rubocop-autocorrect-notify.sh` - Auto-fix notifications
- `eslint-autocorrect-notify.sh` - ESLint notifications

**Hook execution order:**
1. Run specs (deterministic test)
2. Run linters (deterministic style)
3. **NEW:** Detect review needed (write context)
4. **NEW:** On next prompt, suggest subagent review (non-deterministic quality)

## Success Metrics

- **Token efficiency:** Measure context size with/without this pattern
- **Quality improvement:** Track issues caught by reviews
- **Workflow impact:** Monitor how often reviews are skipped vs completed
- **False positive rate:** How often reviews suggest issues that aren't real

## Next Steps

1. Implement basic detection hook for one file type (Rails services)
2. Test suggestion injection and subagent spawning
3. Measure token usage reduction
4. Expand to additional file types
5. Refine guidance modules for focused reviews
6. Consider creating specialized review subagents per domain

## References

- Research: `/tmp/research_20251007_claude_code_hooks_subagents.md`
- GitHub Issue #4182: Subagents can't spawn subagents
- GitHub Issue #5812: Parent-subagent context bridging
- Guidance Library: `~/.claude/guidance/README.md`
- Hook Documentation: https://docs.claude.com/en/docs/claude-code/hooks.md
