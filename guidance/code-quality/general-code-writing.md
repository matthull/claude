---
type: guidance
status: current
category: code-quality
focus_levels:
- implementation
tags:
- code-quality
- code

# Automatic triggers
file_triggers:
  - "*.rb"
  - "*.js"
  - "*.ts"
  - "*.py"
  - "*.java"
  - "*.go"
---

# General Code Writing Guidance

## Core Principles

### Test-Driven Development
**ALWAYS use TDD when feasible** - Write tests first, then implementation.

@~/.claude/guidance/testing/test-driven-development.md

### Testing Strategy
Comprehensive approach to all testing activities.

@~/.claude/guidance/testing/test-driven-development.md

### Code Quality
Maintain high standards through review principles.

@~/.claude/guidance/code-quality/immediately-runnable-code.md

### Error Handling
Robust error management across all code.
- Validate all inputs
- Handle errors gracefully
- Provide meaningful error messages

### Security First
Always validate and authorize.

@~/.claude/guidance/security/validation-and-authorization.md

## Development Workflow

### Git Workflow
Commit verification and atomic changes.
- One complete feature per commit
- Clear commit messages
- Test before committing

### Balanced Analysis
Critical thinking in design decisions.

@~/.claude/guidance/communication/balanced-analysis.md

## When to Apply

### Always Apply
- **TDD**: Unless explicitly told not to, or when prototyping/exploring
- **Error Handling**: Every function that can fail
- **Security**: All user input and data access
- **Code Review Principles**: Before considering any code complete

### Context-Dependent
- **Testing Strategy**: Match to project complexity
- **Git Workflow**: Follow team conventions
- **Analysis Depth**: Based on decision impact

## Quick Checklist
- [ ] Tests written before implementation (TDD)
- [ ] Error cases handled appropriately
- [ ] Security validation in place
- [ ] Code follows project conventions
- [ ] Changes are atomic and testable
- [ ] Documentation updated if needed