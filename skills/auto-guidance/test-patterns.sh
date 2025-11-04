#!/bin/bash
# Test pattern matching logic for auto-guidance
# Usage: ./test-patterns.sh [test_file_path]

set -e

# Test file paths
TEST_PATHS=(
  "app/controllers/users_controller.rb"
  "app/services/user_service.rb"
  "app/models/user.rb"
  "spec/models/user_spec.rb"
  "spec/services/user_service_spec.rb"
  "src/components/UserProfile.vue"
  "app/javascript/components/Header.vue"
  "app/assets/stylesheets/application.scss"
  "spec/javascript/components/Header.spec.js"
  "README.md"
  "Gemfile"
  "package.json"
)

# Common patterns to test
declare -A FILE_PATTERNS=(
  ["*.rb"]="Ruby files"
  ["*_controller.rb"]="Controllers"
  ["*_service.rb"]="Services"
  ["*_spec.rb"]="RSpec tests"
  ["*.vue"]="Vue components"
  ["*.scss"]="SCSS files"
  ["*.spec.js"]="Jest tests"
)

declare -A DIR_PATTERNS=(
  ["app/controllers/**"]="Controllers directory"
  ["app/services/**"]="Services directory"
  ["app/models/**"]="Models directory"
  ["spec/**"]="Specs directory"
  ["src/components/**"]="Components directory"
  ["app/javascript/**"]="JavaScript directory"
)

# Function to test file pattern matching
match_file_pattern() {
  local filepath="$1"
  local pattern="$2"

  # Extract just the filename
  filename=$(basename "$filepath")

  case "$filename" in
    $pattern) return 0 ;;
    *) return 1 ;;
  esac
}

# Function to test directory pattern matching
match_dir_pattern() {
  local filepath="$1"
  local pattern="$2"

  # Remove /** suffix for matching
  dir_prefix="${pattern%/**}"

  case "$filepath" in
    $dir_prefix/*) return 0 ;;
    *) return 1 ;;
  esac
}

echo "=== Auto-Guidance Pattern Matching Tests ==="
echo

# If specific file provided, test only that
if [ -n "$1" ]; then
  TEST_PATHS=("$1")
  echo "Testing specific file: $1"
  echo
fi

for filepath in "${TEST_PATHS[@]}"; do
  echo "📁 $filepath"

  file_matches=()
  dir_matches=()

  # Test file patterns
  for pattern in "${!FILE_PATTERNS[@]}"; do
    if match_file_pattern "$filepath" "$pattern"; then
      file_matches+=("$pattern (${FILE_PATTERNS[$pattern]})")
    fi
  done

  # Test directory patterns
  for pattern in "${!DIR_PATTERNS[@]}"; do
    if match_dir_pattern "$filepath" "$pattern"; then
      dir_matches+=("$pattern (${DIR_PATTERNS[$pattern]})")
    fi
  done

  # Print results
  if [ ${#file_matches[@]} -gt 0 ]; then
    echo "   File pattern matches:"
    for match in "${file_matches[@]}"; do
      echo "     ✓ $match"
    done
  fi

  if [ ${#dir_matches[@]} -gt 0 ]; then
    echo "   Directory pattern matches:"
    for match in "${dir_matches[@]}"; do
      echo "     ✓ $match"
    done
  fi

  if [ ${#file_matches[@]} -eq 0 ] && [ ${#dir_matches[@]} -eq 0 ]; then
    echo "   No matches"
  fi

  echo
done

echo "=== Test Complete ==="
