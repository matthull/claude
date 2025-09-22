#!/usr/bin/env python3
"""
LLMLingua Guidance Compression Hook for Claude Code
Compresses guidance files using Microsoft's LLMLingua when they exceed size limits
"""

import sys
import json
import os
from pathlib import Path

def check_llmlingua_installed():
    """Check if LLMLingua is installed"""
    try:
        from llmlingua import PromptCompressor
        return True
    except ImportError:
        print("⚠️  LLMLingua not installed. Install with: pip install llmlingua")
        return False

def compress_guidance(file_path, target_ratio=0.5):
    """Compress guidance file content using LLMLingua"""
    if not check_llmlingua_installed():
        return None

    from llmlingua import PromptCompressor

    # Read the file
    with open(file_path, 'r') as f:
        content = f.read()

    # Skip if file is already small
    lines = content.count('\n')
    if lines < 150:
        return None

    # Initialize compressor
    llm_lingua = PromptCompressor(
        model_name="microsoft/llmlingua-2-bert-base-multilingual-cased-meetingbank",
        use_llmlingua2=True,  # Use the latest version
        device_map="cpu"  # Use CPU for compatibility
    )

    # Extract frontmatter and content
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            frontmatter = f"---{parts[1]}---\n"
            main_content = parts[2]
        else:
            frontmatter = ""
            main_content = content
    else:
        frontmatter = ""
        main_content = content

    # Compress the main content
    try:
        compressed = llm_lingua.compress_prompt(
            main_content,
            rate=target_ratio,  # Compression ratio
            force_tokens=['\n', '#', '-', '*', '`'],  # Preserve markdown structure
            drop_consecutive=True
        )

        compressed_content = compressed['compressed_prompt']
        original_tokens = compressed['origin_tokens']
        compressed_tokens = compressed['compressed_tokens']
        ratio = compressed['ratio']

        print(f"✨ LLMLingua Compression Results:")
        print(f"   Original: {original_tokens} tokens ({lines} lines)")
        print(f"   Compressed: {compressed_tokens} tokens")
        print(f"   Ratio: {ratio:.1f}x reduction")

        # Return compressed version with frontmatter
        return frontmatter + compressed_content

    except Exception as e:
        print(f"❌ Compression failed: {e}")
        return None

def main():
    """Main hook function"""
    # Get file path from hook environment
    params = os.environ.get('CLAUDE_HOOK_PARAMS', '{}')
    try:
        params_dict = json.loads(params)
        file_path = params_dict.get('file_path')
    except:
        file_path = sys.argv[1] if len(sys.argv) > 1 else None

    if not file_path:
        sys.exit(0)

    # Check if it's a guidance file
    if '/guidance/' not in file_path or not file_path.endswith('.md'):
        sys.exit(0)

    # Skip README and enforcement files
    if 'README.md' in file_path or 'ultra-concise-enforcement.md' in file_path:
        sys.exit(0)

    # Check file size
    with open(file_path, 'r') as f:
        lines = sum(1 for _ in f)

    if lines > 200:
        print(f"\n📊 File has {lines} lines (limit: 200)")
        print("🔬 Attempting LLMLingua compression...")

        compressed = compress_guidance(file_path)
        if compressed:
            # Save compressed version
            backup_path = file_path.replace('.md', '.original.md')
            compressed_path = file_path.replace('.md', '.compressed.md')

            # Save original as backup
            with open(file_path, 'r') as f:
                original = f.read()
            with open(backup_path, 'w') as f:
                f.write(original)

            # Save compressed version
            with open(compressed_path, 'w') as f:
                f.write(compressed)

            print(f"\n💾 Saved:")
            print(f"   Original: {backup_path}")
            print(f"   Compressed: {compressed_path}")
            print(f"\n💡 Review compressed version and replace if satisfactory:")
            print(f"   mv {compressed_path} {file_path}")

            # Don't block the operation, just inform
            print("\n⚠️  File exceeds 200 lines but compression available above")

if __name__ == "__main__":
    main()