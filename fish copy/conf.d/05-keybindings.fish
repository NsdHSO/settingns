# ============================================================================
# Enhanced Fish Shell Keybindings
# ============================================================================
# Custom productivity keybindings for interactive fish shell sessions
# Created: 2026-02-19
# ============================================================================

# Only apply keybindings in interactive mode
if status is-interactive

    # ========================================================================
    # Configuration Variables
    # ========================================================================

    # Set to 1 to enable vim mode (disabled by default)
    # Usage: set -g FISH_VIM_MODE 1 in your config.fish before sourcing this file
    if not set -q FISH_VIM_MODE
        set -g FISH_VIM_MODE 0
    end

    # ========================================================================
    # Vim Mode (Optional)
    # ========================================================================

    if test $FISH_VIM_MODE -eq 1
        # Enable vim key bindings
        fish_vi_key_bindings

        # Set cursor shapes for different vim modes
        set fish_cursor_default block
        set fish_cursor_insert line
        set fish_cursor_replace_one underscore
        set fish_cursor_visual block

        # Show mode indicator in prompt (optional)
        function fish_mode_prompt
            switch $fish_bind_mode
                case default
                    set_color --bold red
                    echo '[N] '
                case insert
                    set_color --bold green
                    echo '[I] '
                case replace_one
                    set_color --bold yellow
                    echo '[R] '
                case visual
                    set_color --bold magenta
                    echo '[V] '
            end
            set_color normal
        end
    else
        # Use default emacs-style keybindings
        fish_default_key_bindings
    end

    # ========================================================================
    # Custom Helper Functions
    # ========================================================================

    # Function to edit current command in external editor
    function __fish_edit_command_in_editor
        set -l tmpfile (mktemp)
        commandline > $tmpfile

        # Use $EDITOR if set, otherwise default to vim
        set -l editor $EDITOR
        if test -z "$editor"
            set editor vim
        end

        # Edit the file
        $editor $tmpfile

        # Read back the contents and set as commandline
        if test -f $tmpfile
            commandline -r (cat $tmpfile)
            rm -f $tmpfile
        end

        commandline -f repaint
    end

    # Function to prepend sudo to current command
    function __fish_prepend_sudo
        set -l cmd (commandline -b)

        if test -z "$cmd"
            # If command is empty, just insert sudo
            commandline -i 'sudo '
        else if string match -qr '^sudo ' -- $cmd
            # If already starts with sudo, remove it
            commandline -r (string replace -r '^sudo\s+' '' -- $cmd)
        else
            # Otherwise prepend sudo
            commandline -r "sudo $cmd"
        end

        commandline -f repaint
    end

    # Function to insert last argument from previous command
    function __fish_insert_last_arg
        set -l last_arg (history --max 1 | string split ' ')[-1]
        commandline -i $last_arg
    end

    # Function to copy current command to clipboard (macOS)
    function __fish_copy_command_to_clipboard
        if command -q pbcopy
            commandline -b | pbcopy
            echo "Command copied to clipboard"
        else
            echo "pbcopy not available (macOS only)"
        end
    end

    # Function to paste from clipboard to command line (macOS)
    function __fish_paste_from_clipboard
        if command -q pbpaste
            set -l clip (pbpaste)
            commandline -i $clip
        else
            echo "pbpaste not available (macOS only)"
        end
    end

    # Function to clear screen and scrollback
    function __fish_clear_screen_and_scrollback
        clear
        # macOS Terminal.app specific
        printf '\e[3J'
    end

    # ========================================================================
    # Enhanced Keybindings (Emacs Mode)
    # ========================================================================

    # Alt+E: Edit command in external editor
    bind \ee __fish_edit_command_in_editor

    # Alt+S: Prepend/toggle sudo
    bind \es __fish_prepend_sudo

    # Alt+.: Insert last argument from previous command
    bind \e. __fish_insert_last_arg

    # Ctrl+X Ctrl+E: Edit command in external editor (alternative)
    bind \cx\ce __fish_edit_command_in_editor

    # ========================================================================
    # Clipboard Integration (macOS)
    # ========================================================================

    # Ctrl+X Ctrl+C: Copy current command to clipboard
    bind \cx\cc __fish_copy_command_to_clipboard

    # Ctrl+X Ctrl+V: Paste from clipboard
    bind \cx\cv __fish_paste_from_clipboard

    # ========================================================================
    # Navigation Enhancements
    # ========================================================================

    # Alt+B: Backward word (already default, but ensure it's set)
    bind \eb backward-word

    # Alt+F: Forward word (already default, but ensure it's set)
    bind \ef forward-word

    # Ctrl+Left: Backward word (for terminals that support it)
    bind \e\[1\;5D backward-word

    # Ctrl+Right: Forward word (for terminals that support it)
    bind \e\[1\;5C forward-word

    # ========================================================================
    # History Enhancements
    # ========================================================================

    # Ctrl+R: Search history (default pager)
    bind \cr history-pager

    # Alt+P: Previous command starting with current input
    bind \ep history-prefix-search-backward

    # Alt+N: Next command starting with current input
    bind \en history-prefix-search-forward

    # ========================================================================
    # Screen Management
    # ========================================================================

    # Ctrl+L: Clear screen (default, but enhanced to clear scrollback)
    bind \cl __fish_clear_screen_and_scrollback

    # ========================================================================
    # Directory Navigation
    # ========================================================================

    # Alt+Up: cd .. (go to parent directory)
    bind \e\[1\;3A 'cd ..; commandline -f repaint'

    # Alt+Left: cd - (go to previous directory)
    bind \e\[1\;3D 'cd -; commandline -f repaint'

    # ========================================================================
    # Additional Vim Mode Keybindings (if enabled)
    # ========================================================================

    if test $FISH_VIM_MODE -eq 1
        # In insert mode, allow these keybindings
        bind -M insert \ee __fish_edit_command_in_editor
        bind -M insert \es __fish_prepend_sudo
        bind -M insert \e. __fish_insert_last_arg
        bind -M insert \cx\ce __fish_edit_command_in_editor
        bind -M insert \cx\cc __fish_copy_command_to_clipboard
        bind -M insert \cx\cv __fish_paste_from_clipboard

        # In default/normal mode
        bind -M default \ee __fish_edit_command_in_editor
        bind -M default \es __fish_prepend_sudo
    end

end

# ============================================================================
# Keybinding Documentation
# ============================================================================
#
# EDITOR INTEGRATION:
#   Alt+E                Edit command in $EDITOR
#   Ctrl+X Ctrl+E        Edit command in $EDITOR (alternative)
#
# COMMAND MODIFICATION:
#   Alt+S                Prepend/toggle 'sudo' to command
#   Alt+.                Insert last argument from previous command
#
# CLIPBOARD (macOS):
#   Ctrl+X Ctrl+C        Copy current command to clipboard
#   Ctrl+X Ctrl+V        Paste from clipboard
#
# NAVIGATION:
#   Alt+B                Move backward one word
#   Alt+F                Move forward one word
#   Ctrl+Left            Move backward one word
#   Ctrl+Right           Move forward one word
#
# HISTORY:
#   Ctrl+R               Search command history (interactive)
#   Alt+P                Previous command with current prefix
#   Alt+N                Next command with current prefix
#   Up/Down              Navigate history
#
# DIRECTORY:
#   Alt+Up               Go to parent directory (cd ..)
#   Alt+Left             Go to previous directory (cd -)
#
# SCREEN:
#   Ctrl+L               Clear screen and scrollback
#
# VIM MODE (if enabled):
#   Set FISH_VIM_MODE=1 in config.fish to enable
#   All custom keybindings work in insert mode
#   [N] = Normal mode, [I] = Insert mode, [V] = Visual mode, [R] = Replace mode
#
# ============================================================================
