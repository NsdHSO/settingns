# Phenomenon Theme Prompt Configuration
# Migrated from config.fish on 2026-02-19
#
# Enhanced with additional context indicators:
#   Enable via environment variables:
#   SHOW_K8S_CONTEXT=1    - Show Kubernetes context
#   SHOW_DOCKER_STATUS=1  - Show Docker status
#   SHOW_NODE_VERSION=1   - Show Node.js version
#   SHOW_PYTHON_VENV=1    - Show Python virtual environment
#   SHOW_BATTERY=1        - Show battery percentage (laptop)

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

# Cache variables for performance
set -g _prompt_k8s_cache ""
set -g _prompt_k8s_cache_time 0
set -g _prompt_docker_cache ""
set -g _prompt_docker_cache_time 0
set -g _prompt_node_cache ""
set -g _prompt_node_cache_time 0

# Cache TTL in seconds (5 minutes)
set -g _prompt_cache_ttl 300

# Function to get Kubernetes context
function _prompt_k8s_context
    # Only run if enabled
    if not set -q SHOW_K8S_CONTEXT; or test "$SHOW_K8S_CONTEXT" != "1"
        return
    end

    # Check if kubectl is available
    if not command -q kubectl
        return
    end

    # Check cache
    set -l current_time (date +%s)
    if test -n "$_prompt_k8s_cache"; and test (math $current_time - $_prompt_k8s_cache_time) -lt $_prompt_cache_ttl
        echo -n $_prompt_k8s_cache
        return
    end

    # Get current context
    set -l k8s_context (kubectl config current-context 2>/dev/null)

    if test -n "$k8s_context"
        set_color --bold $phenomenon_git_info
        set -l output " [☸ $k8s_context]"

        # Update cache
        set -g _prompt_k8s_cache $output
        set -g _prompt_k8s_cache_time $current_time

        echo -n $output
    end
end

# Function to get Docker status
function _prompt_docker_status
    # Only run if enabled
    if not set -q SHOW_DOCKER_STATUS; or test "$SHOW_DOCKER_STATUS" != "1"
        return
    end

    # Check if docker is available
    if not command -q docker
        return
    end

    # Check cache
    set -l current_time (date +%s)
    if test -n "$_prompt_docker_cache"; and test (math $current_time - $_prompt_docker_cache_time) -lt $_prompt_cache_ttl
        echo -n $_prompt_docker_cache
        return
    end

    # Check if Docker is running
    if docker info >/dev/null 2>&1
        # Get running container count
        set -l container_count (docker ps -q 2>/dev/null | wc -l | string trim)

        if test "$container_count" -gt 0
            set_color --bold $phenomenon_git_info
            set -l output " [🐳 $container_count]"

            # Update cache
            set -g _prompt_docker_cache $output
            set -g _prompt_docker_cache_time $current_time

            echo -n $output
        else
            set -g _prompt_docker_cache ""
            set -g _prompt_docker_cache_time $current_time
        end
    else
        set -g _prompt_docker_cache ""
        set -g _prompt_docker_cache_time $current_time
    end
end

# Function to get Node.js version
function _prompt_node_version
    # Only run if enabled
    if not set -q SHOW_NODE_VERSION; or test "$SHOW_NODE_VERSION" != "1"
        return
    end

    # Check if node is available
    if not command -q node
        return
    end

    # Only show in directories with package.json
    if not test -f package.json
        return
    end

    # Check cache
    set -l current_time (date +%s)
    if test -n "$_prompt_node_cache"; and test (math $current_time - $_prompt_node_cache_time) -lt $_prompt_cache_ttl
        echo -n $_prompt_node_cache
        return
    end

    # Get node version
    set -l node_version (node -v 2>/dev/null | string replace 'v' '')

    if test -n "$node_version"
        set_color --bold $phenomenon_success
        set -l output " [⬢ $node_version]"

        # Update cache
        set -g _prompt_node_cache $output
        set -g _prompt_node_cache_time $current_time

        echo -n $output
    end
end

# Function to get Python virtual environment
function _prompt_python_venv
    # Only run if enabled
    if not set -q SHOW_PYTHON_VENV; or test "$SHOW_PYTHON_VENV" != "1"
        return
    end

    # Check if in a virtual environment
    if set -q VIRTUAL_ENV
        set -l venv_name (basename "$VIRTUAL_ENV")
        set_color --bold $phenomenon_success
        echo -n " [🐍 $venv_name]"
    end
end

# Function to get battery percentage
function _prompt_battery
    # Only run if enabled
    if not set -q SHOW_BATTERY; or test "$SHOW_BATTERY" != "1"
        return
    end

    # Check if pmset is available (macOS only)
    if not command -q pmset
        return
    end

    # Get battery info
    set -l battery_info (pmset -g batt 2>/dev/null)

    if test -n "$battery_info"
        # Extract battery percentage
        set -l battery_pct (echo $battery_info | grep -o '[0-9]*%' | string replace '%' '')

        if test -n "$battery_pct"
            # Choose color based on battery level
            if test $battery_pct -gt 50
                set_color --bold $phenomenon_success
            else if test $battery_pct -gt 20
                set_color --bold $phenomenon_time
            else
                set_color --bold $phenomenon_error
            end

            # Check if charging
            set -l charging_status (echo $battery_info | grep -o 'AC Power\|Battery Power')
            if test "$charging_status" = "AC Power"
                echo -n " [🔌 $battery_pct%]"
            else
                echo -n " [🔋 $battery_pct%]"
            end
        end
    end
end

# Main prompt function
function fish_prompt
    set -l last_status $status

    # Print working directory
    _print_pwd

    # Print git info
    _git_status_info

    # NEW: Print Kubernetes context
    _prompt_k8s_context

    # NEW: Print Docker status
    _prompt_docker_status

    # NEW: Print Node.js version
    _prompt_node_version

    # NEW: Print Python venv
    _prompt_python_venv

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
    # NEW: Show battery status
    _prompt_battery

    # Show command execution time if available
    if set -q cmd_start_time
        set -l current_time (date +%s)
        set -l duration (math $current_time - $cmd_start_time)

        if test $duration -gt 5
            set_color --bold $phenomenon_symbols
            echo -n " ["

            if test $duration -gt 60
                set -l minutes (math $duration / 60)
                set -l seconds (math $duration % 60)
                echo -n $minutes"m"$seconds"s"
            else
                echo -n $duration"s"
            end

            echo -n "]"
        end
    end

    # Current time
    set_color --bold $phenomenon_time
    echo -n " ["(date "+%H:%M")"]"
    set_color 14B8A6
end

# Helper function to quickly enable all indicators
function prompt_enable_all
    set -Ux SHOW_K8S_CONTEXT 1
    set -Ux SHOW_DOCKER_STATUS 1
    set -Ux SHOW_NODE_VERSION 1
    set -Ux SHOW_PYTHON_VENV 1
    set -Ux SHOW_BATTERY 1
    echo "✓ All prompt indicators enabled"
    echo "Reload your shell or run: exec fish"
end

# Helper function to disable all indicators
function prompt_disable_all
    set -e SHOW_K8S_CONTEXT
    set -e SHOW_DOCKER_STATUS
    set -e SHOW_NODE_VERSION
    set -e SHOW_PYTHON_VENV
    set -e SHOW_BATTERY
    echo "✓ All prompt indicators disabled"
    echo "Reload your shell or run: exec fish"
end

# Helper function to show current prompt configuration
function prompt_status
    echo "Current Prompt Indicators Status:"
    echo ""

    if set -q SHOW_K8S_CONTEXT; and test "$SHOW_K8S_CONTEXT" = "1"
        echo "  ☸  Kubernetes Context: ENABLED"
    else
        echo "  ☸  Kubernetes Context: disabled"
    end

    if set -q SHOW_DOCKER_STATUS; and test "$SHOW_DOCKER_STATUS" = "1"
        echo "  🐳 Docker Status: ENABLED"
    else
        echo "  🐳 Docker Status: disabled"
    end

    if set -q SHOW_NODE_VERSION; and test "$SHOW_NODE_VERSION" = "1"
        echo "  ⬢  Node.js Version: ENABLED"
    else
        echo "  ⬢  Node.js Version: disabled"
    end

    if set -q SHOW_PYTHON_VENV; and test "$SHOW_PYTHON_VENV" = "1"
        echo "  🐍 Python Venv: ENABLED"
    else
        echo "  🐍 Python Venv: disabled"
    end

    if set -q SHOW_BATTERY; and test "$SHOW_BATTERY" = "1"
        echo "  🔋 Battery: ENABLED"
    else
        echo "  🔋 Battery: disabled"
    end

    echo ""
    echo "To enable individual indicators:"
    echo "  set -Ux SHOW_K8S_CONTEXT 1"
    echo "  set -Ux SHOW_DOCKER_STATUS 1"
    echo "  set -Ux SHOW_NODE_VERSION 1"
    echo "  set -Ux SHOW_PYTHON_VENV 1"
    echo "  set -Ux SHOW_BATTERY 1"
    echo ""
    echo "To disable individual indicators:"
    echo "  set -e SHOW_K8S_CONTEXT"
    echo ""
    echo "Or use: prompt_enable_all / prompt_disable_all"
end
