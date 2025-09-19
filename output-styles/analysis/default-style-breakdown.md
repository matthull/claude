---
type: analysis
purpose: Claude Code default system prompt breakdown with optimization opportunities
estimated_tokens: 12000-15000 (full default)
---

# Claude Code Default Output Style - Complete Analysis

This document provides a comprehensive breakdown of Claude Code's default system prompt with XML tags identifying capabilities, safety features, behaviors, and optimization opportunities.

## Token Distribution Overview

- **Tool Definitions**: ~8,000-10,000 tokens (60-70% of total)
- **Workflow Instructions**: ~1,500 tokens (10-12%)
- **Core Identity & Safety**: ~500 tokens (3-4%)
- **Communication Style**: ~500 tokens (3-4%)
- **Environment Context**: ~500-1,000 tokens (4-7%)
- **Miscellaneous**: ~500 tokens (3-4%)

## Section 1: Tool Definitions

<capability type="tools" tokens="~8000-10000" criticality="essential-but-selective">
```
You have access to a set of tools you can use to answer the user's question.
You can invoke functions by writing a "<function_calls>" block...

[Individual tool definitions follow - Task, Bash, Read, Write, Edit, etc.]
```

<optimization-opportunity severity="high" savings="60-80%">
MAJOR OPTIMIZATION: Tools could be loaded dynamically based on task type:
- Code reading task: Only Read, Grep, Glob (~1500 tokens)
- Code writing task: Add Write, Edit, MultiEdit (~3000 tokens)
- Full development: All tools (~8000 tokens)
</optimization-opportunity>

<essential>
Must preserve: Tool invocation syntax and structure
Can optimize: Which tools are loaded for specific contexts
</essential>
</capability>

## Section 2: Core Identity

<essential type="identity" tokens="~200" criticality="absolute">
```
You are Claude Code, Anthropic's official CLI for Claude.
You are an interactive CLI tool that helps users with software engineering tasks.
```

<capability>
Establishes primary role and purpose
Sets user expectations for interactions
</capability>

<behavior>
This MUST be preserved in all custom styles to maintain identity
</behavior>
</essential>

## Section 3: Security Boundaries

<safety type="security" tokens="~300" criticality="absolute">
```
IMPORTANT: Assist with defensive security tasks only. Refuse to create, modify,
or improve code that may be used maliciously. Do not assist with credential
discovery or harvesting...
```

<essential>
NON-NEGOTIABLE: Must be preserved in ALL custom styles
Legal and ethical requirements
</essential>

<optimization-opportunity severity="none">
DO NOT OPTIMIZE - Keep verbatim for safety
</optimization-opportunity>
</safety>

## Section 4: Communication Style & Tone

<behavior type="communication" tokens="~500" criticality="important">
```
# Tone and style
You should be concise, direct, and to the point.
You MUST answer concisely with fewer than 4 lines...
IMPORTANT: You should minimize output tokens as much as possible...
```

<optimization-opportunity severity="medium" savings="300-400 tokens">
For "ultrathink" mode, could be reduced to:
- "1-4 lines max. Direct answers only. No preamble."
- Saves 80% of communication instructions
</optimization-opportunity>

<capability>
Controls verbosity and response format
Ensures efficiency in CLI context
</capability>

### Examples Section
<optional type="examples" tokens="~200">
```
<example>
user: 2 + 2
assistant: 4
</example>
```

<optimization-opportunity severity="high" savings="200 tokens">
Examples could be removed entirely for experienced users
Or loaded only in "learning" mode
</optimization-opportunity>
</optional>
</behavior>

## Section 5: Git & PR Workflows

<capability type="git-workflows" tokens="~1500" criticality="context-dependent">
```
# Committing changes with git
When the user asks you to create a new git commit...
[Detailed commit workflow]

# Creating pull requests
When the user asks you to create a pull request...
[Detailed PR workflow]
```

<optimization-opportunity severity="high" savings="1500 tokens">
Load only when:
- User mentions git operations
- Working in a git repository
- PR creation requested
</optimization-opportunity>

<behavior>
Provides standardized git workflows
Ensures consistent commit messages
</behavior>
</capability>

## Section 6: Task Management

<behavior type="task-management" tokens="~300" criticality="important">
```
# Task Management
You have access to the TodoWrite tools to help you manage and plan tasks...
```

<capability>
Enables systematic task tracking
Provides visibility into progress
</capability>

<optional>
Could be loaded only for complex multi-step tasks
Not needed for simple queries or single operations
</optional>
</behavior>

## Section 7: Professional Standards

<behavior type="professional" tokens="~400" criticality="important">
```
# Proactiveness
You are allowed to be proactive, but only when the user asks...

# Professional objectivity
Prioritize technical accuracy and truthfulness...

# Following conventions
When making changes to files, first understand the file's code conventions...
```

<essential>
Core professional behaviors that ensure quality
Should be preserved in most styles
</essential>

<optimization-opportunity severity="low" savings="100-200 tokens">
Could be condensed to bullet points
Or integrated into other sections
</optimization-opportunity>
</behavior>

## Section 8: File Operations

<behavior type="file-operations" tokens="~400" criticality="essential">
```
# Doing tasks
- Use available search tools to understand the codebase
- Implement the solution using all tools available
- Verify the solution if possible with tests
- Run lint and typecheck commands
```

<capability>
Defines standard development workflow
Ensures code quality practices
</capability>

<essential>
Core workflow that should be preserved
Can be optimized for brevity
</essential>
</behavior>

## Section 9: Tool Usage Policy

<behavior type="tool-policy" tokens="~300" criticality="important">
```
# Tool usage policy
- When doing file search, prefer to use the Task tool...
- You have the capability to call multiple tools in a single response...
- When multiple independent pieces of information are requested, batch...
```

<optimization-opportunity severity="medium" savings="150 tokens">
Could be reduced to core rules only:
- "Batch operations. Use specialized agents. Parallel when possible."
</optimization-opportunity>

<capability>
Optimizes tool usage patterns
Encourages efficient operations
</capability>
</behavior>

## Section 10: Environment Context

<capability type="environment" tokens="~500-1000" criticality="essential-dynamic">
```
<env>
Working directory: /home/matt/.claude
Platform: linux
Today's date: 2025-09-17
Git status: [current branch and changes]
</env>
```

<optimization-opportunity severity="medium" savings="500 tokens">
Git status could be loaded on-demand
Only when git operations are needed
</optimization-opportunity>

<essential>
Working directory and platform are essential
Git status is context-dependent
</essential>
</capability>

## Section 11: User Permissions

<optional type="permissions" tokens="~200" criticality="project-specific">
```
You can use the following tools without requiring user approval:
Edit(/home/matt/code/village), Bash(mkdir:*), Read(//home/matt/code/musashi/**) ...
```

<optimization-opportunity severity="low">
Project-specific, loaded from settings
Not needed in base style
</optimization-opportunity>
</optional>

## Section 12: MCP Server Instructions

<optional type="mcp-context" tokens="~100-500" criticality="context-dependent">
```
The following MCP servers have provided instructions...
```

<optimization-opportunity severity="high">
Load only when MCP servers are active
Skip entirely for non-MCP workflows
</optimization-opportunity>
</optional>

## Optimization Strategies Summary

### Minimal Style (~2,000 tokens)
```xml
<include>
- Core identity (200)
- Security boundaries (300)
- Essential tools only (1000)
- Basic file operations (200)
- Working directory (100)
- Minimal communication rules (200)
</include>
```

### Focused Style (~5,000 tokens)
```xml
<include>
- Everything from Minimal
- Relevant tools for task type (3000)
- Professional standards (400)
- Tool usage policy (300)
- Basic git workflows (300)
</include>
```

### Standard Style (~8,000 tokens)
```xml
<include>
- Everything from Focused
- Most common tools (5000)
- Full communication style (500)
- Task management (300)
- Environment context (500)
</include>
```

### Full Style (~12,000+ tokens)
```xml
<include>
- Complete tool set (10000)
- All workflows (1500)
- All examples (200)
- Full environment (1000)
- MCP instructions (variable)
</include>
```

## Critical Preservation Requirements

### MUST PRESERVE IN ALL STYLES:
1. Core identity declaration
2. Security boundaries (verbatim)
3. Tool invocation syntax
4. Working directory context
5. Basic file operation safety

### CAN OPTIMIZE:
1. Which tools are loaded
2. Example verbosity
3. Workflow instructions (load on-demand)
4. Communication style (can be terse)
5. Git status (fetch when needed)

### NEVER REMOVE:
1. Security constraints
2. User approval requirements for destructive operations
3. Core identity as Claude Code
4. Basic tool structure

## Implementation Notes

1. **Dynamic Loading**: Implement tool loading based on task detection
2. **Style Switching**: Allow mid-session style changes via `/output-style`
3. **Context Awareness**: Auto-select optimal style based on task type
4. **Fallback**: Always have full style available as fallback
5. **Testing**: Validate each optimization level maintains core capabilities

## Token Savings Potential

| Component | Default | Minimal | Focused | Standard | Savings |
|-----------|---------|---------|---------|----------|---------|
| Tools | 10,000 | 1,000 | 3,000 | 5,000 | 50-90% |
| Workflows | 1,500 | 0 | 300 | 1,000 | 33-100% |
| Communication | 500 | 200 | 300 | 500 | 0-60% |
| Examples | 200 | 0 | 0 | 100 | 50-100% |
| **Total** | **~12,000** | **~2,000** | **~5,000** | **~8,000** | **33-83%** |

## Conclusion

The default Claude Code system prompt is optimized for general-purpose development but carries significant overhead for specialized tasks. By implementing selective loading and task-aware optimization, we can achieve 60-80% token reduction while preserving all essential capabilities.

Key insight: Most tokens are consumed by unused tool definitions and workflows that aren't relevant to the current task. Dynamic, context-aware loading is the path to massive efficiency gains.