#!/bin/bash
# Wrapper script to run Python hook with Claude environment

# Source the Claude Python environment
CLAUDE_PYTHON="$HOME/.claude/python-env/bin/python"

# Check if the environment exists
if [ ! -f "$CLAUDE_PYTHON" ]; then
    echo "⚠️  Claude Python environment not found. Run: ~/.claude/commands/setup-claude-python-env.sh"
    exit 0
fi

# Run the Python script with the Claude environment
"$CLAUDE_PYTHON" "$HOME/.claude/commands/compress-guidance-hook.py" "$@"