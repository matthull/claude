---
type: guidance
status: current
category: ai-development
tags:
- ai-development
focus_levels:
- design
- implementation
---

# Command Task Isolation

## Decision Matrix

### Use Direct Tools When
- Fast response needed (<2 sec)
- Simple operations (search, read, write)
- Minimal context (<100 lines)
- Predictable output
- No complex analysis

### Use Task Tool When
- Complex analysis needed
- Heavy guidance required (>200 lines)
- Multiple file operations
- Context preservation critical
- Parallel work desired

## Performance
- Simple Task: 1-2 sec overhead
- Complex Task with @refs: 10-20+ sec
- Direct tools: <1 sec
- Parallel direct: Same as single

## Subagent Template Pattern
```
You are a [role] following:
@~/.claude/guidance/[relevant-module].md

Task: [Specific task]

Context:
- User request: [USER PROVIDED CONTENT]
- Parameters: [DYNAMIC VALUES]

Actions:
1. [Step from guidance]
2. [Command-specific action]
3. [Output formatting]

Report: [Expected output format]
```

## Template Rules
- Reference guidance via @-syntax
- Include placeholder patterns
- Define output format
- Keep command file <20 lines
- Template contains full instructions

## Placement
**In guidance modules**: Reusable patterns, conventions, rules
**In template**: Command mechanics, parameters, output format
**Never**: Duplicate guidance in templates

## Example Optimization
Before: `/guidance search` → 30+ sec via Task
After: Direct Grep → <2 sec
Tradeoff: 50 lines context for 28 sec saved

## DON'T
- Hardcode guidance in templates
- Omit role definition
- Use vague instructions
- Load guidance in command files
- Perform work without isolation

## DO
- Use @-references
- Define clear placeholders
- Keep commands minimal
- Document template purpose
- Choose tool by complexity