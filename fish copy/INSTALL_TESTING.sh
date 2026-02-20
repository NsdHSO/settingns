#!/bin/bash

# Fish Function Testing Framework Installation Script
# Run this script to install and verify the testing framework

echo "================================================"
echo "Fish Function Testing Framework Installation"
echo "================================================"
echo ""

# Check if fish is installed
if ! command -v fish &> /dev/null; then
    echo "❌ Error: Fish shell is not installed!"
    echo "Install it from: https://fishshell.com/"
    exit 1
fi

echo "✅ Fish shell is installed"
fish --version
echo ""

# Check if fisher is installed
if ! fish -c "type -q fisher" 2>/dev/null; then
    echo "⚠️  Fisher is not installed"
    echo "Installing Fisher..."
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

    if [ $? -eq 0 ]; then
        echo "✅ Fisher installed successfully"
    else
        echo "❌ Failed to install Fisher"
        exit 1
    fi
else
    echo "✅ Fisher is already installed"
fi

echo ""

# Install fishtape
echo "Installing Fishtape testing framework..."
fish -c "fisher install jorgebucaran/fishtape"

if [ $? -eq 0 ]; then
    echo "✅ Fishtape installed successfully"
else
    echo "❌ Failed to install Fishtape"
    exit 1
fi

echo ""

# Verify installation
echo "Verifying installation..."
if fish -c "type -q fishtape" 2>/dev/null; then
    echo "✅ Fishtape is available"
    fish -c "fishtape --version"
else
    echo "❌ Fishtape not found"
    exit 1
fi

echo ""

# Check tests directory
if [ -d "$HOME/.config/fish/tests" ]; then
    echo "✅ Tests directory exists"
    TEST_COUNT=$(ls -1 "$HOME/.config/fish/tests/"*.test.fish 2>/dev/null | wc -l)
    echo "   Found $TEST_COUNT test files"
else
    echo "❌ Tests directory not found"
    exit 1
fi

echo ""

# Check run_tests function
if fish -c "type -q run_tests" 2>/dev/null; then
    echo "✅ run_tests function is available"
else
    echo "⚠️  run_tests function not found"
    echo "   Make sure to reload your fish config or start a new shell"
fi

echo ""
echo "================================================"
echo "Installation Complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. Reload fish config or start a new shell:"
echo "   exec fish"
echo ""
echo "2. Run all tests:"
echo "   run_tests"
echo ""
echo "3. Run specific test:"
echo "   fishtape tests/killport.test.fish"
echo ""
echo "4. Read documentation:"
echo "   cat ~/.config/fish/TESTING.md"
echo ""
echo "5. Quick start guide:"
echo "   cat ~/.config/fish/tests/QUICKSTART.md"
echo ""

# Offer to run tests
read -p "Would you like to run tests now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Running tests..."
    echo ""
    fish -c "run_tests"
fi

echo ""
echo "Done! 🎉"
