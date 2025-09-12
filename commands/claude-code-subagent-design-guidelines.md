# Claude Code Subagent Design Guidelines

## Overview

Claude Code subagents are specialized prompts that provide focused expertise within Claude Code's tool-based ecosystem. They handle specific domains through natural language interaction while leveraging existing Claude Code tools.

## How Claude Code Subagents Work

### Core Architecture
- **Natural Language Interface**: Process conversational requests, not function calls
- **Tool-Based Implementation**: Use Claude Code's existing tools (Read, Write, Edit, Bash, etc.)
- **Stateless Operation**: Each invocation is independent; state persists only through files
- **Domain Specialization**: Provide focused expertise in specific areas

### Interaction Pattern
1. User calls subagent via Task tool with natural language request
2. Subagent processes request using its specialized knowledge
3. Subagent uses Claude Code tools to accomplish the task
4. Subagent returns results through natural language response

## Design Principles

### ✅ DO Include in Subagent Prompts

1. **Clear Expertise Description**
   ```markdown
   You are a specialized [domain] subagent responsible for [specific capabilities]
   ```

2. **Specific Responsibilities**
   ```markdown
   Your role is to:
   - Handle [specific task type]
   - Manage [specific resources]
   - Ensure [specific standards]
   ```

3. **Templates and Patterns**
   ```markdown
   ## Document Template
   ```markdown
   # Template Name
   [actual template content]
   ```
   ```

4. **Common Request Handling**
   ```markdown
   When asked to "initialize a project", I will:
   1. Check for existing structure using LS/Read tools
   2. Create directories using Bash mkdir
   3. Generate documents using Write tool
   ```

5. **Standards and Guidelines**
   ```markdown
   ## Key Principles
   - Always validate before creating
   - Use consistent naming conventions
   - Maintain referential integrity
   ```

### ❌ DON'T Include in Subagent Prompts

1. **Function Signatures**
   ```markdown
   ❌ initialize_project(name, description) -> ProjectResult
   ```

2. **API-Style Interfaces**
   ```markdown
   ❌ Available Functions:
   - create_task()
   - update_status()
   ```

3. **Return Data Structures**
   ```markdown
   ❌ Returns: { status: "success", data: {...} }
   ```

4. **Callback Mechanisms**
   ```markdown
   ❌ Call parent.notify() when complete
   ```

## Subagent Structure Template

```markdown
# [Subagent Name] Subagent

You are a specialized [domain] subagent responsible for [core responsibility].

## Your Expertise
You excel at:
- [capability 1]
- [capability 2]
- [capability 3]

## [Relevant Context/Structure You Work With]
[File structures, patterns, frameworks the subagent needs to understand]

## Templates/Patterns
[Concrete examples of documents, code, or structures the subagent creates]

## Your Responsibilities
When called, you should:
1. [step 1]
2. [step 2]
3. [step 3]

## Key Principles
- [principle 1]
- [principle 2]
- [principle 3]

## Common Request Patterns You Handle
- [pattern 1]: How you respond to this type of request
- [pattern 2]: How you respond to this type of request

## Standards and Conventions
[Specific standards the subagent should maintain]
```

## Tool Integration Patterns

### File Operations
```markdown
When creating new files:
1. Use LS to check if directory exists
2. Use Read to check for existing content
3. Use Write to create or Edit to update
4. Validate results with Read
```

### Error Handling
```markdown
If [error condition]:
- Check [precondition] using [specific tool]
- Inform user about [specific issue]
- Suggest [specific remedy]
```

### Cross-Reference Management
```markdown
When updating related documents:
1. Read current content to understand structure
2. Update references consistently
3. Verify links remain valid
```

## Best Practices

### 1. Focus on Capabilities, Not Functions
✅ "I can initialize project structures and maintain documentation"
❌ "Available functions: init_project(), update_docs()"

### 2. Use Concrete Examples
✅ Include actual templates and file structures
❌ Abstract descriptions of what might be created

### 3. Handle Request Variations
✅ "When asked to 'start a project', 'initialize project', or 'create new project'"
❌ Only handle exact phrasing

### 4. Leverage Existing Tools
✅ "Use Bash mkdir to create directories, Write to generate files"
❌ "Create directory structure" (without specifying how)

### 5. Maintain Clear Boundaries
✅ "I handle file management. For strategic decisions, consult with the user"
❌ Unclear about what the subagent does vs. doesn't do

### 6. Support Stateless Operation
✅ "Read current state from .llm/current-task before proceeding"
❌ "Remember the previous task state" (assumes memory between calls)

## Common Anti-Patterns

1. **Function Library Thinking** - Treating subagent like a programming API
2. **State Assumptions** - Assuming memory between invocations
3. **Over-Abstraction** - Too generic without specific expertise
4. **Tool Ignorance** - Not leveraging Claude Code's existing capabilities
5. **Rigid Interfaces** - Only responding to exact phrases
6. **Scope Creep** - Trying to handle everything instead of specializing

## Testing Your Subagent Design

Before finalizing a subagent prompt, ask:

1. **Clear Purpose**: Can I explain exactly what this subagent does in one sentence?
2. **Natural Requests**: Can users make natural language requests rather than function calls?
3. **Tool Integration**: Does it specify how to use Claude Code tools to accomplish tasks?
4. **Boundaries**: Is it clear what this subagent handles vs. what stays with the main conversation?
5. **Examples**: Are there concrete examples of templates, patterns, or outputs?
6. **Error Handling**: Does it describe how to handle common failure scenarios?
7. **Stateless**: Will it work properly even if called multiple times independently?

## Subagent Interaction Examples

### ✅ Good Request Patterns
```
"Initialize a new project called 'user-auth' with basic documentation structure"
"Update the task status to show we've completed the implementation phase"
"Create a handoff document for the current task with all relevant context"
```

### ✅ Good Response Patterns
```
I've successfully initialized the user-auth project:

Created directories:
- working-docs/projects/user-auth/
- .llm/ (with tracking files)

Generated documentation:
- working-docs/projects/user-auth/project-plan.md (using template)
- Updated .llm/current-project with 'user-auth'

The project is ready for task initialization.
```

### ❌ Bad Request Patterns
```
initialize_project("user-auth", "authentication system")
call.updateTaskStatus(phase="implementation", status="complete")
```

This approach ensures subagents integrate naturally with Claude Code's conversational and tool-based architecture.