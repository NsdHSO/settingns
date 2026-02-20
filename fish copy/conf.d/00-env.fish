# Environment Variables and PATH Configuration
# Migrated from config.fish on 2026-02-19

# Base PATH configuration
set -x PATH /opt/homebrew/bin:/opt/homebrew/sbin:/Users/davidnechiforel/.npm-global/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin ~/.npm-global/bin

# NPM Configuration (run only once, not every startup)
# npm config set prefix $HOME/.npm-global  # Already configured
set -gx PATH $HOME/.npm-global/bin $PATH

# NVM Setup
set -x NVM_DIR "$HOME/.nvm"

# Cargo/Rust
set -Ua fish_user_paths $HOME/.cargo/bin

# LM Studio CLI
set -gx PATH $PATH /Users/davidnechiforel/.lmstudio/bin

# SDKMAN - Lazy loaded in lazy_sdkman.fish (conf.d/lazy_sdkman.fish)
# This optimization reduces shell startup time by ~500ms
# The sdk function and environment variables are set up on-demand

# Proxy Configuration (Claude Code)
set -gx http_proxy http://127.0.0.1:8079
set -gx HTTP_PROXY http://127.0.0.1:8079
set -gx https_proxy http://127.0.0.1:8079
set -gx HTTPS_PROXY http://127.0.0.1:8079
set -gx all_proxy http://127.0.0.1:8079
set -gx ALL_PROXY http://127.0.0.1:8079
set -gx no_proxy .bcr.wan,localhost,127.0.0.1
set -gx NO_PROXY .bcr.wan,localhost,127.0.0.1
set -gx NODE_TLS_REJECT_UNAUTHORIZED 0

# GitLab Configuration
set -gx GITLAB_TOKEN 7R8QoMF77JHJchZpkVzJ
set -gx GITLAB_URL https://gitlab.bcr.wan

# Load Homebrew environment variables (cached for performance)
# Instead of running brew on every startup, we set the values directly
set -gx HOMEBREW_PREFIX "/opt/homebrew"
set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
set -gx HOMEBREW_REPOSITORY "/opt/homebrew"
set -gx MANPATH "/opt/homebrew/share/man" $MANPATH
set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH
