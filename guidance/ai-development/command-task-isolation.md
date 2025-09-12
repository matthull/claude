---
type: guidance
status: current
category: ai-development
---

# Command Task Isolation Pattern

## Overview
A pattern for deciding when to delegate work to Task tool agents versus using direct tools, balancing performance with context efficiency.

## The Problem
Commands face a tradeoff: Task tool delegation prevents context pollution but adds overhead (1-20+ seconds depending on prompt complexity), while direct tool calls are fast but consume main context.

## Core Pattern: Subagent Prompt Templates

The heart of this pattern is the **Subagent Prompt Template** - a carefully crafted prompt that gets passed to the Task tool's `prompt` parameter. This template:

- **Contains the complete instructions** for the specialized agent
- **References external guidance** via @-syntax to load relevant modules
- **Includes placeholder patterns** like `[USER PROVIDED CONTENT]` for dynamic content
- **Defines expected output format** and step-by-step instructions
- **Lives in the command file** for documentation but executes in isolation

### Template Structure
```
You are a [specialized role] following these principles:
@~/.claude/guidance/category/relevant-guidance.md
@~/.claude/guidance/category/another-module.md

Task: [Specific task description]

Context:
- [Minimal execution context]
- User request: [USER PROVIDED CONTENT]

Actions Required:
1. [Reference guidance for main logic]
2. [Command-specific mechanics only]
3. [Output formatting]

Expected Output:
[What to report back]
```

### Key Principle: Guidance vs Mechanics
- **Put in guidance**: Reusable patterns, file locations, naming conventions, validation rules
- **Put in template**: Command-specific actions, parameter handling, output format
- **Reference, don't duplicate**: Use @-syntax to load comprehensive guidance

## Pattern Structure

### Minimal Command File (10-20 lines)
```
# Brief Command Purpose
One-line description of what this command accomplishes.

## Usage
/command-name [parameters]

## Implementation
Delegates to Task tool using the template below for isolated execution.

## Subagent Prompt Template
[FULL TEMPLATE CONTENT - This is what gets passed to Task tool]
```

### Template Benefits
- **Visible Documentation**: Template shows exactly what the agent will do
- **Reusable Components**: Can be copied and modified for similar commands
- **Clear Interface**: Separates command invocation from agent implementation
- **Context Isolation**: Heavy guidance loads only in agent context
- **Parameter Passing**: Supports dynamic content via placeholder patterns

## When to Use Task Tool vs Direct Tools

### Use Direct Tools When
- **Fast response needed** (< 2 seconds expected)
- **Simple operations** (search, read, write single files)
- **Minimal context added** (< 100 lines total)
- **Output is predictable** (file lists, search results)
- **No complex analysis** required

Examples: `/guidance search`, `/guidance list`, simple file operations

### Use Task Tool When
- **Complex analysis needed** (multi-step reasoning)
- **Heavy guidance required** (> 200 lines of instructions)
- **Multiple file operations** (reading many files to decide)
- **Context preservation critical** (long-running operations)
- **Parallel work desired** (background processing)

Examples: Complex refactoring, architecture analysis, multi-file migrations

### Performance Characteristics
- **Simple Task prompt**: 1-2 seconds overhead
- **Complex prompt with @references**: 10-20+ seconds overhead
- **Direct tool calls**: < 1 second typically
- **Parallel direct tools**: Same as single (true parallelism)

## Template Design Patterns

### Dynamic Content Integration
```
User Input: [USER PROVIDED CONTENT]
Current Context: [DYNAMIC_CONTEXT]
Configuration: [CONFIG_VALUES]
```

### Multi-Step Workflows
```
Process:
1. Validate input using @guidance/validation.md
2. Execute core logic following @guidance/execution.md
3. Format output per @guidance/formatting.md
4. Report results
```

### Error Handling Templates
```
Safety Checks:
- Validate all inputs before processing
- Check permissions and constraints
- Handle edge cases gracefully
- Report errors with context
```

## Practical Example: /guidance Command Evolution

### Original (Task Tool for everything)
- `/guidance search "testing"` → 30+ seconds
- Delegated simple grep operations to Task
- Unnecessary overhead for predictable output

### Optimized (Direct tools for simple ops)
- `/guidance search "testing"` → < 2 seconds  
- Direct parallel Grep calls
- Task tool only for complex `/guidance add` operations

### The Tradeoff
- **Context cost**: Search results add ~50 lines to context
- **Time saved**: 28+ seconds per search
- **Decision**: Fast response worth minor context usage

## Benefits

### When Using Task Tool
- Main context stays clean for heavy operations
- Complex multi-step workflows isolated
- Parallel background processing possible

### When Using Direct Tools
- Instant response for simple operations
- True parallelism with multiple tool calls
- Predictable context usage

### Hybrid Approach
- Choose based on operation complexity
- Optimize for user experience
- Balance speed vs context preservation

## Anti-patterns

### Template Anti-patterns
- Hardcoding guidance instead of @-references
- Omitting role definition in templates
- Missing parameter placeholders
- Vague or incomplete instructions

### Command Anti-patterns
- Loading full guidance directly in command files
- Performing work directly without Task tool
- Including implementation details in commands

## Implementation Guidelines

### Command Structure
- Keep under 20 lines total
- Lead with **Subagent Prompt Template** section
- Include clear usage and purpose
- Template is the primary content

### Template Quality
- Start with role definition
- Reference relevant @guidance modules  
- Include step-by-step process
- Define expected output format
- Use placeholder patterns for dynamic content