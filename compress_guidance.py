#!/usr/bin/env python3
"""
Compress guidance files using LLMLingua with preservation of markdown structure.
"""
import os
import sys
from llmlingua import PromptCompressor

def compress_guidance_file(file_path, target_ratio=0.5):
    """Compress guidance file using LLMLingua with markdown-aware settings."""

    # Read the original file
    with open(file_path, 'r', encoding='utf-8') as f:
        original_content = f.read()

    # Initialize the compressor
    llm_lingua = PromptCompressor(
        model_name="microsoft/llmlingua-2-bert-base-multilingual-cased",
        use_llmlingua2=True
    )

    # Define force tokens to preserve markdown structure
    force_tokens = [
        '\n', '#', '-', '*', '`', '```',
        '**', '__', '|', '>', '[', ']', '(', ')',
        'md', 'bash', 'markdown', 'yaml', 'json'
    ]

    # Compress the content
    compressed_result = llm_lingua.compress_prompt(
        original_content,
        target_token=int(len(original_content.split()) * target_ratio),
        condition_compare=True,
        condition_in_question="guidance",
        rank_method="longllmlingua",
        use_sentence_level_filter=False,
        use_context_level_filter=True,
        use_token_level_filter=True,
        keep_split=True,
        keep_first_sentence=3,
        keep_last_sentence=1,
        keep_sentence_number=5,
        high_priority_bonus=100,
        context_budget="+100",
        token_budget_ratio=target_ratio,
        force_tokens=force_tokens,
        drop_consecutive=True
    )

    compressed_content = compressed_result['compressed_prompt']

    # Calculate statistics
    original_words = len(original_content.split())
    compressed_words = len(compressed_content.split())
    original_lines = len(original_content.splitlines())
    compressed_lines = len(compressed_content.splitlines())

    stats = {
        'original_words': original_words,
        'compressed_words': compressed_words,
        'original_lines': original_lines,
        'compressed_lines': compressed_lines,
        'word_ratio': compressed_words / original_words,
        'line_ratio': compressed_lines / original_lines,
        'compression_ratio': compressed_result.get('ratio', compressed_words / original_words)
    }

    return compressed_content, stats

def main():
    file_path = "/home/matt/.claude/guidance/documentation/task-handoff-creation.md"

    print(f"Compressing: {file_path}")

    # Create backup
    backup_path = file_path.replace('.md', '.original.md')
    with open(file_path, 'r') as original, open(backup_path, 'w') as backup:
        backup.write(original.read())
    print(f"Backup created: {backup_path}")

    # Compress the file
    compressed_content, stats = compress_guidance_file(file_path, target_ratio=0.5)

    # Write compressed version
    compressed_path = file_path.replace('.md', '.compressed.md')
    with open(compressed_path, 'w', encoding='utf-8') as f:
        f.write(compressed_content)

    # Print statistics
    print("\n=== COMPRESSION STATISTICS ===")
    print(f"Original words: {stats['original_words']}")
    print(f"Compressed words: {stats['compressed_words']}")
    print(f"Word reduction: {(1 - stats['word_ratio']) * 100:.1f}%")
    print(f"Original lines: {stats['original_lines']}")
    print(f"Compressed lines: {stats['compressed_lines']}")
    print(f"Line reduction: {(1 - stats['line_ratio']) * 100:.1f}%")
    print(f"Compression ratio: {stats['compression_ratio']:.3f}")
    print(f"\nCompressed file created: {compressed_path}")

    return stats

if __name__ == "__main__":
    main()