#!/usr/bin/env fish
# Installation script for context-aware completions
# Run this script to install Fisher plugins and set up completions

set_color cyan
echo "======================================"
echo "Context-Aware Completions Installer"
echo "======================================"
set_color normal

# Check if Fisher is installed
if not functions -q fisher
    set_color red
    echo "❌ Fisher is not installed!"
    set_color yellow
    echo "Installing Fisher..."
    set_color normal
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    if test $status -eq 0
        set_color green
        echo "✅ Fisher installed successfully!"
        set_color normal
    else
        set_color red
        echo "❌ Failed to install Fisher"
        set_color normal
        exit 1
    end
else
    set_color green
    echo "✅ Fisher is already installed"
    set_color normal
end

# Install fish-abbreviation-tips
set_color cyan
echo ""
echo "📦 Installing fish-abbreviation-tips..."
set_color normal

if fisher list | grep -q "gazorby/fish-abbreviation-tips"
    set_color yellow
    echo "⚠️  fish-abbreviation-tips is already installed"
    set_color normal
else
    fisher install gazorby/fish-abbreviation-tips
    if test $status -eq 0
        set_color green
        echo "✅ fish-abbreviation-tips installed!"
        set_color normal
    else
        set_color red
        echo "❌ Failed to install fish-abbreviation-tips"
        set_color normal
    end
end

# Install pisces (auto-pair brackets)
set_color cyan
echo ""
echo "📦 Installing pisces (auto-pair brackets)..."
set_color normal

if fisher list | grep -q "laughedelic/pisces"
    set_color yellow
    echo "⚠️  pisces is already installed"
    set_color normal
else
    fisher install laughedelic/pisces
    if test $status -eq 0
        set_color green
        echo "✅ pisces installed!"
        set_color normal
    else
        set_color red
        echo "❌ Failed to install pisces"
        set_color normal
    end
end

# Verify completions directory
set_color cyan
echo ""
echo "🔍 Verifying completions directory..."
set_color normal

if test -d "$__fish_config_dir/completions"
    set -l completion_count (count $__fish_config_dir/completions/*.fish)
    set_color green
    echo "✅ Completions directory exists with $completion_count completion files"
    set_color normal
else
    set_color red
    echo "❌ Completions directory not found"
    set_color normal
end

# List installed custom completions
set_color cyan
echo ""
echo "📋 Custom completions installed:"
set_color normal
for completion in $__fish_config_dir/completions/*.fish
    set -l basename (basename $completion .fish)
    set_color green
    echo "  ✓ $basename"
    set_color normal
end

# Check for kubectl
set_color cyan
echo ""
echo "🔍 Checking for additional tools..."
set_color normal

if command -q kubectl
    set_color green
    echo "  ✓ kubectl (completions enabled)"
    set_color normal
else
    set_color yellow
    echo "  ⚠️  kubectl not found"
    set_color normal
end

if command -q docker
    set_color green
    echo "  ✓ docker (completions enabled)"
    set_color normal
else
    set_color yellow
    echo "  ⚠️  docker not found"
    set_color normal
end

if command -q gh
    set_color green
    echo "  ✓ gh (GitHub CLI completions enabled)"
    set_color normal
else
    set_color yellow
    echo "  ⚠️  gh not found"
    set_color normal
end

# Final message
set_color cyan
echo ""
echo "======================================"
echo "Installation Complete!"
echo "======================================"
set_color yellow
echo ""
echo "💡 Reload your shell to activate completions:"
echo "   exec fish"
echo ""
echo "💡 Try typing these commands and press TAB:"
echo "   nxg [TAB]"
echo "   killport [TAB]"
echo "   gc [TAB]"
echo "   gip [TAB]"
set_color normal
