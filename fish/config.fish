# Phenomenon theme colors for Fish shell
set -g phenomenon_directory BF409D    # Magenta/pink
set -g phenomenon_git_info 3B82F6     # Blue
set -g phenomenon_success 22C55E      # Green
set -g phenomenon_error EF4444        # Red
set -g phenomenon_time 14B8A6         # Teal
set -g phenomenon_symbols F43F5E      # Pink/red
set -g phenomenon_normal E5E5E5       # Light gray

# Save command execution time
function pre_exec --on-event fish_preexec
    set -g cmd_start_time (date +%s)
end

# Function to display git information
function _git_status_info
    if command -q git; and test -d (git rev-parse --git-dir 2>/dev/null)
        # Get current branch
        set -l git_branch (git branch --show-current 2>/dev/null)
        
        # Check git status
        set -l git_status (git status --porcelain 2>/dev/null)
        
        # Show branch name
        set_color --bold $phenomenon_git_info
        echo -n " ["$git_branch"]"
        
        # Show status indicators if needed
        if test -n "$git_status"
            set_color --bold $phenomenon_symbols
            echo -n "±"
        end
    end
end

# Function to display working directory
function _print_pwd
    set_color --bold $phenomenon_directory
    
    # Shorten path by replacing $HOME with ~
    set -l pwd_str (string replace -r "^$HOME" "~" (pwd))
    
    echo -n $pwd_str
end

# Main prompt function
function fish_prompt
    set -l last_status $status
    
    # Print working directory
    _print_pwd
    
    # Print git info
    _git_status_info
    
    # Show status indicator
    if test $last_status -eq 0
        set_color --bold $phenomenon_success
        echo -n " ✓"
    else
        set_color --bold $phenomenon_error
        echo -n " ✗"
    end
    
    # End with a simple > in Phenomenon pink/red
    set_color --bold $phenomenon_symbols
    echo -n " > "
    
    # Reset color for user input
    set_color $phenomenon_normal
end

# Right-side prompt (time and command duration)
function fish_right_prompt
    # Show command execution time if available
    if set -q cmd_start_time
        set -l current_time (date +%s)
        set -l duration (math $current_time - $cmd_start_time)
        
        if test $duration -gt 5
            set_color --bold $phenomenon_symbols
            echo -n "["
            
            if test $duration -gt 60
                set -l minutes (math $duration / 60)
                set -l seconds (math $duration % 60)
                echo -n $minutes"m"$seconds"s"
            else
                echo -n $duration"s"
            end
            
            echo -n "] "
        end
    end
    
    # Current time
    set_color --bold $phenomenon_time
    echo -n "["(date "+%H:%M")"]"
    set_color 14B8A6
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end


set -x PATH /opt/homebrew/bin:/opt/homebrew/sbin:/Users/davidnechiforel/.npm-global/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin ~/.npm-global/bin

# But it's safe to include as a reminder
npm config set prefix $HOME/.npm-global

# Setup NVM (keep this if you use NVM)
set -x NVM_DIR "$HOME/.nvm"

# Add npm-global path
set -gx PATH $HOME/.npm-global/bin $PATH

# Source your alias file
source ~/.config/fish/personalized/alias.fish

# Load Homebrew environment variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# Explicitly source your functions file
source ~/.config/fish/functions/functions.fish

set -Ua fish_user_paths $HOME/.cargo/bin

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/davidnechiforel/.lmstudio/bin
