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

- Run RSpec: `docker exec musashi-web-1 bundle exec rspec`
- Run single test: `docker exec musashi-web-1 bundle exec rspec path/to/spec.rb:LINE_NUMBER`
- Run JS tests: `docker exec musashi-web-1 yarn test` or single: `docker exec musashi-web-1 npx vitest app/javascript/src/lib/file_name.test.ts`
- TDD workflow: `docker exec -ti musashi-web-1 bundle exec guard`
- Lint Ruby: `rubocop` (use `-a` for auto-fix, `-A` for aggressive fixes)
- Lint JS: `yarn eslint`
- **See Docker workflow guidance: @.claude/guidance/docker-commands.md**

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
- The app lives at `http://localhost:3000`
- When using Puppeteer to navigate in the app, don't try to guess URLs and navigate directly since we don't have a consistent URL structure, navigate via URL unless you know the URL from visiting it already.
- The storybook server is at `http://localhost:6006`

### Puppeteer Testing
@.claude/guidance/puppeteer.md

## Frontend Best Practices
@.claude/guidance/vue/component-patterns.md
@.claude/guidance/vue/styling-patterns.md
@.claude/guidance/frontend-libraries.md

## Backend Best Practices
@.claude/guidance/rails/api-patterns.md
@.claude/guidance/rails/models.md
@.claude/guidance/rails/service-objects.md
@.claude/guidance/backend-patterns.md

## Testing Best Practices
@.claude/guidance/rails/backend-testing.md
@.claude/guidance/testing/testing-strategy.md
@.claude/guidance/testing-patterns.md

## Additional Guidance References
@.claude/guidance/rails-vue/integration-patterns.md
@.claude/guidance/testing/integration-manual-qa.md
