---
type: guidance
status: current
category: development-process
---

# Spec-Driven Development

## Overview
Structured approach for complex features using formal specifications before implementation. Ensures alignment and completeness through documented requirements.

## Core Process

### Phase 1: Requirements Gathering
- **User stories** - What users need to accomplish
- **Success criteria** - How to measure completion
- **Constraints** - Technical and business limitations
- **Dependencies** - External systems and prerequisites
- **Non-functional** - Performance, security, scalability

### Phase 2: Specification Creation
- **Overview** - Brief feature description
- **Scope** - What's included and excluded
- **Technical design** - Architecture and approach
- **Data model** - Entities and relationships
- **API contracts** - Endpoints and payloads
- **User flows** - Step-by-step interactions

### Phase 3: Task Decomposition
- **Epic breakdown** - Major feature components
- **Task ordering** - Dependencies and sequence
- **Acceptance criteria** - Definition of done
- **Effort estimates** - Time and complexity
- **Risk identification** - Potential blockers

### Phase 4: Review and Approval
- **Stakeholder review** - Confirm requirements
- **Technical review** - Validate approach
- **Approval checkpoint** - Explicit go-ahead
- **Change management** - How to handle updates

## When to Use Specs

### Required For
- New feature development
- Major refactoring efforts
- API design and changes
- Database schema updates
- Integration projects
- Breaking changes

### Optional For
- Bug fixes
- Minor enhancements
- Documentation updates
- Configuration changes
- Performance tuning

## Spec Document Structure

### Minimal Spec Template
```
# Feature Name

## Problem Statement
What problem does this solve?

## Proposed Solution
High-level approach

## Requirements
- Functional requirements
- Non-functional requirements

## Technical Design
Key architectural decisions

## Task List
Ordered implementation steps

## Acceptance Criteria
How we know it's complete
```

### Comprehensive Spec Template
Minimal template plus:
- User research findings
- Alternative approaches considered
- Migration strategy
- Rollback plan
- Monitoring and metrics
- Documentation plan

## Task Generation from Specs

### Task Attributes
- **Title** - Clear, actionable description
- **Scope** - What's included
- **Dependencies** - Prerequisite tasks
- **Acceptance** - Success criteria
- **Priority** - Ordering importance

### Task Ordering Principles
1. Foundation before features
2. Data model before logic
3. Backend before frontend
4. Core path before edge cases
5. Testing alongside implementation

## Review Checkpoints

### Before Implementation
- Requirements understood?
- Approach validated?
- Risks identified?
- Dependencies available?
- Approval received?

### During Implementation
- Following spec?
- New requirements emerged?
- Blocked by dependencies?
- Need spec updates?

### After Implementation
- Acceptance criteria met?
- Edge cases handled?
- Documentation complete?
- Deployment ready?

## Anti-patterns
- Starting code before spec approval
- Vague or missing acceptance criteria
- Skipping stakeholder review
- Over-engineering specifications
- Rigid adherence when learning emerges
- Specs for trivial changes
- Analysis paralysis

## Benefits
- Shared understanding before coding
- Reduced rework and surprises
- Clear scope and boundaries
- Better effort estimation
- Traceable requirements