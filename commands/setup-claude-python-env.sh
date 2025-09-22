#!/bin/bash

echo "🚀 Setting up global Python environment for Claude Code hooks..."

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "📦 Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Create a dedicated virtual environment for Claude Code
CLAUDE_VENV_DIR="$HOME/.claude/python-env"

echo "🐍 Creating Claude Code Python environment at $CLAUDE_VENV_DIR..."
uv venv "$CLAUDE_VENV_DIR"

# Install packages in the Claude environment
echo "📦 Installing LLMLingua and dependencies..."
uv pip install --python "$CLAUDE_VENV_DIR" llmlingua torch transformers nltk

# Create activation script for zshrc
echo "📝 Creating activation script..."
cat > "$HOME/.claude/activate-env.sh" << 'EOF'
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
EOF

# Add to .zshrc if not already present
if ! grep -q "claude/activate-env.sh" "$HOME/.zshrc" 2>/dev/null; then
    echo "" >> "$HOME/.zshrc"
    echo "# Claude Code Python Environment" >> "$HOME/.zshrc"
    echo "[ -f \"\$HOME/.claude/activate-env.sh\" ] && source \"\$HOME/.claude/activate-env.sh\"" >> "$HOME/.zshrc"
    echo "✅ Added to .zshrc"
else
    echo "✅ Already in .zshrc"
fi

# Test the environment
echo "🧪 Testing environment..."
"$CLAUDE_VENV_DIR/bin/python" -c "from llmlingua import PromptCompressor; print('✅ LLMLingua available')" 2>/dev/null

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Setup complete!"
    echo ""
    echo "📝 Next steps:"
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. Update hook scripts to use: \$CLAUDE_PYTHON or claude-python"
    echo "3. Restart Claude Code to pick up the new settings"
else
    echo "❌ Failed to verify LLMLingua installation"
    exit 1
fi