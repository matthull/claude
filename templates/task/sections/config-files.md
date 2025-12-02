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
- YAML: `ruby -ryaml -e "YAML.load_file('file.yml')"` or `python -c "import yaml; yaml.safe_load(open('file.yml'))"`
- JSON: `python -m json.tool file.json` or `jq . file.json`
- Shell scripts: `shellcheck file.sh` or `bash -n file.sh`
- Docker Compose: `docker-compose config` (validates compose files)
- Dockerfile: Test build with `docker build --no-cache .`

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
hadolint Dockerfile  # Lint Dockerfile (if available)
```

**Shell scripts**:
```bash
shellcheck file.sh  # Comprehensive linting
bash -n file.sh     # Syntax check only
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

# Shell script
bash -n script.sh
```

**Loop 2 (Integration Check)**: Verify config loads/works in its intended context
```bash
# Test config is read by tool
wtp --version  # (for .wtp.yml)
docker-compose config  # (for docker-compose.yml)
git check-ignore <pattern>  # (for .gitignore)

# Verify application reads config correctly
docker exec <container> cat config.yml  # Check file exists
docker logs <container>  # Check for config errors
```

**Loop 3 (Manual Verification)**: Test in real environment
```bash
# Actually use the configuration
wtp add test-feature  # (test .wtp.yml hooks)
docker-compose up -d  # (test compose file)
git status  # (test gitignore patterns)
docker exec <container> rake some:task  # (test app config)
```

### Code Quality Checklist

**Before Completing Task**:
- [ ] **CRITICAL: Config syntax is valid** (parser doesn't error)
- [ ] **CRITICAL: Existing entries preserved** (no accidental deletions)
- [ ] File format follows project conventions (indentation, quoting, etc.)
- [ ] Comments added for non-obvious entries
- [ ] Integration test passes (config actually works in context)
- [ ] No secrets or sensitive data in config
- [ ] Documentation updated (if config changes behavior)

### Common Patterns

**YAML Configuration**:
- Use consistent indentation (2 spaces standard)
- Quote strings with special characters (`:`, `#`, `@`, etc.)
- Use anchors/references for repeated values (`&anchor`, `*anchor`)
- Validate with multiple tools (ruby + python)
- Boolean values: use `true`/`false` not `yes`/`no` for clarity

**JSON Configuration**:
- Use 2-space indentation for readability
- Trailing commas not allowed (will break parsing)
- All keys must be double-quoted
- Use `jq` for validation and pretty-printing

**Gitignore Patterns**:
- Most specific patterns first
- Group related patterns with comments
- Test with `git check-ignore -v <file>` (shows which rule matches)
- Use `**` for recursive matches (e.g., `**/node_modules`)
- Use `!pattern` to negate/whitelist

**Dockerfile**:
- Multi-stage builds for optimization
- COPY before RUN to leverage layer caching
- Use specific base image tags (not `:latest`)
- Validate with `hadolint` linter if available
- Group related RUN commands with `&&` to reduce layers

**Docker Compose**:
- Use version 3+ format
- Define services in logical order (databases first, then apps)
- Use environment variables for configuration
- Define networks and volumes explicitly
- Use depends_on for service dependencies

**Environment Files (.env)**:
- Never commit to git (add to .gitignore)
- Provide `.env.example` with dummy values
- Document each variable with comments
- Use SCREAMING_SNAKE_CASE for variable names
- Group related variables together

### Anti-patterns to Avoid

**You MUST NEVER**:
- ❌ Commit config files without syntax validation
- ❌ Delete existing config entries without understanding impact
- ❌ Use `:latest` tags in production configs
- ❌ Commit secrets or credentials in config files
- ❌ Skip testing that config actually works
- ❌ Create configs without comments for complex entries
- ❌ Ignore linter warnings (shellcheck, hadolint, yamllint)
- ❌ Mix tabs and spaces in YAML (use spaces only)
- ❌ Hard-code environment-specific values (use env vars)

**Prefer**:
- ✅ Explicit versions in dependencies
- ✅ Environment variables for secrets and env-specific config
- ✅ Comments explaining non-obvious configuration
- ✅ Validating with multiple tools when possible
- ✅ Testing in isolated environment first
- ✅ Schema validation for complex configs
- ✅ Linting before committing
- ✅ Providing example/template files for sensitive configs

---

## Task Completion Criteria

A configuration file task is complete when:

1. **Syntax is valid** - File parses without errors
2. **Integration works** - Config is read and used correctly by its consumer
3. **Existing config preserved** - No unintended deletions or overwrites
4. **Manual verification passed** - Real-world usage confirms functionality
5. **Documentation updated** - Changes are documented if they affect behavior
6. **No secrets committed** - Sensitive data is externalized or in .env.example
