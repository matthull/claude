# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
Use this to provide summaries of our best practices and critical info like how to run commands in Docker.
Avoid putting guidance related to specialized tasks or scenarios here, to save context create subagents or slash commands instead.
Also when updating this file, consider whether your addition is _really_ universally applicable, and consider slash commands or subagents
as an alternative so we can control Claude Code behavior in a more modular way.

For detailed specifications and architectural decisions, see the `specification-docs-for-claude/` directory.

## Guidelines for Claude Code
- **Never**: Absolute prohibition - Claude must avoid completely
- **Always**: Must consistently follow - get user permission if making an exception
- **Avoid**: Generally discouraged - get user permission if making an exception

## Project-Specific Guidance

### Docker Workflow
@.claude/guidance/docker-commands.md

### Code Style and Conventions
- Ruby: 2 space indent, single quotes, 150 char line length, leading dot style
- JS/TS: Single quotes, no semicolons, 100 char line width, trailing commas
- TypeScript path aliases: import from '@components/_', '@lib/_', etc. (see tsconfig.json)
- Ruby naming: snake_case for variables/methods, CamelCase for classes
- JS naming: camelCase for variables/methods, PascalCase for components
- Vue component names must be multi-word
- Error handling: use standard Rails patterns for Ruby, try/catch for JS
- Verify directory paths exist before file operations

### Linting Requirements
- Follow all project linting rules and code style guidelines
- Run linters before considering tasks complete: `rubocop` for Ruby and `yarn eslint` for JS/TS
- Apply style conventions consistently across all new and modified code

## Build/Test/Lint Commands

- Run RSpec: `docker compose exec web bundle exec rspec`
- Run single test: `docker compose exec web bundle exec rspec path/to/spec.rb:LINE_NUMBER`
- Run JS tests: `docker compose exec web yarn test` or single: `docker compose exec web npx vitest app/javascript/src/lib/file_name.test.ts`
- Run Vitest (pure logic tests): `docker compose exec web npx vitest run path/to/test.ts --environment=node --no-browser`
  - **Note:** Browser-dependent tests requiring DOM/Playwright won't work without further setup. Use `--environment=node --no-browser` for pure logic tests.
- TDD workflow: `docker compose exec web bundle exec guard`
- Lint Ruby: `rubocop` (use `-a` for auto-fix, `-A` for aggressive fixes)
- Lint JS: `docker compose exec web yarn eslint`
- **See Docker workflow guidance: @.claude/guidance/docker-commands.md**

### Vitest Testing Strategy

**Test Categories:**

1. **Pure Logic Tests** (`lib/` directory utilities):
   - Run in Node.js environment for speed (no browser overhead)
   - No DOM or browser APIs required
   - Test data transformations, validators, formatters, utilities
   - Examples: `lib/validation/`, `lib/formatters.test.js`, `lib/assetUtils/*.test.ts`, `lib/classifierUtils/*.test.ts`

2. **Browser-Dependent Tests** (components, stores, some lib utilities):
   - Require browser APIs: `window`, `document`, `localStorage`, etc.
   - Use default vitest.config.ts settings (Playwright/happy-dom)
   - Examples: `lib/tracking.test.ts`, `lib/SvgTestimonial.test.ts`, `lib/contentUtils.test.ts`

**Running Tests:**

```bash
# All tests (default - uses browser mode, requires Playwright)
docker compose exec web yarn test

# Pure logic tests only (fast - no browser, ~1.8s for 36 test files)
docker compose exec web yarn test:lib

# Pure logic tests in watch mode (TDD workflow)
docker compose exec web yarn test:lib:watch

# Specific pure logic test file
docker compose exec web npx vitest run path/to/test.ts --environment=node --no-browser

# Single test pattern
docker compose exec web npx vitest run app/javascript/src/lib/validation/ --environment=node --no-browser
```

**Writing New Tests for lib/ Utilities:**

When creating tests for utilities in `lib/` (especially Phase 2 chartUtils):
- Write pure functions that don't depend on browser APIs
- Mock Vue if needed (see `lib/validation/validator.test.ts` for pattern)
- Run with node environment for faster feedback
- Use `--environment=node --no-browser` flags for execution

**Performance Comparison:**
- Browser mode (default): Requires Playwright setup, slower execution
- Node environment mode: ~1.8s for 36 test files (327 tests), 60-70% faster

**Note**: Docker Compose automatically uses the correct project name from `COMPOSE_PROJECT_NAME` in `.env`. Worktrees use `musashi-wt-NNN`, main repo uses `musashi`.

## Docker node_modules Management

We use Docker anonymous volumes to isolate node_modules from the host system. This prevents:
- Platform-specific binary conflicts
- Host's empty node_modules overriding container's dependencies
- Race conditions from multiple services installing simultaneously

**How it works:**
- Dependencies are installed during `docker compose build`
- Anonymous volumes (`/musashi/node_modules`) keep them isolated from host
- When package.json or yarn.lock changes, just run `docker compose build` - dependencies refresh automatically
- No manual `yarn install` needed

**References:**
- [Docker best practices for Node.js](https://www.docker.com/blog/keep-nodejs-rockin-in-docker/)
- [Why anonymous volumes for node_modules](https://stackoverflow.com/questions/30043872/docker-compose-node-modules-not-present-in-a-volume-after-npm-install-succeeds)

## GitHub Actions CI

### Branch and PR Naming Conventions
- Branch names are prefixed with ticket numbers (e.g., `ue-3238-media-asset`)
- PR titles are prefixed with ticket numbers (e.g., "UE-3238: Media asset initial foundation")
- To find current PR: Extract ticket number from branch name and search PRs

### Checking CI Results
- View recent runs: `gh run list --branch branch-name --limit 5`
- View Rspec test failures on current PR:
  1. Get branch name: `git branch --show-current`
  2. Find failed Rspec run: `gh run list --branch branch-name --workflow Rspec --status failure --limit 1`
  3. View failures: `gh run view RUN_ID --log-failed`
- CI runs parallel test jobs named `test(4, 0)`, `test(4, 1)`, `test(4, 2)`, `test(4, 3)` (4 parallel jobs)
- Other workflows: `Rspec`, `Eslint Code`, `Vitest`, `Lint Code`, `Chromatic`

## Accessing local dev resources

### Worktree-Specific Ports
**IMPORTANT**: All ports are determined by the worktree ID from `.worktree-id` file:
- Read `.worktree-id` to get the worktree number (e.g., `001`, `002`)
- Port pattern: `3{worktree_id}00` for app, `6{worktree_id}06` for Storybook
- Example for worktree `001`: App at `http://localhost:3100`, Storybook at `http://localhost:6106`
- Main repo (no `.worktree-id`): App at `http://localhost:3000`, Storybook at `http://localhost:6006`

### Service URLs
- **App**: `http://localhost:3{worktree_id}00` (e.g., worktree 001 = `http://localhost:3100`)
- **Storybook**: `http://localhost:6{worktree_id}06` (e.g., worktree 001 = `http://localhost:6106`)
- When using a browser to navigate in the app, don't try to guess URLs and navigate directly since we don't have a consistent URL structure, navigate via URL unless you know the URL from visiting it already.
- Use username evan@userevidence.com, password B1ga$$b0ats to login to the local app
