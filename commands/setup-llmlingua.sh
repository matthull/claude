#!/bin/bash

echo "🚀 Setting up LLMLingua for guidance compression..."

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 not found. Please install Python 3.7+"
    exit 1
fi

# Check if pip is available
if ! command -v pip &> /dev/null; then
    echo "📦 Installing pip..."
    python3 -m ensurepip --user
fi

# Install LLMLingua
echo "📦 Installing LLMLingua..."
pip install --user llmlingua

# Install additional dependencies
echo "📦 Installing dependencies..."
pip install --user torch transformers nltk

# Test installation
echo "🧪 Testing LLMLingua installation..."
python3 -c "from llmlingua import PromptCompressor; print('✅ LLMLingua installed successfully')" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Setup complete!"
    echo ""
    echo "📝 To use LLMLingua compression:"
    echo "1. The hook will automatically run when editing guidance files"
    echo "2. Files over 200 lines will be compressed"
    echo "3. Review .compressed.md files and replace if satisfactory"
else
    echo "❌ Installation failed. Please check the error messages above."
    exit 1
fi