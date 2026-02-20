#!/usr/bin/env fish
# Test script for session management functions

echo "========================================="
echo "Session Management System Test"
echo "========================================="
echo ""

# Test 1: Save a session
echo "Test 1: Saving current session..."
session_save test-session
echo ""

# Test 2: List sessions
echo "Test 2: Listing sessions..."
session_list
echo ""

# Test 3: List sessions (detailed)
echo "Test 3: Detailed session list..."
session_list -l
echo ""

# Test 4: Show session diff
echo "Test 4: Comparing session with current state..."
session_diff test-session
echo ""

# Test 5: List templates
echo "Test 5: Listing available templates..."
session_template -l
echo ""

# Test 6: Export session to bash
echo "Test 6: Exporting session to bash format..."
session_export -n test-session -f bash
echo ""

# Test 7: Export session to JSON
echo "Test 7: Exporting session to JSON format..."
session_export -n test-session -f json
echo ""

# Test 8: Check auto-save status
echo "Test 8: Checking auto-save configuration..."
echo "Auto-save enabled: $SESSION_AUTOSAVE_ENABLED"
echo "Auto-save name: $SESSION_AUTOSAVE_NAME"
echo ""

# Test 9: List session files directly
echo "Test 9: Session files on disk..."
ls -lh ~/.config/fish/sessions/*.session 2>/dev/null
echo ""

# Test 10: Show session file content preview
echo "Test 10: Preview of session file..."
echo "First 20 lines of test-session.session:"
head -n 20 ~/.config/fish/sessions/test-session.session
echo ""

echo "========================================="
echo "All tests completed!"
echo "========================================="
echo ""
echo "Available commands:"
echo "  session_save <name>         - Save current session"
echo "  session_restore <name>      - Restore a session"
echo "  session_list [-l|-j]        - List sessions"
echo "  session_delete <name>       - Delete a session"
echo "  session_diff <name>         - Compare session with current"
echo "  session_export <name>       - Export session"
echo "  session_template -l         - List templates"
echo "  session_autosave_enable     - Enable auto-save"
echo ""
echo "To clean up test session:"
echo "  session_delete -f test-session"
