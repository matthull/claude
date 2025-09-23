#!/usr/bin/env python3
"""
CLI tool for compressing guidance files using Microsoft's LLMLingua
"""

import argparse
import sys
import os
from pathlib import Path
import subprocess

def check_llmlingua():
    """Check if LLMLingua is installed"""
    try:
        from llmlingua import PromptCompressor
        return True
    except ImportError:
        print("❌ LLMLingua not installed")
        print("Run: ~/.claude/commands/setup-claude-python-env.sh")
        return False

def find_large_files(min_lines=200):
    """Find guidance files over specified line count"""
    files = []
    guidance_dir = Path.home() / '.claude' / 'guidance'

    for md_file in guidance_dir.rglob('*.md'):
        if 'README.md' in md_file.name or 'ultra-concise-enforcement.md' in md_file.name:
            continue
        try:
            with open(md_file) as f:
                lines = sum(1 for _ in f)
                if lines >= min_lines:
                    files.append((md_file, lines))
        except:
            continue

    return sorted(files, key=lambda x: x[1], reverse=True)

def find_unstaged_files():
    """Find modified but unstaged guidance files"""
    try:
        result = subprocess.run(
            ['git', 'diff', '--name-only', '*.md'],
            cwd=Path.home() / '.claude' / 'guidance',
            capture_output=True,
            text=True
        )
        files = []
        for line in result.stdout.splitlines():
            if line.endswith('.md'):
                path = Path.home() / '.claude' / 'guidance' / line
                if path.exists():
                    with open(path) as f:
                        lines = sum(1 for _ in f)
                    files.append((path, lines))
        return files
    except:
        return []

def find_files_in_dir(directory):
    """Find all markdown files in specified directory"""
    files = []
    base_path = Path.home() / '.claude' / 'guidance'
    dir_path = base_path / directory

    if not dir_path.exists():
        print(f"❌ Directory not found: {directory}")
        return []

    for md_file in dir_path.rglob('*.md'):
        if 'README.md' not in md_file.name:
            with open(md_file) as f:
                lines = sum(1 for _ in f)
            files.append((md_file, lines))

    return files

def compress_file(file_path, target_ratio=0.5):
    """Compress a single file using LLMLingua"""
    from llmlingua import PromptCompressor

    # Read file
    with open(file_path, 'r') as f:
        content = f.read()

    lines = content.count('\n')

    # Extract frontmatter
    frontmatter = ""
    main_content = content
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            frontmatter = f"---{parts[1]}---\n"
            main_content = parts[2]

    # Initialize compressor
    print(f"  Initializing compressor...")
    llm_lingua = PromptCompressor(
        model_name="microsoft/llmlingua-2-bert-base-multilingual-cased-meetingbank",
        use_llmlingua2=True,
        device_map="cpu"
    )

    # Compress
    try:
        compressed = llm_lingua.compress_prompt(
            main_content,
            rate=target_ratio,
            force_tokens=['\n', '#', '-', '*', '`', '##', '###'],
            drop_consecutive=True
        )

        compressed_content = frontmatter + compressed['compressed_prompt']
        compressed_lines = compressed_content.count('\n')

        # Save files
        backup_path = file_path.parent / f"{file_path.stem}.original{file_path.suffix}"
        compressed_path = file_path.parent / f"{file_path.stem}.compressed{file_path.suffix}"

        with open(backup_path, 'w') as f:
            f.write(content)

        with open(compressed_path, 'w') as f:
            f.write(compressed_content)

        return {
            'success': True,
            'original_lines': lines,
            'compressed_lines': compressed_lines,
            'ratio': compressed.get('ratio', 2.0) if isinstance(compressed.get('ratio'), (int, float)) else 2.0,
            'backup_path': backup_path,
            'compressed_path': compressed_path
        }

    except Exception as e:
        return {
            'success': False,
            'error': str(e)
        }

def main():
    parser = argparse.ArgumentParser(
        description='Compress guidance files using LLMLingua',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  compress-guidance-cli.py --large              # Compress files >200 lines
  compress-guidance-cli.py --large --min 300    # Files >300 lines
  compress-guidance-cli.py file1.md file2.md    # Specific files
  compress-guidance-cli.py --dir documentation  # All files in directory
  compress-guidance-cli.py --unstaged           # Unstaged git files
  compress-guidance-cli.py --ratio 0.3 --large  # Custom compression ratio
        """
    )

    parser.add_argument('files', nargs='*', help='Specific files to compress')
    parser.add_argument('--large', action='store_true', help='Find large files (>200 lines)')
    parser.add_argument('--min', type=int, default=200, help='Minimum lines for --large (default: 200)')
    parser.add_argument('--dir', help='Compress all files in directory')
    parser.add_argument('--unstaged', action='store_true', help='Compress unstaged git files')
    parser.add_argument('--ratio', type=float, default=0.5, help='Target compression ratio (default: 0.5)')
    parser.add_argument('--dry-run', action='store_true', help='Show what would be compressed without doing it')

    args = parser.parse_args()

    if not check_llmlingua() and not args.dry_run:
        sys.exit(1)

    # Gather files to compress
    files_to_compress = []

    if args.files:
        for f in args.files:
            path = Path(f).resolve()
            if path.exists():
                with open(path) as file:
                    lines = sum(1 for _ in file)
                files_to_compress.append((path, lines))

    if args.large:
        files_to_compress.extend(find_large_files(args.min))

    if args.unstaged:
        files_to_compress.extend(find_unstaged_files())

    if args.dir:
        files_to_compress.extend(find_files_in_dir(args.dir))

    # Remove duplicates
    seen = set()
    unique_files = []
    for file_path, lines in files_to_compress:
        if file_path not in seen:
            seen.add(file_path)
            unique_files.append((file_path, lines))

    if not unique_files:
        print("No files found matching criteria")
        sys.exit(0)

    # Sort by size
    unique_files.sort(key=lambda x: x[1], reverse=True)

    print(f"\n📋 Found {len(unique_files)} file(s) to compress:")
    for file_path, lines in unique_files:
        print(f"  • {file_path.name} ({lines} lines)")

    if args.dry_run:
        print("\n🔍 Dry run - no files will be compressed")
        sys.exit(0)

    # Compress files
    print(f"\n🚀 Compressing with ratio {args.ratio}...")
    results = []

    for file_path, original_lines in unique_files:
        print(f"\n📄 Processing {file_path.name}...")
        result = compress_file(file_path, args.ratio)
        results.append((file_path, result))

        if result['success']:
            reduction = ((result['original_lines'] - result['compressed_lines'])
                        / result['original_lines'] * 100)
            print(f"  ✅ Compressed: {result['original_lines']} → {result['compressed_lines']} lines")
            print(f"  📊 Reduction: {reduction:.1f}% ({result['ratio']:.1f}x)")
        else:
            print(f"  ❌ Failed: {result['error']}")

    # Summary
    print("\n📊 Summary:")
    successful = [r for _, r in results if r['success']]
    print(f"  ✅ Successfully compressed: {len(successful)}/{len(results)}")

    if successful:
        print("\n📝 Next steps:")
        print("  Review compressed versions:")
        for file_path, result in results:
            if result['success']:
                print(f"    diff {result['backup_path']} {result['compressed_path']}")

        print("\n  If satisfied, replace originals:")
        for file_path, result in results:
            if result['success']:
                print(f"    mv {result['compressed_path']} {file_path}")

        print("\n  To revert:")
        for file_path, result in results:
            if result['success']:
                print(f"    mv {result['backup_path']} {file_path}")

if __name__ == '__main__':
    main()