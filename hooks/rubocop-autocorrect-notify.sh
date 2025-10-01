#!/bin/bash

# Enhanced Rubocop hook that clearly communicates with Claude
# Auto-fixes what it can, then reports remaining issues

# Read JSON input from stdin and extract file_path
json_input=$(cat)
file_path=$(echo "$json_input" | jq -r '.tool_input.file_path // empty')

# Exit if we couldn't parse the file path
if [ -z "$file_path" ]; then
  exit 0
fi

# Exit if not a Ruby file
if [[ ! "$file_path" =~ \.(rb|rake)$|Rakefile$|Gemfile$ ]]; then
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
echo "║                    🤖 RUBOCOP AUTO-CORRECTION                     ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
echo "📁 File: $relative_path"
echo ""

# Capture file hash before changes
before_hash=$(md5sum "$file_path" 2>/dev/null | cut -d' ' -f1)

# Run rubocop auto-correct (aggressive mode)
cd "$project_root"
echo "🔧 Running auto-correction..."
rubocop_autocorrect_output=$(rubocop -A "$relative_path" 2>&1)
autocorrect_exit_code=$?

# Skip deprecation warnings
rubocop_autocorrect_output=$(echo "$rubocop_autocorrect_output" | grep -v "deprecated")

# Capture file hash after changes
after_hash=$(md5sum "$file_path" 2>/dev/null | cut -d' ' -f1)

# Check if file was modified
if [ "$before_hash" != "$after_hash" ]; then
  echo "✅ CLAUDE: FILE WAS MODIFIED BY RUBOCOP AUTO-CORRECTION"
  echo "   The file has been automatically updated with style fixes."
  echo ""
fi

# Now check for remaining issues
echo "🔍 Checking for remaining issues..."
rubocop_output=$(rubocop "$relative_path" 2>&1)
rubocop_exit_code=$?

# Skip deprecation warnings
rubocop_output=$(echo "$rubocop_output" | grep -v "deprecated")

if [ $rubocop_exit_code -eq 0 ]; then
  echo ""
  echo "✅ CLAUDE: ALL RUBOCOP CHECKS PASSED"
  echo "   No manual corrections needed - file is clean!"
  echo ""
  echo "═══════════════════════════════════════════════════════════════════"
  exit 0
fi

# Parse remaining offenses
offense_count=$(echo "$rubocop_output" | grep -c "^$relative_path:[0-9]+:[0-9]+")

if [ "$offense_count" -gt 0 ]; then
  echo "" >&2
  echo "⚠️  CLAUDE: MANUAL FIXES REQUIRED - $offense_count issue(s) remain" >&2
  echo "" >&2
  echo "These issues could not be auto-corrected:" >&2
  echo "───────────────────────────────────────────────────────────────" >&2

  # Extract and format offenses for user terminal (stderr)
  echo "$rubocop_output" | grep -E "^$relative_path:[0-9]+:[0-9]+" | while IFS= read -r line; do
    # Parse line:column:severity:cop_name:message
    location=$(echo "$line" | cut -d: -f2-3)
    severity=$(echo "$line" | cut -d: -f4 | xargs)
    cop=$(echo "$line" | cut -d: -f5 | xargs)
    message=$(echo "$line" | cut -d: -f6- | xargs)

    # Color-code by severity
    case "$severity" in
      "E") icon="🔴" level="ERROR" ;;
      "W") icon="⚠️ " level="WARNING" ;;
      "C") icon="💡" level="CONVENTION" ;;
      "R") icon="♻️ " level="REFACTOR" ;;
      *) icon="ℹ️ " level="INFO" ;;
    esac

    echo "" >&2
    echo "$icon Line $location [$cop]" >&2
    echo "   $message" >&2
  done

  echo "" >&2
  echo "───────────────────────────────────────────────────────────────" >&2
  echo "" >&2
  echo "📝 CLAUDE ACTION REQUIRED:" >&2
  echo "   1. Fix these issues manually in your next edit" >&2
  echo "   2. Or add rubocop:disable comments if appropriate" >&2
  echo "   3. Or update .rubocop.yml configuration if needed" >&2
  echo "" >&2
  echo "To see full rubocop output, run:" >&2
  echo "   rubocop $relative_path" >&2
  echo "" >&2
  echo "═══════════════════════════════════════════════════════════════════" >&2

  # Send raw offense lines to stdout for Claude to see
  echo "$rubocop_output" | grep -E "^$relative_path:[0-9]+:[0-9]+"
  exit 2  # Blocking error - Claude can see issues
fi

# All clean - exit 0
exit 0