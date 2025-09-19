---
type: guidance
status: current
category: docker
---

# Docker Commands

## Overview
Docker-specific commands and workflow for the Musashi project.

## Recommended Alias
```bash
alias deb="docker exec -it musashi-web-1 bundle exec "
```

## Container Execution Requirements
- **Always run lint from inside the Docker container:** `docker exec musashi-web-1 yarn eslint`
- **Always run yarn tests from inside the Docker container**
- All Ruby and JavaScript commands must be executed within the Docker container `musashi-web-1`