---
type: guidance
status: current
category: documentation
---

# Project Management

## Overview
Projects are tightly-scoped units of work with clear goals, requirements, and deliverables. A "project" represents days to 1-2 weeks of effort. Larger initiatives should be decomposed into multiple projects.

## What Constitutes a Project

### Project Characteristics
- **Clear goal**: Specific outcome or deliverable
- **Bounded scope**: Days to 1-2 weeks maximum
- **Coherent work**: Related features or improvements
- **Measurable completion**: Clear definition of "done"

### When to Create Projects
- New feature development requiring multiple tasks
- System refactoring or migration efforts
- Integration with external services
- Performance optimization initiatives
- Complex changes requiring planning and coordination

### When NOT to Create Projects
- Single bug fixes (use working-docs/bugs/)
- Trivial changes (direct implementation)
- Exploratory work (use working-docs/investigations/)
- Multi-week initiatives (decompose into smaller projects)
- Routine maintenance (use working-docs/maintenance/)

## Working Docs Structure

### Top-Level Organization
```
working-docs/
├── projects/           # Project-based work
│   └── {project}/
├── bugs/              # Standalone bug fixes
├── investigations/    # Research and exploration
└── maintenance/       # Routine updates
```

### Project Structure
```
working-docs/projects/{project}/
├── project-plan.md          # Coordination and status
├── requirements.md          # What we're building
├── parking-lot.md           # Deferred items and ideas
├── requirements/            # Decomposed requirement details
│   ├── feature-1.md
│   └── feature-2.md
├── specifications/          # Technical specifications
├── {task-name}/            # Task-specific work
│   ├── task.md
│   ├── implementation-plan.md
│   ├── session-logs/
│   └── handoff.md
└── archive/                # Completed tasks
```

## Core Documents

### Always Loaded for Project Work
- `project-plan.md` - Coordination, status, task history
- `requirements.md` - What we're building, acceptance criteria

### Loaded as Needed
- `parking-lot.md` - Deferred items (separate to save context)
- `requirements/*.md` - Detailed requirements (manually loaded)
- Task documents - For specific task execution

## Document Relationships

### Hierarchy
```
Project Level (Core Context)
├── project-plan.md ←→ requirements.md (peers, always together)
│
Supporting Documents
├── parking-lot.md (reviewed periodically)
├── requirements/*.md (loaded when implementing)
│
Task Level (Task-Specific Context)
├── task.md → references project docs
├── implementation-plan.md → implements requirements
└── session-logs → capture work progress
```

### Information Flow
- **Requirements** define what tasks implement
- **Tasks** update project plan with outcomes
- **Session logs** extract insights and decisions to permanent docs
- **Parking lot** accumulates from all sources
- **Key decisions** captured in session logs, extracted to project plan

## Project Lifecycle

### 1. Initiation (`/project init {name}`)
- Creates project directory in working-docs/projects/
- Initializes project-plan.md with template
- Creates requirements.md structure
- Sets up parking-lot.md for deferred items

### 2. Planning
- Define project goals and overview
- Document requirements and user stories
- Decompose requirements if >200 lines
- Identify constraints and dependencies

### 3. Execution (`/project resume {name}`)
- Load project context into conversation
- Create tasks within project
- Update project plan with task outcomes
- Accumulate parking lot items
- Capture decisions in session logs

### 4. Natural Completion
- Projects naturally become inactive
- No formal completion process needed
- Can always resume if needed later
- Archive manually if desired

## Requirements Decomposition

### When to Decompose
- Requirements exceed ~200 lines
- Multiple distinct feature areas
- Different stakeholder groups
- Varying implementation timelines

### Decomposition Strategy
```markdown
# requirements.md (master)
## Feature Area 1
Summary here. See requirements/feature-1.md for details.

## Feature Area 2  
Summary here. See requirements/feature-2.md for details.
```

### Loading Strategy
- Master requirements.md always loaded
- Detail files loaded only when implementing specific features
- NOT using @-references (prevents automatic loading)
- Subagents receive only relevant sections

## Context Management

### Main Conversation Context
Always load for project work:
- project-plan.md
- requirements.md (master only)
- current task.md (if applicable)

### Load as Needed
- parking-lot.md (periodic review)
- requirements/*.md (specific features)
- architecture-decisions/*.md (when relevant)
- specifications/*.md (detailed implementation)

### Subagent Context
- Send only relevant requirement sections
- Include specific acceptance criteria
- Reference architecture decisions as needed
- Minimize context for focused work

## Project vs Other Work Types

### Projects (days to 1-2 weeks)
- Feature development
- System migrations
- Major refactoring
- Integration work

### Bugs (hours to 1-2 days)
- Single issue fixes
- Isolated problems
- No planning needed
- Direct to working-docs/bugs/

### Investigations (variable)
- Research spikes
- Feasibility studies
- Performance analysis
- To working-docs/investigations/

### Maintenance (ongoing)
- Dependency updates
- Routine cleanups
- Documentation updates
- To working-docs/maintenance/

## Benefits
- **Clear boundaries** - Projects complete in 1-2 weeks max
- **Flexible organization** - Not everything needs a project
- **Efficient context** - Only load what's needed
- **Traceable decisions** - Everything documented
- **Smooth handoffs** - Complete context preserved