---
type: task-template
section: bash-docker-scripts
description: Bash scripting patterns, Docker execution, bats-core TDD testing
applies_to: bash, shell, docker
source_guidance:
  global:
    - testing/test-driven-development
    - development-process/tdd-human-review-cycle
---

## CRITICAL: Bash Script Safety (ABSOLUTE)

**You MUST NEVER create bash scripts without error handling**

**RATIONALE:** Bash scripts without error handling silently fail and create hidden bugs.

**You MUST ALWAYS start scripts with:**
```bash
#!/usr/bin/env bash
set -euo pipefail
```

**What this means:**
- `set -e` - Exit immediately if any command fails
- `set -u` - Exit if undefined variable is used
- `set -o pipefail` - Catch failures in pipes (e.g., `cmd1 | cmd2`)

**EXCEPTION:** Only use `set +e` temporarily for commands you EXPECT to fail, then re-enable with `set -e`

---

## CRITICAL: Test Every Bash Function (ABSOLUTE)

**You MUST NEVER add bash functions without bats tests**

**RATIONALE:** Untested bash functions = hidden bugs. Bash's weak typing makes tests essential.

**You MUST ALWAYS test at the function level:**
- ✅ Public function → Bats test with `@test` annotation
- ✅ Script entry point → Bats test that runs the script
- ✅ Helper functions → Bats test (unless truly private)

**WRONG:**
```bash
# Adding function without test
function validate_config() {
  # implementation
}
# ❌ No bats test
```

**CORRECT:**
```bash
# test/validator.bats
@test "validate_config accepts valid JSON" {
  run validate_config valid.json
  [ "$status" -eq 0 ]
}

@test "validate_config rejects invalid JSON" {
  run validate_config invalid.json
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Invalid JSON" ]]
}
```

---

## CRITICAL: Parameter Validation (ABSOLUTE)

**You MUST NEVER skip parameter validation in bash scripts**

**RATIONALE:** Bash doesn't validate types or arity. Scripts fail cryptically without validation.

**You MUST ALWAYS validate:**
- Required parameters exist
- Parameter count is correct
- File paths exist (if expected)
- Enums match expected values

**Example:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Validate required parameter
if [ $# -lt 1 ]; then
  echo "Error: Missing required parameter" >&2
  echo "Usage: $0 <config_file>" >&2
  exit 1
fi

config_file="$1"

# Validate file exists
if [ ! -f "$config_file" ]; then
  echo "Error: Config file not found: $config_file" >&2
  exit 1
fi
```

---

## CRITICAL: Idempotency (ABSOLUTE)

**You MUST NEVER create bash scripts that break when run multiple times**

**RATIONALE:** Scripts are often retried or re-run. Non-idempotent scripts cause data corruption.

**You MUST ALWAYS:**
- Check before creating (don't fail if already exists)
- Check before deleting (don't fail if already gone)
- Use conditional logic for state changes

**WRONG:**
```bash
mkdir output/      # ❌ Fails on second run
rm config.old      # ❌ Fails if file doesn't exist
```

**CORRECT:**
```bash
mkdir -p output/                    # ✅ Succeeds even if exists
rm -f config.old                    # ✅ Succeeds even if missing
[ -d output/ ] || mkdir output/     # ✅ Explicit check
```

---

## Bash/Docker Implementation Details

### Script Structure Pattern

**File**: `{script_name}.sh`

```bash
#!/usr/bin/env bash
#
# Script description: What does this script do?
#
# Usage: {script_name}.sh [options] <required_param>
#
# Options:
#   -h, --help     Show this help message
#   -v, --verbose  Enable verbose output
#
set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Script configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# Function: show_help
# Description: Display usage information
show_help() {
  cat << EOF
Usage: $SCRIPT_NAME [options] <required_param>

Description of what this script does.

Options:
  -h, --help     Show this help message
  -v, --verbose  Enable verbose output

Examples:
  $SCRIPT_NAME config.json
  $SCRIPT_NAME --verbose config.json
EOF
}

# Function: log_info
# Description: Print info message
log_info() {
  echo -e "${GREEN}✓${NC} $*"
}

# Function: log_error
# Description: Print error message to stderr
log_error() {
  echo -e "${RED}✗${NC} $*" >&2
}

# Function: log_warn
# Description: Print warning message
log_warn() {
  echo -e "${YELLOW}⚠${NC} $*"
}

# Main script logic
main() {
  # Parse arguments
  local verbose=false

  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_help
        exit 0
        ;;
      -v|--verbose)
        verbose=true
        shift
        ;;
      -*)
        log_error "Unknown option: $1"
        show_help
        exit 1
        ;;
      *)
        # First positional argument
        break
        ;;
    esac
  done

  # Validate required parameters
  if [ $# -lt 1 ]; then
    log_error "Missing required parameter"
    show_help
    exit 1
  fi

  local required_param="$1"

  # Implementation
  log_info "Processing $required_param..."

  # Your logic here

  log_info "Complete!"
}

# Run main function
main "$@"
```

### Expected Test Structure (Bats)

**File**: `test/{script_name}.bats`

```bash
#!/usr/bin/env bats
#
# Tests for {script_name}.sh
#

# Setup function - runs before each test
setup() {
  # Load the script
  export SCRIPT_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  export SCRIPT="$SCRIPT_DIR/{script_name}.sh"

  # Create temp directory for test files
  export TEST_TEMP_DIR="$(mktemp -d)"
}

# Teardown function - runs after each test
teardown() {
  # Clean up temp directory
  rm -rf "$TEST_TEMP_DIR"
}

@test "script exists and is executable" {
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
}

@test "shows help with --help flag" {
  run "$SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "fails with missing required parameter" {
  run "$SCRIPT"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Missing required parameter" ]]
}

@test "succeeds with valid input" {
  # Arrange
  echo '{"key": "value"}' > "$TEST_TEMP_DIR/test.json"

  # Act
  run "$SCRIPT" "$TEST_TEMP_DIR/test.json"

  # Assert
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Complete!" ]]
}

@test "fails gracefully with invalid input" {
  # Arrange
  echo 'invalid json' > "$TEST_TEMP_DIR/test.json"

  # Act
  run "$SCRIPT" "$TEST_TEMP_DIR/test.json"

  # Assert
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Error" ]]
}

@test "script is idempotent" {
  # Arrange
  echo '{"key": "value"}' > "$TEST_TEMP_DIR/test.json"

  # Act - run twice
  run "$SCRIPT" "$TEST_TEMP_DIR/test.json"
  first_status="$status"

  run "$SCRIPT" "$TEST_TEMP_DIR/test.json"
  second_status="$status"

  # Assert - both succeed
  [ "$first_status" -eq 0 ]
  [ "$second_status" -eq 0 ]
}
```

### Bats Testing Patterns

**Basic Test Structure**:
```bash
@test "description of what is being tested" {
  run command_to_test arg1 arg2
  [ "$status" -eq 0 ]                    # Check exit code
  [[ "$output" =~ "expected pattern" ]]  # Check stdout
}
```

**Exit Code Assertions**:
```bash
[ "$status" -eq 0 ]   # Success
[ "$status" -eq 1 ]   # General error
[ "$status" -ne 0 ]   # Any error
```

**Output Assertions**:
```bash
[[ "$output" =~ "pattern" ]]            # Regex match
[[ "$output" == "exact match" ]]        # Exact match
[[ "$output" =~ ^Success ]]             # Starts with
[[ "$lines[0]" == "first line" ]]       # Check specific line
```

**Testing stderr**:
```bash
run command 2>&1  # Capture stderr with stdout
[[ "$output" =~ "error message" ]]
```

**File Assertions**:
```bash
[ -f "$file" ]        # File exists
[ ! -f "$file" ]      # File doesn't exist
[ -d "$dir" ]         # Directory exists
[ -x "$script" ]      # File is executable
```

### Verification Commands

**Loop 1 (TDD)**:
```bash
# Run specific test file
bats test/{script_name}.bats

# Run single test
bats test/{script_name}.bats --filter "test name pattern"
```

**Loop 2 (Full Suite)**:
```bash
# Bats is fast - just run ALL tests
bats test/**/*.bats

# Or use verify-specs.sh wrapper if it exists
./specs/{PROJECT_NAME}/verify-specs.sh
```

**Loop 3 (Manual)**:

**Required for**: Docker integration, file operations, external dependencies
**Skip ONLY with user approval**

```bash
# Run script with test data
./{script_name}.sh test_input.json

# If script runs in Docker
docker exec container-name ./{script_name}.sh test_input.json

# Verify output/side effects
cat output_file
docker exec container-name ls -la /expected/path
```

### Docker Execution Patterns

**Testing Scripts that Run in Containers**:

```bash
# In bats test
@test "script works inside docker container" {
  # Copy script and test data into container
  docker cp "$SCRIPT" container-name:/tmp/script.sh
  docker cp test_data.json container-name:/tmp/test_data.json

  # Run in container
  run docker exec container-name /tmp/script.sh /tmp/test_data.json

  [ "$status" -eq 0 ]
}
```

**Docker Detection Pattern** (from verify-specs.sh):
```bash
if [ -f /.dockerenv ]; then
    echo "Running inside Docker container"
    DOCKER_PREFIX=""
else
    echo "Running outside Docker - using docker exec"
    DOCKER_PREFIX="docker exec container-name"
fi

# Execute commands
$DOCKER_PREFIX bundle exec rspec
```

**Docker Compose Integration**:
```bash
# Start containers for testing
docker compose up -d

# Run tests
bats test/**/*.bats

# Cleanup
docker compose down
```

### Code Quality Checklist

**Before Completing Task**:
- [ ] **CRITICAL: Script starts with `set -euo pipefail`**
- [ ] **CRITICAL: Every function has bats test**
- [ ] **CRITICAL: Required parameters validated**
- [ ] **CRITICAL: Script is idempotent (safe to run multiple times)**
- [ ] ShellCheck passes: `shellcheck {script_name}.sh`
- [ ] All bats tests pass: `bats test/**/*.bats`
- [ ] No debug statements (`set -x`, `echo` for debugging)
- [ ] Functions are small and focused (< 20 lines preferred)
- [ ] Clear function/variable names
- [ ] Edge cases handled (missing files, invalid input, empty strings)
- [ ] Error messages are descriptive and go to stderr
- [ ] Help text is clear and includes examples
- [ ] Script works both inside and outside Docker (if applicable)

### Bash Patterns

**Error Handling**:
```bash
# Function that can fail
process_file() {
  local file="$1"

  if [ ! -f "$file" ]; then
    log_error "File not found: $file"
    return 1
  fi

  # Process file
  # ...

  return 0
}

# Call function and handle errors
if ! process_file "$filename"; then
  log_error "Failed to process file"
  exit 1
fi
```

**Subshell for Temporary set -e Disable**:
```bash
# Check if command succeeds, but don't exit on failure
if (set +e; some_command_that_might_fail); then
  echo "Command succeeded"
else
  echo "Command failed, but we continue"
fi
```

**Arrays**:
```bash
# Define array
files=("file1.txt" "file2.txt" "file3.txt")

# Iterate
for file in "${files[@]}"; do
  process_file "$file"
done

# Check if array is empty
if [ ${#files[@]} -eq 0 ]; then
  echo "No files"
fi
```

**String Operations**:
```bash
# Default value
name="${1:-default_name}"

# Check if variable is set
if [ -z "$name" ]; then
  echo "Name is empty"
fi

# String contains
if [[ "$string" =~ "pattern" ]]; then
  echo "Match found"
fi
```

### Common Anti-patterns to Avoid

**You MUST NEVER**:
- ❌ **Omit `set -euo pipefail`** (scripts silently fail)
- ❌ **Skip parameter validation** (cryptic failures)
- ❌ **Write bash functions without tests** (untestable spaghetti)
- ❌ **Use `set +e` globally** (defeats error handling)
- ❌ **Ignore exit codes** (failures go unnoticed)
- ❌ **Write non-idempotent scripts** (breaks on retry)
- ❌ Use `cd` without error checking (`cd dir || exit 1`)
- ❌ Parse ls output (`for file in $(ls)` is broken)
- ❌ Use `eval` (security risk, hard to test)
- ❌ Put secrets in scripts (use environment variables)
- ❌ Use single `[` when `[[` is safer (word splitting)
- ❌ Forget to quote variables (`$var` → `"$var"`)

**Prefer**:
- ✅ Small, focused functions (easier to test)
- ✅ Bats tests for every function
- ✅ Descriptive error messages to stderr
- ✅ Help text with examples
- ✅ Colored output for readability
- ✅ ShellCheck linting
- ✅ Idempotent operations
- ✅ Docker-aware scripts (check /.dockerenv)
