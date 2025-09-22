#!/bin/bash

# Hook script to validate guidance file conciseness
# Runs when files are created/edited by Claude Code

# Get the file path from the hook environment
# Claude Code passes tool parameters in CLAUDE_HOOK_PARAMS
FILE_PATH=$(echo "$CLAUDE_HOOK_PARAMS" | jq -r '.file_path // empty' 2>/dev/null)

# If not found in params, check for first argument
if [ -z "$FILE_PATH" ]; then
    FILE_PATH="$1"
fi

# Exit if no file path
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Check if file is in a guidance directory and is markdown
if [[ ! "$FILE_PATH" =~ /guidance/ ]] || [[ ! "$FILE_PATH" =~ \.md$ ]]; then
    exit 0  # Not a guidance file, skip validation
fi

# Skip validation for README.md and enforcement file
if [[ "$FILE_PATH" =~ README\.md$ ]] || [[ "$FILE_PATH" =~ ultra-concise-enforcement\.md$ ]]; then
    exit 0
fi

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Quick validation checks
LINES=$(wc -l < "$FILE_PATH" 2>/dev/null || echo 0)
FAILED=0
ISSUES=""

# Check line count
if [ $LINES -gt 200 ]; then
    ISSUES="${ISSUES}❌ File exceeds 200 lines (current: $LINES)\n"
    FAILED=1
elif [ $LINES -gt 150 ]; then
    ISSUES="${ISSUES}⚠️  File is lengthy (current: $LINES lines, recommended: <150)\n"
fi

# Check for forbidden patterns
FORBIDDEN=(
    "## Benefits"
    "## Why"
    "This helps"
    "This improves"
    "It's important to"
    "You should consider"
    "It's recommended"
)

for pattern in "${FORBIDDEN[@]}"; do
    if grep -q "$pattern" "$FILE_PATH" 2>/dev/null; then
        ISSUES="${ISSUES}❌ Contains forbidden pattern: '$pattern'\n"
        FAILED=1
    fi
done

# Check for verbose language
if grep -qE "consider using|might be|could help|should think about" "$FILE_PATH" 2>/dev/null; then
    ISSUES="${ISSUES}⚠️  Contains verbose hedging language\n"
fi

# If validation failed, provide directives
if [ $FAILED -eq 1 ] || [ -n "$ISSUES" ]; then
    echo -e "\n${RED}━━━ GUIDANCE CONCISENESS VALIDATION ━━━${NC}"
    echo -e "File: $(basename "$FILE_PATH")"
    echo -e "\n${ISSUES}"

    if [ $FAILED -eq 1 ]; then
        echo -e "${RED}REQUIRED FIXES:${NC}"
        echo "1. DELETE all 'Benefits' and 'Why' sections"
        echo "2. REMOVE explanatory text (This helps..., It's important...)"
        echo "3. REPLACE hedging language with imperatives (MUST/NEVER)"
        echo "4. CUT file to under 200 lines"
        echo ""
        echo "Apply these rules from: @~/.claude/guidance/ai-development/ultra-concise-enforcement.md"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

        # Block the operation
        exit 1
    else
        echo -e "${YELLOW}Consider applying ultra-concise enforcement for better clarity.${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    fi
fi

exit 0