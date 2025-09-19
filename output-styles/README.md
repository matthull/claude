# Output Styles for Claude Code

## Overview

Output styles allow you to customize Claude Code's behavior and communication patterns by replacing or modifying the default system prompt. This can achieve 30-80% token reduction while maintaining essential capabilities.

## Directory Structure

```
output-styles/
├── analysis/
│   └── default-style-breakdown.md    # Complete analysis of default style
├── templates/
│   ├── minimal.md                    # ~2k tokens - bare essentials
│   ├── ultrathink.md                  # ~3k tokens - maximum efficiency
│   ├── focused.md                     # ~5k tokens - task-optimized
│   └── standard.md                    # ~8k tokens - balanced approach
└── README.md                          # This file
```

## Available Styles

### Minimal (~2,000 tokens)
- **Use Case**: Simple queries, calculations, quick answers
- **Includes**: Core identity, security, basic tools
- **Excludes**: Examples, workflows, extensive instructions
- **Token Savings**: 83% reduction

### UltraThink (~3,000 tokens)
- **Use Case**: Rapid development, refactoring, experienced users
- **Includes**: Foundation bundle, emoji status, agent delegation
- **Excludes**: Explanations, verbose instructions, examples
- **Token Savings**: 75% reduction
- **Special**: Single-line responses, emoji-only status

### Focused (~5,000 tokens)
- **Use Case**: Specific development tasks, feature implementation
- **Includes**: Relevant tools, professional standards, agent delegation
- **Excludes**: Unnecessary tools, examples, verbose explanations
- **Token Savings**: 58% reduction

### Standard (~8,000 tokens)
- **Use Case**: General development, complex projects
- **Includes**: Common tools, workflows, full professional standards
- **Excludes**: Rarely-used tools, excessive examples
- **Token Savings**: 33% reduction

## How to Use

### Switching Styles

```bash
# Using the built-in command
/output-style minimal
/output-style ultrathink
/output-style focused
/output-style standard

# Or use the menu
/output-style
# Then select from list
```

### Creating Custom Styles

```bash
# Interactive creation
/output-style:new my-custom-style

# Or manually create in this directory
~/.claude/output-styles/my-style.md
```

### Style File Format

```markdown
---
name: style-name
description: Brief description of the style
---

# Style Name

[System prompt content goes here]
```

## Token Optimization Strategies

### 1. Dynamic Tool Loading
Instead of loading all 10,000 tokens of tool definitions:
- Load only required tools for the task
- Add tools as needed during the session

### 2. Conditional Workflows
Load workflows only when needed:
- Git workflows: Load when in git repo
- PR workflows: Load when creating PRs
- Test workflows: Load when writing tests

### 3. Foundation Bundle Integration
Reference modular guidance:
```markdown
@~/.claude/guidance/bundles/foundation/software-dev.md
```

### 4. Communication Reduction
From 500 tokens to 50:
- "Be concise" instead of multiple examples
- Emoji status instead of verbose confirmations
- Single-line responses for simple queries

## Best Practices

### When to Use Each Style

| Task Type | Recommended Style | Why |
|-----------|------------------|-----|
| Quick calculations | Minimal | No need for complex tools |
| Code search | Focused | Needs search tools + agents |
| Refactoring | UltraThink | Rapid changes, minimal chat |
| Feature development | Standard | Full toolkit needed |
| Learning/Tutorial | Default | Examples and explanations valuable |

### Switching During Sessions

You can switch styles mid-conversation:
1. Start with `standard` for planning
2. Switch to `ultrathink` for implementation
3. Back to `standard` for review

### Preserving Capabilities

All custom styles MUST preserve:
1. **Security boundaries** - Never remove safety constraints
2. **Core identity** - Always identify as Claude Code
3. **Tool syntax** - Maintain function call format
4. **Git safety** - Never auto-commit

## Measuring Impact

### Token Usage Comparison

| Style | Tool Tokens | Instruction Tokens | Total | Savings |
|-------|------------|-------------------|--------|---------|
| Default | 10,000 | 2,000 | 12,000 | - |
| Standard | 5,000 | 3,000 | 8,000 | 33% |
| Focused | 3,000 | 2,000 | 5,000 | 58% |
| UltraThink | 2,000 | 1,000 | 3,000 | 75% |
| Minimal | 1,000 | 1,000 | 2,000 | 83% |

### Performance Metrics

Track these metrics when testing styles:
- Response generation time
- Context usage per conversation
- Task completion accuracy
- Error recovery success
- User satisfaction

## Advanced Techniques

### Context-Aware Auto-Switching

Future enhancement to automatically select style based on:
- Task complexity
- Available context window
- User expertise level
- Project type

### Style Inheritance

Create style hierarchies:
```
minimal.md
  └── focused.md
      └── standard.md
          └── verbose.md
```

### Bundle Integration

Link styles to guidance bundles:
- `software-dev` style → `foundation/software-dev.md`
- `personal-assistant` style → `foundation/personal-assistant.md`
- `therapeutic` style → `foundation/therapeutic.md`

## Troubleshooting

### If Claude seems to lose capabilities:
1. Switch back to default: `/output-style default`
2. Check if security boundaries are preserved
3. Verify tool invocation syntax is intact
4. Ensure core identity is maintained

### If token usage isn't reduced:
1. Check which tools are being loaded
2. Verify workflows aren't duplicated
3. Ensure examples are removed
4. Confirm communication rules are condensed

## Contributing

To contribute new styles:
1. Create in `templates/` directory
2. Follow the standard format
3. Test with common tasks
4. Document use cases and savings
5. Submit with metrics

## References

- [Claude Code Output Styles Docs](https://docs.claude.com/en/docs/claude-code/output-styles)
- `analysis/default-style-breakdown.md` - Complete default analysis
- Captain Crouton's optimization techniques