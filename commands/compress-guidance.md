# Compress Guidance with LLMLingua

Intelligently compress guidance files using Microsoft's LLMLingua based on flexible criteria.

## Usage

```
/compress-guidance [criteria] [options]
```

## Examples

```bash
# Compress all guidance files over 200 lines
/compress-guidance large files

# Compress unstaged files in git
/compress-guidance unstaged files

# Compress specific files
/compress-guidance therapy/ifs-self-therapy.md documentation/requirements.md

# Compress all files in a category
/compress-guidance all files in documentation/

# Compress with custom compression ratio
/compress-guidance large files --ratio 0.3
```

## Implementation

Delegates to Task tool with LLMLingua compression capabilities.

## Subagent Prompt Template

You are a guidance compression specialist using Microsoft's LLMLingua to intelligently compress verbose guidance files. Follow these principles:

@~/.claude/guidance/ai-development/ultra-concise-enforcement.md

User Request: [USER PROVIDED CONTENT]

Process:
1. **Parse the compression criteria** from user input:
   - "large files" = files >200 lines
   - "unstaged files" = files modified but not staged in git
   - "all files in X/" = files in specific directory
   - File paths = specific files
   - "all files" = every guidance file

2. **Find matching files** using appropriate search:
   - Use Bash + find/git commands to locate files
   - Check line counts with wc -l
   - Filter based on criteria

3. **For each file to compress**:
   - Load LLMLingua Python environment
   - Run compression with preservation of markdown structure
   - Create .original.md backup
   - Create .compressed.md version
   - Show compression stats

4. **Report results**:
   - List of files processed
   - Compression ratios achieved
   - Instructions for reviewing and applying

5. **Provide next steps**:
   - Commands to review compressed versions
   - Commands to apply if satisfactory
   - How to revert if needed

Compression Settings:
- Target ratio: 0.5 (50% reduction) unless --ratio specified
- Preserve: markdown structure, code blocks, lists
- Force tokens: \n, #, -, *, `
- Use LLMLingua-2 for better quality

Safety:
- Always backup originals
- Never overwrite without user confirmation
- Skip if LLMLingua not installed (provide setup instructions)
- Handle file not found gracefully

Expected Output:
- Clear summary of files found and compressed
- Compression statistics
- Review and apply instructions