#!/usr/bin/env python3
"""
Markdown to PDF converter with dark mode support.
Uses pandoc with WeasyPrint for high-quality PDF output.
"""

import argparse
import subprocess
import sys
from pathlib import Path


def get_skill_dir() -> Path:
    """Get the skill directory containing assets."""
    return Path(__file__).parent.parent


def convert_md_to_pdf(
    input_file: str,
    output_file: str | None = None,
    dark_mode: bool = True,
    css_file: str | None = None,
) -> Path:
    """
    Convert a markdown file to PDF.

    Args:
        input_file: Path to the input markdown file
        output_file: Path for the output PDF (defaults to input with .pdf extension)
        dark_mode: Use dark mode theme (default: True)
        css_file: Custom CSS file path (overrides dark_mode setting)

    Returns:
        Path to the generated PDF file
    """
    input_path = Path(input_file).expanduser().resolve()

    if not input_path.exists():
        raise FileNotFoundError(f"Input file not found: {input_path}")

    if output_file:
        output_path = Path(output_file).expanduser().resolve()
    else:
        output_path = input_path.with_suffix('.pdf')

    # Determine CSS file
    if css_file:
        css_path = Path(css_file).expanduser().resolve()
    else:
        skill_dir = get_skill_dir()
        css_name = 'dark-mode.css' if dark_mode else 'light-mode.css'
        css_path = skill_dir / 'assets' / css_name

    if not css_path.exists():
        raise FileNotFoundError(f"CSS file not found: {css_path}")

    # Build pandoc command
    cmd = [
        'pandoc',
        str(input_path),
        '-o', str(output_path),
        '--pdf-engine=weasyprint',
        f'--css={css_path}',
        '--standalone',
        '--from=markdown+emoji',
        '--metadata', 'title=',  # Suppress auto-title
    ]

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=True,
        )
        if result.stderr:
            # WeasyPrint often outputs warnings, only show if verbose
            pass
        return output_path
    except subprocess.CalledProcessError as e:
        print(f"Error converting file: {e.stderr}", file=sys.stderr)
        raise
    except FileNotFoundError:
        print("Error: pandoc or weasyprint not found. Install with:", file=sys.stderr)
        print("  sudo pacman -S pandoc python-weasyprint", file=sys.stderr)
        raise


def main():
    parser = argparse.ArgumentParser(
        description='Convert Markdown to PDF with dark mode support',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s document.md                    # Dark mode PDF (default)
  %(prog)s document.md -o output.pdf      # Specify output file
  %(prog)s document.md --light            # Light mode PDF
  %(prog)s document.md --css custom.css   # Custom CSS
        """,
    )

    parser.add_argument('input', help='Input markdown file')
    parser.add_argument('-o', '--output', help='Output PDF file (default: input.pdf)')
    parser.add_argument(
        '--light',
        action='store_true',
        help='Use light mode instead of dark mode',
    )
    parser.add_argument(
        '--css',
        help='Path to custom CSS file (overrides --light)',
    )

    args = parser.parse_args()

    try:
        output_path = convert_md_to_pdf(
            input_file=args.input,
            output_file=args.output,
            dark_mode=not args.light,
            css_file=args.css,
        )
        print(f"Created: file://{output_path}")
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
