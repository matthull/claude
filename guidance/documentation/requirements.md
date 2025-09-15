---
type: guidance
status: current
category: documentation
---

# Requirements Document

## Overview
Requirements define WHAT we're building through user stories, acceptance criteria, and success metrics. Always loaded alongside project-plan.md in main context. No size limit, but decompose into separate files if large.

## Context
@~/.claude/guidance/documentation/project-management.md

## Document Structure

### Required Frontmatter
```yaml
---
type: requirements
status: draft|approved|revised
project: {project-name}
version: 1.0
---
```

### Required Sections
```markdown
# Requirements: {Feature/Project Name}

## Overview
What problem we're solving and for whom (10 lines max).
Clear value proposition and target users.

## User Stories
**Story 1: {Title}**
**As a** {type of user}
**I want** {goal/desire}
**So that** {benefit/value}

**Story 2: {Title}**
**As a** {type of user}
**I want** {goal/desire}
**So that** {benefit/value}

## Acceptance Criteria
Measurable criteria for completion:
- [ ] Criterion 1 - specific, testable behavior
- [ ] Criterion 2 - edge case handled
- [ ] Criterion 3 - performance requirement
- [ ] Criterion 4 - security consideration

## Constraints
Limitations we must work within:
- Technical: {existing system constraints}
- Business: {policy or process requirements}
- Time: {deadline considerations}
- Resources: {team or infrastructure limits}

## Out of Scope
What we're explicitly NOT doing:
- Feature we're not building
- Use case not supporting
- Problem deferring to later
```

### Optional Sections
```markdown
## Dependencies
What this requires or affects:
- Depends on: {component/service}
- Affects: {downstream system}
- Must coordinate with: {team/project}

## Success Metrics
How we'll measure success:
- Metric 1: target value
- Metric 2: measurement method

## Technical Requirements
Specific technical needs:
- API compatibility
- Performance targets
- Security requirements
- Infrastructure needs

## Mockups/Designs
References to design documents:
- Figma: {link}
- Screenshots: {path}
```

## Writing Guidelines

### User Stories
- Focus on user value, not implementation
- Keep stories independent when possible
- Make them negotiable (not overly specific)
- Ensure they're valuable to users
- Keep them estimable and small
- Make them testable

### Acceptance Criteria
- Write from user perspective
- Make them binary (pass/fail)
- Include edge cases
- Cover performance needs
- Address security requirements
- Keep them measurable

### Constraints vs Out of Scope
- **Constraints**: Limitations we work within
- **Out of Scope**: Things we won't do
- Be explicit about both
- Revisit if scope changes

## Decomposition Strategy

### When to Decompose
- Document exceeds ~200 lines
- Multiple distinct feature areas
- Different implementation timelines
- Varying stakeholder groups
- Complex subsystems

### Decomposition Structure
```markdown
# requirements.md (master - always loaded)

## Feature Area 1
High-level summary of this feature area.
**Details**: See requirements/feature-1.md

## Feature Area 2
High-level summary of this feature area.
**Details**: See requirements/feature-2.md

## Core Acceptance Criteria
[Keep high-level criteria in master]
```

### Detail File Structure
```markdown
# requirements/feature-1.md (loaded as needed)

## Detailed User Stories
[Specific stories for this feature]

## Detailed Acceptance Criteria
[Comprehensive criteria]

## Implementation Notes
[Technical details for this feature]
```

### Loading Strategy
- Master requirements.md ALWAYS loaded
- Detail files loaded only when implementing
- NOT using @-references (manual loading)
- Prevents context bloat
- Subagents get only relevant sections

## Relationship to Other Documents

### Peer Document (Always Loaded Together)
- **project-plan.md** - Defines how we'll build it
- Both provide essential project context

### Referenced By
- **task.md** - Tasks implement requirements
- **implementation-plan.md** - Details how to build
- **test plans** - Validate acceptance criteria

### Updates From
- **session logs** - Discovered requirements
- **parking lot** - Deferred features
- **user feedback** - Requirement changes

## Version Management

### When to Version
- Significant scope changes
- Major feature additions
- Acceptance criteria modifications
- After stakeholder review

### Version Format
```yaml
version: 1.0  # Initial version
version: 1.1  # Minor updates
version: 2.0  # Major changes
```

### Change Tracking
```markdown
## Change History
- v1.1 (YYYY-MM-DD): Added performance criteria
- v1.0 (YYYY-MM-DD): Initial requirements
```

## Context Usage

### Main Conversation
- Always load master requirements.md
- Load alongside project-plan.md
- Reference during planning discussions

### Subagent Context
- Send only relevant sections
- Include specific acceptance criteria
- Minimize context for focused work
- Example: Send only "Feature 1" requirements to implementation agent

### Task Implementation
- Reference specific requirement sections
- Track which criteria are addressed
- Update completion checkboxes
- Note any discovered requirements

