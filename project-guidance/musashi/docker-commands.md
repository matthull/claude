---
type: guidance
status: current
category: docker
---

# Docker Commands

## Overview
Docker-specific commands and workflow for the Musashi project.

## Project Name Management
The project uses `COMPOSE_PROJECT_NAME` environment variable (set in `.env`) to manage multiple environments:
- **Main repo**: `COMPOSE_PROJECT_NAME=musashi`
- **Worktrees**: `COMPOSE_PROJECT_NAME=musashi-wt-NNN` (automatically set by wtp setup script)

This allows `docker compose` commands to work without the `-p` flag.

## Recommended Alias
```bash
alias deb="docker compose exec web bundle exec "
```

## Container Execution Requirements
- **Always run lint from inside the Docker container:** `docker compose exec web yarn eslint`
- **Always run yarn tests from inside the Docker container**
- All Ruby and JavaScript commands must be executed within the Docker container using `docker compose exec web`

## Common Commands
- Run RSpec: `docker compose exec web bundle exec rspec`
- Run single test: `docker compose exec web bundle exec rspec path/to/spec.rb:LINE_NUMBER`
- Run JS tests: `docker compose exec web yarn test`
- TDD workflow: `docker compose exec web bundle exec guard`
- Rails console: `docker compose exec web bundle exec rails console`