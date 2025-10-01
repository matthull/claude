#!/bin/bash
# Validate all @-references in the guidance library

GUIDANCE_DIR="$HOME/.claude/guidance"
BROKEN_LINKS=""

# Find all markdown files
find "$GUIDANCE_DIR" -name "*.md" -type f | while read -r file; do
    # Extract @-references from the file
    grep -o '@[^[:space:]]*\.md' "$file" 2>/dev/null | while read -r ref; do
        # Skip if reference is commented out
        if grep "^#.*$ref" "$file" > /dev/null 2>&1 || \
           grep "<!--.*$ref.*-->" "$file" > /dev/null 2>&1; then
            continue
        fi

        # Skip example references (containing placeholders)
        if [[ "$ref" == *"category"* ]] || [[ "$ref" == *"module"* ]] || \
           [[ "$ref" == *"layer"* ]] || [[ "$ref" == *"bundle-name"* ]] || \
           [[ "$ref" == *"relevant-module"* ]]; then
            continue
        fi

        # Skip references in code blocks or inline code
        if grep "\`$ref\`" "$file" > /dev/null 2>&1; then
            continue
        fi

        # Determine the target path
        if [[ "$ref" == "@~/"* ]]; then
            # Absolute reference
            target_path="${ref#@}"
            target_path="$HOME/${target_path#\~/}"
        elif [[ "$ref" == "@../"* ]]; then
            # Relative reference
            dir=$(dirname "$file")
            target_path="$dir/${ref#@}"
            target_path=$(realpath "$target_path" 2>/dev/null || echo "$target_path")
        elif [[ "$ref" == "@.claude/"* ]]; then
            # Project reference (for this context, same as home)
            target_path="$HOME/${ref#@}"
        else
            # Skip other patterns
            continue
        fi

        # Check if target exists
        if [[ ! -f "$target_path" ]]; then
            relative_file="${file#$GUIDANCE_DIR/}"
            echo "$relative_file: $ref"
        fi
    done
done | sort -u