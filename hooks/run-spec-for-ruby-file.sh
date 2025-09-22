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
    echo "✅ Running spec: $spec_file"
    docker exec musashi-web-1 bundle exec rspec "$spec_file"
  else
    # Check if file should be ignored
    if is_ignored "$relative_path"; then
      echo "ℹ️  File is in .specignore, skipping spec check: $relative_path"
    else
      echo "🚨 ERROR: SPEC REQUIRED!"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "❌ No spec found for: $relative_path"
      echo "❌ Expected spec at: $spec_file"
      echo ""
      echo "⚠️  YOU MUST CREATE THIS SPEC BEFORE PROCEEDING!"
      echo ""
      echo "To create the spec, run:"
      echo "  touch $project_root/$spec_file"
      echo ""
      echo "Or if this file doesn't need a spec, add it to .specignore:"
      echo "  echo '$relative_path' >> $project_root/.specignore"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

      # Exit with error to make it clear this is blocking
      exit 1
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
  echo "ℹ️  File is in .specignore, no spec required: $relative_path"
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
else
  echo "ℹ️  No spec mapping found for: $relative_path"
fi