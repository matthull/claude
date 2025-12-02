# Plan: Add config-files.md Section Template

**Date**: 2025-11-05
**Context**: Review of T001 and T002 handoffs revealed gap for configuration/infrastructure tasks

## Problem Identified

Configuration file tasks (YAML, gitignore, Dockerfile, CI configs) are being generated with inappropriate directives:
- ❌ "Test Every New Method" appears but doesn't apply (no methods)
- ❌ Loop 1 (TDD) marked "N/A" - directive present but meaningless
- ❌ `testing.md` section included but adds minimal value

**Example tasks affected**:
- `.wtp.yml` creation (T001)
- `.gitignore` updates (T002)
- Dockerfile edits
- CI config updates (.github/workflows/*.yml)
- docker-compose.yml modifications
- Environment file templates

## Proposed Solution

Create `config-files.md` section template for non-code configuration tasks.

### When to Trigger

Detect keywords:
- File types: `.yml`, `.yaml`, `.json`, `.toml`, `.gitignore`, `Dockerfile`, `.env`
- Task types: `config`, `configuration`, `gitignore`, `dockerfile`, `CI config`, `environment file`
- Actions: `create config`, `update gitignore`, `add to dockerfile`

### Template Structure (Based on ruby-rails-code.md Pattern)

```markdown
---
type: task-template
section: config-files
description: Configuration file patterns, syntax validation, integration verification
applies_to: yaml, json, toml, gitignore, dockerfile, env
source_guidance:
  global:
    - code-quality/immediately-runnable-code
---

## CRITICAL: Config File Validity (ABSOLUTE)

**You MUST NEVER commit invalid config files**

**RATIONALE:** Invalid configs break deployments and local environments.

**You MUST ALWAYS validate:**
- YAML: `ruby -ryaml -e "YAML.load_file('file.yml')"`
- JSON: `python -m json.tool file.json`
- Shell scripts: `shellcheck file.sh` or `bash -n file.sh`
- Docker: `docker-compose config` (validates compose files)

---

## CRITICAL: Preserve Existing Configuration (ABSOLUTE)

**You MUST NEVER accidentally delete existing config entries**

**RATIONALE:** Config files often have subtle dependencies. Deletions break existing setups.

**You MUST ALWAYS:**
- Read entire file before editing
- Add new entries, don't replace entire file
- Test that existing functionality still works
- Document why entries are removed (if intentional)

---

## Configuration File Implementation Details

### File Validation Commands

**YAML files**:
```bash
ruby -ryaml -e "YAML.load_file('.wtp.yml')" && echo "✓ Valid" || echo "✗ Invalid"
python -c "import yaml; yaml.safe_load(open('file.yml'))"
```

**JSON files**:
```bash
python -m json.tool file.json >/dev/null && echo "✓ Valid" || echo "✗ Invalid"
jq . file.json >/dev/null
```

**Docker Compose**:
```bash
docker-compose config  # Validates and shows merged config
```

**Dockerfiles**:
```bash
docker build --no-cache --target <stage> .  # Test build
hadolint Dockerfile  # Lint Dockerfile
```

### Verification Commands

**Loop 1 (Syntax Check)**: Validate file syntax
```bash
# YAML
ruby -ryaml -e "YAML.load_file('file.yml')"

# JSON
python -m json.tool file.json

# Dockerfile
docker build --no-cache .
```

**Loop 2 (Integration Check)**: Verify config loads/works
```bash
# Test config is read by tool
wtp --version  # (for .wtp.yml)
docker-compose config  # (for docker-compose.yml)
git check-ignore <pattern>  # (for .gitignore)
```

**Loop 3 (Manual Verification)**: Test in real environment
```bash
# Actually use the configuration
wtp add test-feature  # (test .wtp.yml hooks)
docker-compose up -d  # (test compose file)
git status  # (test gitignore patterns)
```

### Code Quality Checklist

**Before Completing Task**:
- [ ] **CRITICAL: Config syntax is valid** (parser doesn't error)
- [ ] **CRITICAL: Existing entries preserved** (no accidental deletions)
- [ ] File format follows project conventions
- [ ] Comments added for non-obvious entries
- [ ] Integration test passes (config actually works)
- [ ] No secrets or sensitive data in config
- [ ] Documentation updated (if config changes behavior)

### Common Patterns

**YAML Configuration**:
- Use consistent indentation (2 spaces standard)
- Quote strings with special characters
- Use anchors/references for repeated values
- Validate with multiple tools (ruby + python)

**Gitignore Patterns**:
- Most specific patterns first
- Group related patterns with comments
- Test with `git check-ignore <file>`
- Use `**` for recursive matches

**Dockerfile**:
- Multi-stage builds for optimization
- COPY before RUN to leverage layer caching
- Use specific base image tags (not :latest)
- Validate with `hadolint` linter

### Anti-patterns to Avoid

**You MUST NEVER**:
- ❌ Commit config files without syntax validation
- ❌ Delete existing config entries without understanding impact
- ❌ Use `:latest` tags in production configs
- ❌ Commit secrets or credentials in config files
- ❌ Skip testing that config actually works
- ❌ Create configs without comments for complex entries
- ❌ Ignore linter warnings (shellcheck, hadolint, yamllint)

**Prefer**:
- ✅ Explicit versions in dependencies
- ✅ Environment variables for secrets
- ✅ Comments explaining non-obvious configuration
- ✅ Validating with multiple tools
- ✅ Testing in isolated environment first
```

## Key Differences from Code Templates

| Aspect | Code Templates | Config Templates |
|--------|---------------|------------------|
| **Testing** | TDD with RSpec/Bats | Syntax validation + integration |
| **Loop 1** | Unit tests | Parser validation |
| **Loop 2** | Scoped test suite | Config loads correctly |
| **Loop 3** | Manual console/browser | Real tool usage |
| **CRITICAL directives** | "Test Every Method" | "Validate File Syntax" |
| **Main concerns** | Logic correctness | Syntax + Integration |

## Implementation Steps

1. **Create** `~/.claude/templates/task/sections/config-files.md` (~6-8 KB)
2. **Update** `/home/matt/.claude/commands/handoff.md` detection:
   ```bash
   if [[ "$description" =~ (\.yml|\.yaml|\.json|gitignore|Dockerfile|config.*file|\.env) ]]; then
     templates+=("~/.claude/templates/task/sections/config-files.md")
   fi
   ```
3. **Test** with sample config task:
   ```bash
   /handoff update docker-compose.yml to add new service
   /handoff create .github/workflows/deploy.yml for CI
   ```

## Tasks That Would Benefit

**Current project** (005-parallel-dev):
- T001: Create .wtp.yml ✅ (would benefit)
- T002: Update .gitignore ✅ (would benefit)

**Common scenarios**:
- Creating/updating docker-compose files
- Adding CI/CD workflows (.github/workflows/*.yml)
- Modifying Dockerfiles
- Creating environment file templates
- Updating gitignore patterns
- Adding ESLint/Prettier configs

## Estimated Effort

- **Create template**: 2-3 hours
- **Update detection**: 30 minutes
- **Test with samples**: 1 hour
- **Total**: 3-4 hours

## Notes

- Config template should be **simpler** than code templates
- Focus on **syntax validation** not unit testing
- Emphasize **integration verification** (does config work?)
- Remove irrelevant directives ("Test Every Method")
- Keep it concise - config tasks are usually straightforward

## Related Files

- `/home/matt/.claude/templates/task/sections/ruby-rails-code.md` (reference structure)
- `/home/matt/.claude/templates/task/sections/bash-docker-scripts.md` (similar creation process)
- `/home/matt/.claude/commands/handoff.md` (detection logic)
- Example handoffs: `specs/005-parallel-dev/task-handoffs/T001*.md`, `T002*.md`
