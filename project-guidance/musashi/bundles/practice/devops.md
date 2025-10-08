---
type: bundle
layer: practice
parent: domain/coding.md
context: Musashi DevOps, CI/CD, and development tools
estimated_lines: 200
---
# Practice: DevOps (Musashi)

Musashi-specific DevOps patterns, CI/CD workflows, and development tools.

## Global DevOps Foundation
@~/.claude/guidance/bundles/practice/devops.md

## Musashi DevOps Architecture

### Infrastructure Patterns
DevOps and infrastructure guidelines:
@../../devops/infrastructure-patterns.md

### Development Environment
Docker and local development setup:
@../../docker-commands.md

### Browser Automation Tools
Chrome MCP for testing:
@../../chrome-mcp.md

### Key DevOps Decisions
- Docker for local development
- GitHub Actions for CI/CD
- Heroku for deployment
- PostgreSQL and Redis in production
- AppSignal for performance monitoring

### CI/CD Pipeline
- Automated testing on every PR
- Parallel test execution
- Linting and code quality checks
- Visual regression testing
- Automatic deployments to staging

### Development Workflow
- Docker containers for consistency
- Hot reloading for frontend development
- Database fixtures for testing
- Branch-based development
- PR-based code review

### Monitoring and Observability
- AppSignal for performance metrics
- Error tracking and alerting
- Database query performance monitoring
- Background job monitoring
- Application logs in production