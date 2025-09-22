# Claude Code Python Environment
export CLAUDE_PYTHON_ENV="$HOME/.claude/python-env"
export CLAUDE_PYTHON="$CLAUDE_PYTHON_ENV/bin/python"

# Add Claude Python to PATH if not already there
if [[ ":$PATH:" != *":$CLAUDE_PYTHON_ENV/bin:"* ]]; then
    export PATH="$CLAUDE_PYTHON_ENV/bin:$PATH"
fi

# Function to run Claude Python scripts
claude-python() {
    "$CLAUDE_PYTHON" "$@"
}
