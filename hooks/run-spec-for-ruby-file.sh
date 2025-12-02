#!/bin/bash

# Hook script to run RSpec tests when Ruby files are modified
# Enforces spec creation for non-ignored files

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
specignore_file="$project_root/.specignore"

# Function to check if file matches .specignore patterns
is_ignored() {
  local file="$1"

  # If no .specignore file, nothing is ignored
  if [ ! -f "$specignore_file" ]; then
    return 1
  fi

  # Read .specignore and check patterns
  while IFS= read -r pattern; do
    # Skip comments and empty lines
    if [[ "$pattern" =~ ^# ]] || [[ -z "$pattern" ]]; then
      continue
    fi

    # Convert glob pattern to regex for matching
    # Handle ** for recursive directories
    pattern="${pattern//\*\*/.*}"
    # Handle * for single level wildcard
    pattern="${pattern//\*/[^/]*}"
    # Anchor pattern to match from start
    pattern="^${pattern}$"

    # Check if file matches pattern
    if [[ "$file" =~ $pattern ]]; then
      return 0  # File is ignored
    fi
  done < "$specignore_file"

  return 1  # File is not ignored
}

# Function to run spec with docker
run_spec() {
  local spec_file="$1"
  local full_path="$project_root/$spec_file"
  if [ -f "$full_path" ]; then
    echo "✅ Running spec: $spec_file" >&2
    # Capture RSpec output to process it
    local rspec_output
    rspec_output=$(docker compose exec web bundle exec rspec "$spec_file" \
      --format documentation \
      --force-color 2>&1)
    local spec_exit_code=$?

    # Send full output to user's terminal
    echo "$rspec_output" >&2

    # Handle test results
    if [ $spec_exit_code -ne 0 ]; then
      # Extract "Failures:" section and send to stderr for Claude to see
      echo "$rspec_output" | sed -n '/^Failures:/,$p' >&2
      exit 2  # Blocking error - test what this blocks
    else
      echo "✅ All specs passed" # Brief success message for Claude (stdout)
    fi
  else
    # Check if file should be ignored
    if is_ignored "$relative_path"; then
      echo "ℹ️  File is in .specignore, skipping spec check: $relative_path" >&2
    else
      echo "🚨 ERROR: SPEC REQUIRED!" >&2
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
      echo "❌ No spec found for: $relative_path" >&2
      echo "❌ Expected spec at: $spec_file" >&2
      echo "" >&2
      echo "⚠️  YOU MUST CREATE THIS SPEC BEFORE PROCEEDING!" >&2
      echo "" >&2
      echo "To create the spec, run:" >&2
      echo "  touch $project_root/$spec_file" >&2
      echo "" >&2
      echo "Or if this file doesn't need a spec, add it to .specignore:" >&2
      echo "  echo '$relative_path' >> $project_root/.specignore" >&2
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2

      # Exit with code 2 to block execution (per Claude Code docs)
      exit 2
    fi
  fi
}

# If the modified file is already a spec, run it
if [[ "$relative_path" =~ ^spec/.*_spec\.rb$ ]]; then
  run_spec "$relative_path"
  exit 0
fi

# Skip spec check for ignored files
if is_ignored "$relative_path"; then
  echo "ℹ️  File is in .specignore, no spec required: $relative_path" >&2
  exit 0
fi

# Map Ruby files to their specs based on Guardfile patterns
spec_file=""

# Controllers -> request specs
if [[ "$relative_path" =~ ^app/controllers/(.+)/(.+)_controller\.rb$ ]]; then
  dir="${BASH_REMATCH[1]}"
  name="${BASH_REMATCH[2]}"
  spec_file="spec/requests/${dir}/${name}_controller_spec.rb"
elif [[ "$relative_path" =~ ^app/controllers/(.+)_controller\.rb$ ]]; then
  name="${BASH_REMATCH[1]}"
  spec_file="spec/requests/${name}_controller_spec.rb"
# App files -> spec with same structure
elif [[ "$relative_path" =~ ^app/(.+)\.rb$ ]]; then
  spec_file="spec/${BASH_REMATCH[1]}_spec.rb"
# Lib files -> spec/lib
elif [[ "$relative_path" =~ ^lib/(.+)\.rb$ ]]; then
  spec_file="spec/lib/${BASH_REMATCH[1]}_spec.rb"
fi

# Run the spec if we found a mapping
if [ -n "$spec_file" ]; then
  run_spec "$spec_file"
  # Note: if run_spec calls exit 2, this line will never be reached
else
  echo "ℹ️  No spec mapping found for: $relative_path" >&2
fi