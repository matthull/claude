#!/usr/bin/env bash
# Search guidance files by tag
# Usage: guidance-tag-search.sh <tag-name>

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: guidance-tag-search.sh <tag-name>"
    echo "Example: guidance-tag-search.sh backend"
    exit 1
fi

TAG="$1"
GUIDANCE_DIR="$HOME/.claude/guidance"
PROJECT_GUIDANCE_DIR=".claude/guidance"

python3 << EOF
import os
import re
import yaml
from pathlib import Path

tag = "$TAG"
guidance_dir = Path("$GUIDANCE_DIR")
project_guidance_dir = Path("$PROJECT_GUIDANCE_DIR")

matches = []

# Search global guidance
if guidance_dir.exists():
    for md_file in guidance_dir.rglob("*.md"):
        if md_file.name == "README.md":
            continue

        try:
            with open(md_file, 'r') as f:
                content = f.read()

            match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
            if not match:
                continue

            frontmatter = yaml.safe_load(match.group(1))
            tags = frontmatter.get('tags', [])

            if tag in tags:
                rel_path = md_file.relative_to(guidance_dir)
                matches.append((str(rel_path), "global"))
        except Exception as e:
            pass

# Search project guidance
if project_guidance_dir.exists():
    for md_file in project_guidance_dir.rglob("*.md"):
        if md_file.name == "README.md":
            continue

        try:
            with open(md_file, 'r') as f:
                content = f.read()

            match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
            if not match:
                continue

            frontmatter = yaml.safe_load(match.group(1))
            tags = frontmatter.get('tags', [])

            if tag in tags:
                rel_path = md_file.relative_to(project_guidance_dir)
                matches.append((str(rel_path), "project"))
        except Exception as e:
            pass

if matches:
    print(f"Guidance modules tagged with '{tag}':\n")
    for i, (path, scope) in enumerate(sorted(matches), 1):
        print(f"{i}. {path} ({scope})")
else:
    print(f"No guidance modules found with tag '{tag}'")
EOF
