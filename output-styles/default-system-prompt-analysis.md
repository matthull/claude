# Claude Code Default System Prompt Analysis

## Overview
This document provides a comprehensive breakdown of Claude Code's default system prompt, annotated with XML tags to explain each section's purpose, importance, and optimization opportunities.

## System Prompt Structure

### 1. Core Identity Declaration
```
You are Claude Code, Anthropic's official CLI for Claude.
```
<capability>Establishes primary identity and authority</capability>
<importance>CRITICAL - Core identity anchoring</importance>
<optimization-opportunity>Minimal tokens, essential to keep</optimization-opportunity>

### 2. Tool Function Definitions
```
You have access to a set of tools you can use to answer the user's question.
[Extensive function definitions for Bash, Glob, Grep, Read, Edit, MultiEdit, Write, etc.]
```
<capability>Defines all available tool interfaces with parameters and usage notes</capability>
<importance>CRITICAL - Required for tool invocation</importance>
<optimization-opportunity>HIGH - Could be dynamically loaded based on task context</optimization-opportunity>
<token-count>~8000-10000 tokens for full tool definitions</token-count>

### 3. Git Commit Workflow Instructions
```
# Committing changes with git
When the user asks you to create a new git commit, follow these steps carefully:
[Detailed commit workflow including parallel commands, message formatting, etc.]
```
<capability>Provides specific git workflow patterns and best practices</capability>
<safety>Prevents accidental commits and maintains repository hygiene</safety>
<importance>IMPORTANT - But only when git operations are needed</importance>
<optimization-opportunity>Could be loaded conditionally when git operations detected</optimization-opportunity>
<token-count>~500-700 tokens</token-count>

### 4. Pull Request Creation Protocol
```
# Creating pull requests
Use the gh command via the Bash tool for ALL GitHub-related tasks...
[Detailed PR creation workflow]
```
<capability>GitHub integration patterns and PR best practices</capability>
<importance>OPTIONAL - Only needed for GitHub workflows</importance>
<optimization-opportunity>Load on-demand when PR creation requested</optimization-opportunity>
<token-count>~400-500 tokens</token-count>

### 5. File Operation Guidelines
```
Notes:
- NEVER create files unless they're absolutely necessary
- ALWAYS prefer editing existing files
- NEVER proactively create documentation files
```
<behavior>Constrains file system operations to prevent clutter</behavior>
<safety>Prevents unwanted file creation and maintains project cleanliness</safety>
<importance>IMPORTANT - Shapes interaction patterns</importance>
<optimization-opportunity>Could be condensed to key principles</optimization-opportunity>

### 6. Environment Context
```
<env>
Working directory: /home/matt/.claude
Platform: linux
OS Version: Linux 6.14.4-zen1-2-zen
Today's date: 2025-09-17
</env>
```
<capability>Provides system context for platform-specific operations</capability>
<importance>CRITICAL - Required for correct tool usage</importance>
<optimization-opportunity>Already minimal, essential information</optimization-opportunity>

### 7. Model Identity & Capabilities
```
You are powered by the model named Opus 4.1. The exact model ID is claude-opus-4-1-20250805.
Assistant knowledge cutoff is January 2025.
```
<capability>Self-awareness of model version and knowledge boundaries</capability>
<importance>IMPORTANT - Helps with expectation setting</importance>
<optimization-opportunity>Minimal tokens, worth keeping</optimization-opportunity>

### 8. Git Repository Status
```
gitStatus: This is the git status at the start of the conversation...
Current branch: main
Status: [file status list]
Recent commits: [commit history]
```
<capability>Provides current repository context</capability>
<importance>IMPORTANT - When working with version controlled projects</importance>
<optimization-opportunity>Could be fetched dynamically when needed</optimization-opportunity>
<token-count>Variable, typically 200-500 tokens</token-count>

### 9. Tool Usage Instructions
```
Answer the user's request using the relevant tool(s), if they are available...
Check that all required parameters are provided...
DO NOT make up values for optional parameters...
```
<behavior>Guides tool selection and parameter handling</behavior>
<safety>Prevents hallucination of parameter values</safety>
<importance>CRITICAL - Core operational guidance</importance>
<optimization-opportunity>Could be condensed while maintaining key constraints</optimization-opportunity>

## Token Distribution Analysis

### Essential Components (~500 tokens)
- Core identity
- Basic tool usage rules
- Environment context
- Safety constraints

### Tool Definitions (~8000-10000 tokens)
- Function schemas
- Parameter definitions
- Usage examples
- Edge case handling

### Workflow Instructions (~1500 tokens)
- Git workflows
- PR creation
- File operation patterns

### Context Information (~500-1000 tokens)
- Git status
- Recent commits
- Working directory state

## Optimization Strategies

### 1. Dynamic Tool Loading
**Opportunity**: Load only tools relevant to current task
**Savings**: 60-80% of tool definition tokens
**Implementation**: Analyze user request, load matching tool schemas

### 2. Conditional Workflow Instructions
**Opportunity**: Include git/PR workflows only when needed
**Savings**: ~1000-1500 tokens
**Implementation**: Detect version control operations in request

### 3. Compressed Behavioral Rules
**Opportunity**: Condense file operation guidelines
**Savings**: ~100-200 tokens
**Implementation**: Use concise imperative statements

### 4. On-Demand Context
**Opportunity**: Fetch git status only when relevant
**Savings**: ~200-500 tokens
**Implementation**: Lazy-load based on project type

## Custom Output Style Template

```markdown
# Custom Output Style: [Name]

## Core Identity (CRITICAL - Keep)
You are Claude Code, an AI assistant for software development.

## Primary Behaviors (CRITICAL - Customize)
- [Key behavioral constraint 1]
- [Key behavioral constraint 2]
- [Key behavioral constraint 3]

## Tool Access (CRITICAL - Selective Loading)
[Load only necessary tool definitions based on context]

## Workflow Patterns (OPTIONAL - Task-specific)
[Include only when relevant to user's request]

## Context Awareness (IMPORTANT - Minimal)
- Working directory: {path}
- Platform: {os}
- Date: {date}

## Safety Constraints (CRITICAL - Preserve)
- Never create unnecessary files
- Verify parameters before tool use
- No hallucination of values
```

## Key Insights

### What We Must Preserve
1. **Tool invocation capability** - Without function definitions, no tools work
2. **Safety constraints** - Prevent destructive operations
3. **Environment awareness** - Platform-specific operations
4. **Core identity** - Maintains consistent behavior

### What We Can Optimize
1. **Unused tool definitions** - Major token savings
2. **Workflow instructions** - Load conditionally
3. **Git status** - Fetch when needed
4. **Verbose explanations** - Condense to principles

### What We Can Customize
1. **Behavioral patterns** - Adjust interaction style
2. **Output formatting** - Change response structure
3. **Workflow emphasis** - Prioritize different methodologies
4. **Communication tone** - Formal vs casual

## Token Budget Recommendations

### Minimal Configuration (~2000 tokens)
- Core identity
- Essential tools only
- Basic safety rules
- Minimal context

### Standard Configuration (~5000 tokens)
- Core identity
- Common tools (Read, Write, Edit, Bash)
- Safety rules
- Git workflow basics
- Environment context

### Full Configuration (~12000 tokens)
- Everything in default prompt
- All tools available
- Complete workflows
- Full context

## Implementation Notes

When creating custom output styles:

1. **Start with minimal core** - Add only what's essential
2. **Layer in capabilities** - Build up based on task needs
3. **Test tool availability** - Verify needed tools are included
4. **Maintain safety** - Never remove critical safety constraints
5. **Profile token usage** - Monitor actual consumption vs. savings

## Conclusion

The default Claude Code system prompt is highly optimized for general-purpose development but carries significant overhead for specialized tasks. By understanding each component's purpose and importance, we can create lean, task-specific configurations that preserve essential capabilities while dramatically reducing token consumption.

**Potential Token Savings**: 60-80% for specialized tasks
**Risk Level**: Low if core components preserved
**Implementation Complexity**: Medium (requires context analysis)