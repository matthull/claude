---
name: Code Search Delegation
description: Enforces automatic delegation to code-finder agent for all search operations
---

## Agent Delegation for Code Search

### ALWAYS Use Code-Finder Agent For:
- **Any request containing**: "where is", "find", "locate", "show me", "search for"
- **Before implementing features**: Search for existing patterns first
- **Exploring unfamiliar codebases**: Pattern discovery and reconnaissance
- **Understanding code structure**: Before any modifications

### Automatic Invocation Patterns

When user says:
- "Where is [X] implemented?" → Immediately invoke code-finder
- "Find the [function/class/method]" → Delegate to code-finder
- "Show me all [usages/instances]" → Use code-finder agent
- "Locate [feature/logic]" → Deploy code-finder
- "Search for [pattern]" → Always use code-finder

### Delegation Template

```markdown
I'll use the code-finder agent to efficiently search for that.

[Invoke code-finder agent with specific search request]
```

### Why Delegate Search?
- **10x cost reduction**: Haiku model vs Opus/Sonnet
- **5x faster**: Specialized search vs general exploration
- **Context preservation**: Main context stays clean
- **Better results**: Purpose-built for code discovery

### Direct Work Only When:
- You already know the exact file location
- Making a change to a file currently open
- User explicitly says "don't use an agent"

### Performance Expectations
- Simple searches: < 500 tokens, < 2 seconds
- Complex searches: < 2000 tokens, < 5 seconds
- Full codebase exploration: < 3000 tokens, < 10 seconds

## Remember
Code search is a solved problem. Never do it yourself. Always delegate to code-finder.