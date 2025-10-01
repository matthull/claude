# /validate-guidance

## Purpose
Scan the guidance library for broken @-references and report them.

## Usage
```
/validate-guidance    # List all broken @-references in guidance files
```

## Output Format
Returns a list of broken links in the format:
```
path/to/file.md: @broken/reference.md
```

Each line shows:
- The file containing the broken reference (relative to ~/.claude/guidance/)
- The @-reference that points to a non-existent file

## Implementation
Uses a shell script to:
1. Find all markdown files in ~/.claude/guidance/
2. Extract @-references using grep
3. Skip commented-out references
4. Validate each reference path
5. Report any that point to non-existent files