# ============================================================================
# Prompt Configuration - Migrated to conf.d/03-prompt.fish
# ============================================================================
# All Phenomenon theme colors and prompt functions have been moved to:
# ~/.config/fish/conf.d/03-prompt.fish
#
# This includes:
# - Theme color definitions (phenomenon_*)
# - pre_exec (command timing)
# - _git_status_info
# - _print_pwd
# - fish_prompt
# - fish_right_prompt

# ============================================================================
# Fish Shell Configuration - Minimal Loader
# ============================================================================
# This file serves as the main entry point for Fish shell configuration.
# Most functionality has been modularized into conf.d/ files which are
# automatically sourced by Fish in alphabetical order:
#
#   00-env.fish    - Environment variables, PATH, exports
#   01-tools.fish  - Modern CLI tools (bat, eza, zoxide, etc.)
#   03-prompt.fish - Phenomenon theme and prompt functions
#   nvm.fish       - NVM (Node Version Manager)
#   rustup.fish    - Rust toolchain
#
# Additional custom configurations are loaded below.
# ============================================================================

if status is-interactive
    # Source custom aliases
    source ~/.config/fish/personalized/alias.fish

    # Functions are auto-loaded by Fish from ~/.config/fish/functions/
    # No need to source them explicitly - Fish will load them on first use
    # This saves ~500-700ms on startup!
end


# ============================================================================
# Environment Variables - Migrated to conf.d/00-env.fish
# ============================================================================
# All PATH configurations, exports, and environment variables moved to:
# ~/.config/fish/conf.d/00-env.fish
#
# This includes:
# - PATH setup (Homebrew, npm-global, system paths)
# - NPM configuration
# - NVM setup
# - Cargo/Rust paths
# - LM Studio CLI paths
# - SDKMAN (Java/Maven)
# - Proxy configuration
# - GitLab tokens   