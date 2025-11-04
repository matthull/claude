#!/bin/bash
# List all guidance files with their triggers
# Usage: ./list-triggers.sh [--verbose]

set -e

VERBOSE=false
if [[ "$1" == "--verbose" ]]; then
  VERBOSE=true
fi

echo "=== Guidance Files with Triggers ==="
echo

# Find all guidance files (excluding bundles)
GUIDANCE_FILES=$(find ~/.claude/guidance -name "*.md" -type f ! -path "*/bundles/*" 2>/dev/null)
if [ -d ".claude/guidance" ]; then
  PROJECT_FILES=$(find .claude/guidance -name "*.md" -type f ! -path "*/bundles/*" 2>/dev/null)
  GUIDANCE_FILES="$GUIDANCE_FILES"$'\n'"$PROJECT_FILES"
fi

total=0
with_triggers=0

while IFS= read -r file; do
  if [ -z "$file" ]; then continue; fi

  total=$((total + 1))

  # Extract frontmatter
  frontmatter=$(awk '/^---$/{if(++count==2) exit} count==1 && NR>1' "$file" 2>/dev/null || true)

  # Check if has triggers
  has_file_triggers=$(echo "$frontmatter" | grep -q "^file_triggers:" && echo "yes" || echo "no")
  has_dir_triggers=$(echo "$frontmatter" | grep -q "^directory_triggers:" && echo "yes" || echo "no")

  if [ "$has_file_triggers" == "yes" ] || [ "$has_dir_triggers" == "yes" ]; then
    with_triggers=$((with_triggers + 1))

    # Get relative path
    rel_path=$(echo "$file" | sed "s|$HOME/||")

    echo "📄 $rel_path"

    if [ "$VERBOSE" == "true" ]; then
      if [ "$has_file_triggers" == "yes" ]; then
        echo "  File triggers:"
        echo "$frontmatter" | awk '/^file_triggers:/,/^[a-z_]+:/ {if (!/^[a-z_]+:/) print "    " $0}'
      fi
      if [ "$has_dir_triggers" == "yes" ]; then
        echo "  Directory triggers:"
        echo "$frontmatter" | awk '/^directory_triggers:/,/^[a-z_]+:/ {if (!/^[a-z_]+:/) print "    " $0}'
      fi
      echo
    fi
  fi
done <<< "$GUIDANCE_FILES"

echo
echo "=== Summary ==="
echo "Total guidance files: $total"
echo "Files with triggers: $with_triggers"
echo "Files without triggers: $((total - with_triggers))"
