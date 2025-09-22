#!/bin/bash

# Hook script to run Rubocop linting when Ruby files are modified
# Auto-fixes what it can, then reports remaining issues

# Read JSON input from stdin and extract file_path
json_input=$(cat)
file_path=$(echo "$json_input" | jq -r '.tool_input.file_path')

# Exit if we couldn't parse the file path
if [ -z "$file_path" ]; then
  exit 0
fi

# Exit if not a Ruby file
if [[ ! "$file_path" =~ \.rb$ ]]; then
  exit 0
fi

# Exit if not in musashi project
if [[ ! "$file_path" =~ /musashi/ ]]; then
  exit 0
fi

# Get project root and relative path
project_root="/home/matt/code/musashi"
relative_path="${file_path#$project_root/}"

# Skip rubocop for spec files (optional - remove if you want to lint specs too)
if [[ "$relative_path" =~ ^spec/.*_spec\.rb$ ]]; then
  echo "ℹ️  Skipping rubocop for spec file: $relative_path"
  exit 0
fi

echo "🔧 Running Rubocop auto-correct on: $relative_path"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Run rubocop auto-correct first (aggressive mode to fix as much as possible)
cd "$project_root"
rubocop -A "$relative_path" 2>&1 | tail -n +2  # Skip deprecation warning

echo ""
echo "🔍 Checking for remaining Rubocop issues..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Run rubocop to check for remaining issues
rubocop_output=$(rubocop "$relative_path" 2>&1)
rubocop_exit_code=$?

# Skip the deprecation warning line
rubocop_output=$(echo "$rubocop_output" | tail -n +2)

if [ $rubocop_exit_code -eq 0 ]; then
  echo "✅ No Rubocop issues found! File is clean."
  exit 0
fi

# Parse and display remaining issues
echo "$rubocop_output" | grep -E "^$relative_path:[0-9]+:[0-9]+" | while IFS= read -r line; do
  # Extract the offense details
  offense=$(echo "$line" | sed "s|^$relative_path:||")
  echo "⚠️  $offense"
done

# Check if there are offenses that couldn't be auto-corrected
offense_count=$(echo "$rubocop_output" | grep -c "^$relative_path:[0-9]+:[0-9]+")

if [ "$offense_count" -gt 0 ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "❌ Found $offense_count Rubocop issue(s) that couldn't be auto-fixed!"
  echo ""
  echo "These issues require manual intervention:"
  echo "1. Fix them manually in your editor"
  echo "2. Or add exceptions to .rubocop.yml if appropriate"
  echo "3. Or disable specific cops with inline comments if needed"
  echo ""
  echo "To see full details, run:"
  echo "  rubocop $relative_path"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Don't exit with error - just warn
  # This allows the edit to proceed but makes issues visible
  exit 0
fi

echo "✅ All issues were auto-corrected!"