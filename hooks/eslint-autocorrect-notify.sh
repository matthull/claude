#!/bin/bash

# Enhanced ESLint hook that clearly communicates with Claude
# Auto-fixes what it can, then reports remaining issues

# Read JSON input from stdin and extract file_path
json_input=$(cat)
file_path=$(echo "$json_input" | jq -r '.tool_input.file_path // empty')

# Exit if we couldn't parse the file path
if [ -z "$file_path" ]; then
  exit 0
fi

# Exit if not a JavaScript/TypeScript file
if [[ ! "$file_path" =~ \.(js|jsx|ts|tsx|vue)$ ]]; then
  exit 0
fi

# Exit if not in musashi project
if [[ ! "$file_path" =~ /musashi/ ]]; then
  exit 0
fi

# Get project root and relative path
project_root="/home/matt/code/musashi"
relative_path="${file_path#$project_root/}"

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                    🎨 ESLINT AUTO-CORRECTION                      ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
echo "📁 File: $relative_path"
echo ""

# Capture file hash before changes
before_hash=$(md5sum "$file_path" 2>/dev/null | cut -d' ' -f1)

# Run eslint with --fix
cd "$project_root"
echo "🔧 Running auto-correction..."

# Use docker exec to run eslint in the container
eslint_fix_output=$(docker exec musashi-web-1 yarn eslint --fix "$relative_path" 2>&1)
fix_exit_code=$?

# Capture file hash after changes
after_hash=$(md5sum "$file_path" 2>/dev/null | cut -d' ' -f1)

# Check if file was modified
if [ "$before_hash" != "$after_hash" ]; then
  echo "✅ CLAUDE: FILE WAS MODIFIED BY ESLINT AUTO-CORRECTION"
  echo "   The file has been automatically updated with style/lint fixes."
  echo ""
fi

# Now check for remaining issues (run without --fix)
echo "🔍 Checking for remaining issues..."
eslint_output=$(docker exec musashi-web-1 yarn eslint "$relative_path" --format=json 2>/dev/null)
eslint_exit_code=$?

# Check if Docker is running
if [ $? -ne 0 ] && [[ "$eslint_output" =~ "Cannot connect to the Docker daemon" ]]; then
  echo "⚠️  Docker is not running. Please start Docker to run ESLint."
  echo "═══════════════════════════════════════════════════════════════════"
  exit 0
fi

# Parse JSON output for errors and warnings
if [ -n "$eslint_output" ] && [ "$eslint_output" != "[]" ]; then
  # Extract error and warning counts
  error_count=$(echo "$eslint_output" | jq -r '.[0].errorCount // 0' 2>/dev/null)
  warning_count=$(echo "$eslint_output" | jq -r '.[0].warningCount // 0' 2>/dev/null)

  total_issues=$((error_count + warning_count))

  if [ "$total_issues" -eq 0 ]; then
    echo ""
    echo "✅ CLAUDE: ALL ESLINT CHECKS PASSED"
    echo "   No manual corrections needed - file is clean!"
    echo ""
    echo "═══════════════════════════════════════════════════════════════════"
    exit 0
  fi

  echo ""
  echo "⚠️  CLAUDE: MANUAL FIXES REQUIRED"
  echo "   🔴 Errors: $error_count | ⚠️  Warnings: $warning_count"
  echo ""
  echo "These issues could not be auto-corrected:"
  echo "───────────────────────────────────────────────────────────────"

  # Parse and display individual messages
  messages=$(echo "$eslint_output" | jq -r '.[0].messages[]? | "\(.line):\(.column) [\(.severity == 2 | if . then "ERROR" else "WARN" end)] \(.ruleId // "unknown"): \(.message)"' 2>/dev/null)

  if [ -n "$messages" ]; then
    echo "$messages" | while IFS= read -r msg; do
      if [[ "$msg" =~ "ERROR" ]]; then
        echo "🔴 $msg"
      else
        echo "⚠️  $msg"
      fi
    done
  fi

  echo ""
  echo "───────────────────────────────────────────────────────────────"
  echo ""
  echo "📝 CLAUDE ACTION REQUIRED:"
  echo "   1. Fix these issues manually in your next edit"
  echo "   2. Or add eslint-disable comments if appropriate"
  echo "   3. Or update .eslintrc configuration if needed"
  echo ""

  if [ "$error_count" -gt 0 ]; then
    echo "🔴 CRITICAL: There are $error_count error(s) that must be fixed!"
    echo ""
  fi

  echo "To see detailed eslint output, run:"
  echo "   docker exec musashi-web-1 yarn eslint $relative_path"
  echo ""
  echo "═══════════════════════════════════════════════════════════════════"
else
  # No JSON output or empty array means no issues
  echo ""
  echo "✅ CLAUDE: ALL ESLINT CHECKS PASSED"
  echo "   No manual corrections needed - file is clean!"
  echo ""
  echo "═══════════════════════════════════════════════════════════════════"
fi

# Always exit 0 to not block edits
exit 0