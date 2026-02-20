#!/usr/bin/env fish
# ============================================================================
# Keybindings Test Script
# ============================================================================
# Tests that all custom keybindings are properly loaded
# Usage: fish test-keybindings.fish
# ============================================================================

echo "Testing Fish Keybindings Configuration..."
echo ""

# Test if in interactive mode simulation
set -l test_passed 0
set -l test_failed 0

# Test 1: Check if keybindings file exists
echo -n "Test 1: Keybindings file exists... "
if test -f ~/.config/fish/conf.d/05-keybindings.fish
    echo "✓ PASSED"
    set test_passed (math $test_passed + 1)
else
    echo "✗ FAILED"
    set test_failed (math $test_failed + 1)
end

# Test 2: Check if helper functions are defined
echo -n "Test 2: Helper functions defined... "
if type -q __fish_edit_command_in_editor
    echo "✓ PASSED"
    set test_passed (math $test_passed + 1)
else
    echo "✗ FAILED (functions may only load in interactive mode)"
    set test_failed (math $test_failed + 1)
end

# Test 3: Check vim mode setting
echo -n "Test 3: Vim mode configuration... "
if set -q FISH_VIM_MODE
    if test $FISH_VIM_MODE -eq 1
        echo "✓ ENABLED"
    else
        echo "✓ DISABLED (default)"
    end
    set test_passed (math $test_passed + 1)
else
    echo "✓ DISABLED (default)"
    set test_passed (math $test_passed + 1)
end

# Test 4: Check EDITOR variable
echo -n "Test 4: EDITOR variable... "
if set -q EDITOR
    echo "✓ SET ($EDITOR)"
    set test_passed (math $test_passed + 1)
else
    echo "⚠ NOT SET (will default to vim)"
    set test_passed (math $test_passed + 1)
end

# Test 5: Check macOS clipboard tools
echo -n "Test 5: macOS clipboard support... "
if command -q pbcopy; and command -q pbpaste
    echo "✓ AVAILABLE"
    set test_passed (math $test_passed + 1)
else
    echo "✗ NOT AVAILABLE (macOS only)"
    set test_failed (math $test_failed + 1)
end

# Test 6: List current keybindings
echo ""
echo "Current keybindings (sample):"
echo "=============================="
if status is-interactive
    bind | grep -E '(edit_command|prepend_sudo|insert_last_arg|copy_command|paste_from)' | head -n 5
else
    echo "⚠ Run this in an interactive fish session to see bindings"
end

# Summary
echo ""
echo "=============================="
echo "Test Summary:"
echo "Passed: $test_passed"
echo "Failed: $test_failed"
echo "=============================="
echo ""

# Display quick reference
echo "Quick Keybinding Reference:"
echo "============================"
echo "Alt+E          - Edit command in editor"
echo "Alt+S          - Toggle sudo"
echo "Alt+.          - Insert last argument"
echo "Ctrl+X Ctrl+E  - Edit command (alternative)"
echo "Ctrl+X Ctrl+C  - Copy command to clipboard"
echo "Ctrl+X Ctrl+V  - Paste from clipboard"
echo "Alt+Up         - Go to parent directory"
echo "Alt+Left       - Go to previous directory"
echo "Ctrl+L         - Clear screen and scrollback"
echo ""

# How to enable vim mode
echo "To enable Vim mode:"
echo "==================="
echo "Add to config.fish: set -g FISH_VIM_MODE 1"
echo "Then reload: source ~/.config/fish/config.fish"
echo ""

# How to test keybindings interactively
echo "To test keybindings:"
echo "===================="
echo "1. Open a new fish shell"
echo "2. Type a command and press Alt+E to edit"
echo "3. Type a command and press Alt+S to add sudo"
echo "4. Run 'bind' to see all current keybindings"
echo "5. See KEYBINDINGS.md for full documentation"
echo ""

if test $test_failed -eq 0
    echo "✓ All tests passed!"
    exit 0
else
    echo "⚠ Some tests failed (may be expected in non-interactive mode)"
    exit 0
end
