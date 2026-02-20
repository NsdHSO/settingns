#!/usr/bin/env bash

# ============================================================================
# Git Advanced Tools Setup Script
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITCONFIG="$HOME/.gitconfig"

echo "🚀 Setting up Git Advanced Tools..."
echo ""

# Check if delta is installed
if ! command -v delta &> /dev/null; then
    echo "❌ git-delta is not installed"
    echo "   Install with: brew install git-delta"
    exit 1
else
    echo "✅ git-delta is installed"
fi

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "❌ fzf is not installed"
    echo "   Install with: brew install fzf"
    exit 1
else
    echo "✅ fzf is installed"
fi

# Check if fish functions are in place
echo ""
echo "📦 Checking Fish functions..."
if [ -f "$HOME/.config/fish/functions/gbr.fish" ]; then
    echo "✅ gbr.fish found"
else
    echo "❌ gbr.fish not found"
fi

if [ -f "$HOME/.config/fish/functions/gstash.fish" ]; then
    echo "✅ gstash.fish found"
else
    echo "❌ gstash.fish not found"
fi

if [ -f "$HOME/.config/fish/functions/gwt.fish" ]; then
    echo "✅ gwt.fish found"
else
    echo "❌ gwt.fish not found"
fi

# Check if git config is included
echo ""
echo "⚙️  Checking Git configuration..."

if grep -q "path = ~/.config/git/config" "$GITCONFIG" 2>/dev/null; then
    echo "✅ Git config already included in ~/.gitconfig"
elif grep -q "path = $HOME/.config/git/config" "$GITCONFIG" 2>/dev/null; then
    echo "✅ Git config already included in ~/.gitconfig"
else
    echo "⚠️  Git config not included in ~/.gitconfig"
    echo ""
    read -p "Would you like to add it now? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "" >> "$GITCONFIG"
        echo "[include]" >> "$GITCONFIG"
        echo "    path = ~/.config/git/config" >> "$GITCONFIG"
        echo "✅ Added to ~/.gitconfig"
    else
        echo "⏭️  Skipped. Add manually with:"
        echo "   echo '[include]' >> ~/.gitconfig"
        echo "   echo '    path = ~/.config/git/config' >> ~/.gitconfig"
    fi
fi

# Test delta
echo ""
echo "🧪 Testing delta..."
if echo -e "--- old\n+++ new\n@@ -1 +1 @@\n-old line\n+new line" | delta &> /dev/null; then
    echo "✅ Delta is working"
else
    echo "⚠️  Delta test failed (might work anyway)"
fi

echo ""
echo "=========================================="
echo "✨ Setup Complete!"
echo "=========================================="
echo ""
echo "New Functions Available:"
echo "  gbr      - Interactive branch switcher"
echo "  gstash   - Interactive stash manager"
echo "  gwt      - Git worktree helper"
echo ""
echo "Documentation:"
echo "  ~/.config/git/README.md - Full documentation"
echo "  ~/.config/git/QUICK_REFERENCE.md - Quick reference"
echo ""
echo "To reload fish functions:"
echo "  fish -c 'source ~/.config/fish/config.fish'"
echo ""
