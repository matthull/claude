# /audit-guidance

## Purpose
Use Gemini's large context window to audit the guidance library against standards defined in README.md and apply fixes.

## Usage
```
/audit-guidance    # Run comprehensive audit using Gemini and apply recommended fixes
```

## Implementation
Leverages mcp__gemini-bridge for large-scale analysis of the entire guidance library.

## Process

### Step 1: Load Standards
```
# Read ~/.claude/guidance/README.md
# This contains all quality standards, size limits, and best practices
```

### Step 2: Audit via Gemini
Send to Gemini with large context:
- README.md as the evaluation criteria
- All guidance files for analysis
- Request comprehensive audit

Prompt structure:
```
Please audit this guidance library against the standards in README.md.

EVALUATION CRITERIA (from README.md):
[Full README content]

GUIDANCE LIBRARY FILES:
[All guidance module contents]

Provide:
1. Compliance assessment for each file
2. Specific issues found
3. Recommended fixes with concrete edits
4. Priority ranking of issues
```

### Step 3: Process Gemini's Recommendations
Gemini returns structured analysis:
- Files violating size constraints
- Content quality issues
- Redundancy and duplication
- Missing required elements
- Specific trimming suggestions

### Step 4: Apply Fixes
Based on Gemini's recommendations:
1. Trim verbose files using suggested edits
2. Remove redundant content
3. Fix structural issues
4. Update references

### Step 5: Validation
Re-run audit on modified files to confirm compliance.

## Example Implementation Flow

```
Loading standards from ~/.claude/guidance/README.md...

Sending to Gemini for analysis...
- 35 guidance files
- 15 bundle files  
- README.md standards

Gemini Analysis Complete:

CRITICAL ISSUES:
1. project-file-organization.md - 236 lines, verbose examples
   Recommendation: Remove lines 45-89 (redundant examples)
   
2. tdd-principles.md - Contains Ruby code samples
   Recommendation: Make language-agnostic
   
3. llm-development-principles.md - Duplicates README content
   Recommendation: Remove entirely

APPLYING FIXES...
✓ Trimmed project-file-organization.md (236→119 lines)
✓ Made tdd-principles.md language-agnostic
✓ Removed llm-development-principles.md
✓ Updated 3 references

Final audit shows full compliance with README.md standards.
```

## Benefits

1. **Intelligent Analysis** - LLM understands context and intent, not just mechanical rules
2. **Comprehensive** - Can analyze entire library at once with large context window
3. **Adaptive** - Automatically adapts to changes in README.md standards
4. **Accurate** - LLM can identify subtle issues like redundancy and poor structure
5. **Actionable** - Provides specific edit recommendations

## Key Advantages Over Mechanical Approach

- No need to hardcode specific checks
- Understands semantic redundancy, not just text duplication
- Can assess "conciseness" and "clarity" qualitatively
- Adapts to evolving standards in README.md
- Provides nuanced recommendations

This approach treats the audit like a code review, leveraging LLM intelligence rather than mechanical pattern matching.