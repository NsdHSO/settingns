#!/usr/bin/env fish

# Setup script for Fish function testing framework
# Run with: fish setup_tests.fish

set_color cyan
echo "Fish Function Testing Framework Setup"
echo "======================================"
set_color normal
echo ""

# Check if fisher is installed
if not type -q fisher
    set_color red
    echo "Error: Fisher is not installed!"
    echo "Install it with:"
    echo "  curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
    set_color normal
    exit 1
end

set_color green
echo "✓ Fisher is installed"
set_color normal

# Install fishtape
echo ""
set_color cyan
echo "Installing fishtape..."
set_color normal

if fisher install jorgebucaran/fishtape
    set_color green
    echo "✓ Fishtape installed successfully"
    set_color normal
else
    set_color red
    echo "✗ Failed to install fishtape"
    set_color normal
    exit 1
end

# Verify installation
echo ""
set_color cyan
echo "Verifying installation..."
set_color normal

if type -q fishtape
    set_color green
    echo "✓ Fishtape is available"
    set -l version (fishtape --version 2>&1)
    echo "  Version: $version"
    set_color normal
else
    set_color red
    echo "✗ Fishtape not found in PATH"
    set_color normal
    exit 1
end

# Check tests directory
echo ""
set_color cyan
echo "Checking tests directory..."
set_color normal

if test -d ~/.config/fish/tests
    set_color green
    echo "✓ Tests directory exists"
    set -l test_count (count ~/.config/fish/tests/*.test.fish 2>/dev/null)
    echo "  Found $test_count test files"
    set_color normal
else
    set_color yellow
    echo "! Tests directory not found"
    set_color normal
    exit 1
end

# Run tests
echo ""
set_color cyan
echo "Running tests..."
echo "======================================"
set_color normal

if run_tests
    echo ""
    set_color green
    echo "======================================"
    echo "Setup completed successfully!"
    echo "======================================"
    set_color normal
    echo ""
    echo "You can now:"
    echo "  • Run all tests: run_tests"
    echo "  • Run specific test: fishtape tests/killport.test.fish"
    echo "  • See documentation: cat ~/.config/fish/TESTING.md"
else
    echo ""
    set_color yellow
    echo "======================================"
    echo "Setup completed with test failures"
    echo "======================================"
    set_color normal
    echo ""
    echo "Some tests failed. This might be normal if:"
    echo "  • Functions depend on external tools"
    echo "  • Interactive functions need mocking"
    echo ""
    echo "Check the test output above for details."
end
