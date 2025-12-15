---
type: task-template
section: dev-environment-setup
description: Development environment setup, tool installation, editor configuration, emulator setup
applies_to: tooling, editor, emulator, dependencies, environment
source_guidance:
  global:
    - development-process/verification-principle
---

## CRITICAL: Validation Before Handoff (ABSOLUTE)

**You MUST validate your work before handing off to the user**

**RATIONALE:** Environment setup tasks have long feedback loops. User time wasted debugging your mistakes is unacceptable. Claude should catch errors first.

**You MUST ALWAYS:**
- Run verification commands after each setup step
- Confirm tools are installed and accessible (check `--version`, `which`, etc.)
- Test that configurations are loaded (not just created)
- Document any errors encountered and how they were resolved
- Only hand off when you have evidence the setup works

---

## CRITICAL: Test Strategy is Key (ABSOLUTE)

**Environment setup is NOT traditional TDD** - but verification is equally important.

**RATIONALE:** These tasks involve external tools, services, and system state. You can't write a test first, but you MUST have a verification plan.

**You MUST ALWAYS:**
- Define how you will verify success BEFORE starting
- Use health checks, version commands, and smoke tests
- Test integration between components (not just individual tools)
- Document the verification steps for the user to repeat

**Testing Approaches by Task Type:**

| Task Type | Verification Approach |
|-----------|----------------------|
| Tool installation | `--version` command, `which`/`where` |
| Editor config | Open file, verify LSP attaches, check diagnostics |
| Emulator setup | Launch emulator, connect debugger, run sample app |
| Dependencies | `npm install` succeeds, no peer dep warnings |
| Environment vars | Echo vars, verify app reads them |
| Git hooks | Trigger hook, verify it runs |

---

## CRITICAL: Idempotency (ABSOLUTE)

**Setup tasks MUST be re-runnable without breaking things**

**RATIONALE:** Users will re-run setup scripts. Partial failures happen. Re-running must be safe.

**You MUST ALWAYS:**
- Check if tool/config already exists before creating
- Use `mkdir -p` not `mkdir`
- Use package manager's idempotent install (not force reinstall)
- Preserve existing config (merge, don't overwrite)

---

## Development Environment Implementation Details

### Tool Installation Verification

**Node.js / npm**:
```bash
node --version && npm --version
which node  # Verify path is correct
npm config list  # Check configuration
```

**Package Managers**:
```bash
# Verify global tools
npm list -g --depth=0
yarn --version
pnpm --version
```

**Mobile Development**:
```bash
# Android
adb --version
adb devices  # Check connected devices/emulators
$ANDROID_HOME/emulator/emulator -list-avds  # List available AVDs

# Waydroid (Linux)
waydroid status
waydroid show-full-ui &  # Should launch Android
adb connect 192.168.250.2:5555 && adb devices

# iOS (macOS only)
xcodebuild -version
xcrun simctl list devices
```

**Expo / React Native**:
```bash
npx expo --version
npx expo doctor  # Comprehensive health check
npx react-native doctor  # RN CLI diagnostics
```

**TypeScript**:
```bash
npx tsc --version
npx tsc --noEmit  # Type check without emitting
```

**Linting**:
```bash
npx eslint --version
npx eslint . --max-warnings=0  # Should run without config errors
npx prettier --version
npx prettier --check .  # Verify formatting
```

### Editor Configuration Verification

**Neovim LSP**:
```bash
# In nvim, run:
:LspInfo  # Should show attached language servers
:checkhealth  # Comprehensive health check

# Verify LSP is working:
# 1. Open a .ts file
# 2. Check for diagnostics (errors/warnings)
# 3. Test go-to-definition (gd)
# 4. Test hover (K)
```

**VS Code** (if applicable):
```bash
code --list-extensions  # Verify extensions installed
code --status  # Check VS Code status
```

### Emulator/Device Verification

**Waydroid (Android on Linux)**:
```bash
# 1. Start Waydroid
waydroid show-full-ui

# 2. Wait for boot (check status)
waydroid status  # Should show "RUNNING"

# 3. Connect ADB
adb connect 192.168.250.2:5555

# 4. Verify connection
adb devices  # Should show device

# 5. Test app deployment (after project exists)
npx expo run:android
```

**Android Emulator (Standard)**:
```bash
# List available emulators
$ANDROID_HOME/emulator/emulator -list-avds

# Start emulator
$ANDROID_HOME/emulator/emulator -avd <avd_name> &

# Verify
adb devices
```

### Verification Loops

**Loop 1 (Installation Check)**: Verify tools are installed
```bash
# Check each tool exists and reports version
node --version
npm --version
npx expo --version
adb --version
# etc.
```

**Loop 2 (Configuration Check)**: Verify configs are loaded
```bash
# TypeScript config loads
npx tsc --showConfig

# ESLint config loads
npx eslint --print-config src/index.ts

# Editor recognizes project
# Open nvim, run :LspInfo, verify server attaches
```

**Loop 3 (Integration Check)**: Verify components work together
```bash
# Full development loop works:
# 1. Editor shows diagnostics
# 2. Emulator runs
# 3. Hot reload works
# 4. Tests run

npm start  # Metro bundler starts
npm test   # Tests run
```

### Pre-Handoff Checklist

**Before marking task complete, Claude MUST verify:**

- [ ] **All tools installed** - Version commands succeed
- [ ] **Configs valid** - No syntax errors, configs load
- [ ] **Editor integration works** - LSP attaches, diagnostics show
- [ ] **Emulator/device accessible** - Can connect, can deploy
- [ ] **Dependencies resolved** - No missing peer deps, no conflicts
- [ ] **Documentation exists** - User knows how to use the setup
- [ ] **Troubleshooting documented** - Common issues and fixes noted

### Health Check Script Pattern

For complex setups, create a health check script:

```bash
#!/bin/bash
# health-check.sh - Verify development environment

set -e

echo "=== Development Environment Health Check ==="

check() {
  if "$@" > /dev/null 2>&1; then
    echo "✓ $1"
  else
    echo "✗ $1 - FAILED"
    FAILED=true
  fi
}

FAILED=false

echo ""
echo "--- Core Tools ---"
check node --version
check npm --version
check npx expo --version

echo ""
echo "--- TypeScript ---"
check npx tsc --version
check npx tsc --noEmit

echo ""
echo "--- Linting ---"
check npx eslint --version
check npx prettier --version

echo ""
echo "--- Mobile ---"
check adb --version
# check waydroid status  # Uncomment if using Waydroid

echo ""
if [ "$FAILED" = true ]; then
  echo "=== SOME CHECKS FAILED ==="
  exit 1
else
  echo "=== ALL CHECKS PASSED ==="
fi
```

### Common Patterns

**Tool Installation**:
- Check if already installed before installing
- Use version managers (nvm, chruby) not system packages
- Pin versions in project (`.nvmrc`, `.node-version`)
- Document required versions in README

**Configuration Files**:
- Start from working examples, not from scratch
- Validate syntax before testing functionality
- Test with actual project files, not empty dirs
- Keep configs minimal - add complexity only when needed

**Environment Variables**:
- Use `.env.example` as template
- Never commit actual `.env` files
- Verify app reads vars correctly (log on startup)
- Document all required variables

**Path Configuration**:
- Prefer project-local tools (`npx`) over global
- If global needed, document PATH requirements
- Test in fresh shell (not just current session)

### Anti-patterns to Avoid

**You MUST NEVER**:
- ❌ Hand off without running verification commands
- ❌ Assume installation succeeded without checking
- ❌ Skip integration testing (tool A + tool B together)
- ❌ Leave user to debug your setup mistakes
- ❌ Create configs without testing they load
- ❌ Install globally when local would work
- ❌ Overwrite existing configs without backup
- ❌ Skip documenting troubleshooting steps

**Prefer**:
- ✅ Verify each step before proceeding
- ✅ Create health check scripts for complex setups
- ✅ Test in isolation first, then integration
- ✅ Document the "happy path" AND common failures
- ✅ Make setup idempotent (safe to re-run)
- ✅ Pin versions for reproducibility
- ✅ Provide rollback instructions

---

## Task Completion Criteria

A development environment task is complete when:

1. **Tools verified** - All required tools installed and accessible
2. **Configs valid** - Configuration files load without errors
3. **Integration tested** - Components work together (editor + linter + compiler)
4. **Health check passes** - Verification script/commands succeed
5. **Documentation complete** - User knows how to use and troubleshoot
6. **Idempotent** - Setup can be re-run safely
