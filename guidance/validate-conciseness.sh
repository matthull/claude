#!/bin/bash

# Ultra-Concise Guidance Validator
# Enforces guidance conciseness rules

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

FAILED=0
WARNINGS=0

echo "🔍 Validating guidance conciseness..."
echo

# Check for files over line limits
echo "📏 Checking line counts..."
while IFS= read -r file; do
    lines=$(wc -l < "$file")
    filename=$(basename "$file")

    if [ $lines -gt 200 ]; then
        echo -e "${RED}✗ $filename: $lines lines (MAX: 200)${NC}"
        FAILED=$((FAILED + 1))
    elif [ $lines -gt 150 ]; then
        echo -e "${YELLOW}⚠ $filename: $lines lines (consider reducing)${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
done < <(find ~/.claude/guidance -name "*.md" -type f ! -name "README.md")

echo

# Check for forbidden patterns (excluding enforcement file)
echo "🚫 Checking for forbidden content..."
PATTERNS=(
    "## Benefits"
    "## Why"
    "This helps"
    "This improves"
    "It's important to"
    "You should consider"
    "You might want to"
    "could be useful"
    "It's recommended"
    "Try to avoid"
)

for pattern in "${PATTERNS[@]}"; do
    results=$(grep -l "$pattern" ~/.claude/guidance/**/*.md 2>/dev/null | grep -v "ultra-concise-enforcement.md")
    if [ -n "$results" ]; then
        echo -e "${RED}✗ Found '$pattern' in:${NC}"
        echo "$results" | while read -r file; do
            echo "  - $(basename "$file")"
            FAILED=$((FAILED + 1))
        done
    fi
done

echo

# Check for verbose language
echo "🔤 Checking for verbose language..."
VERBOSE=(
    "consider using"
    "might be"
    "could help"
    "should think about"
    "want to make sure"
    "important to understand"
)

for pattern in "${VERBOSE[@]}"; do
    count=$(grep -r "$pattern" ~/.claude/guidance --include="*.md" 2>/dev/null | wc -l)
    if [ $count -gt 0 ]; then
        echo -e "${YELLOW}⚠ Found $count instances of '$pattern'${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
done

echo
echo "📊 Summary:"
echo "─────────────────────"

if [ $FAILED -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    exit 0
else
    [ $FAILED -gt 0 ] && echo -e "${RED}❌ Failed: $FAILED critical issues${NC}"
    [ $WARNINGS -gt 0 ] && echo -e "${YELLOW}⚠️  Warnings: $WARNINGS improvements suggested${NC}"
    echo
    echo "Fix critical issues and run again."
    exit 1
fi