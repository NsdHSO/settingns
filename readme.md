# Install

```
https://github.com/banga/git-split-diffs
```

### 1

```bash
git config --global init.templatedir ~/.config/fish/hooks/
```

### 

```bash
git config --global init.templatedir
```



# NPM Permission Fix Script

This script provides a cross-platform solution to fix npm global installation permission issues on both macOS and Linux systems.

## The Problem

When using npm to install packages globally, you might encounter permission errors like:

```
npm ERR! Error: EACCES: permission denied
```

This happens because npm tries to install global packages in system directories that require root access.

## The Solution

The `fix_npm_permissions.sh` script automatically detects your operating system and applies the appropriate fix:

- Changes ownership of npm's default global installation directories to your user
- Works on both macOS and Linux systems
- Requires a one-time sudo password for permission changes

## Usage

1. Run the script:

```bash
# On macOS/Linux
~/fix_npm_permissions.sh
```

2. Enter your sudo password when prompted
3. You should now be able to use `npm install -g <package-name>` without permission errors

## Fish Shell Integration

If you're using Fish shell, you can add an alias to your Fish config for easier access:

1. Edit your Fish config:

```bash
nano ~/.config/fish/config.fish
```

2. Add this line:

```fish
alias fix_npm_permissions='~/fix_npm_permissions.sh'
```

3. Save and reload your Fish config:

```bash
source ~/.config/fish/config.fish
```

## Alternative Solutions

If you prefer not to use sudo, you can also:

1. Change npm's default directory to one you own:

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
```

2. Add to your PATH (for Fish shell):

```fish
# Add to ~/.config/fish/config.fish
set -x PATH $HOME/.npm-global/bin $PATH
```

## Script Details

The script uses the `chown` command to change ownership of the npm global installation directories:

```bash
sudo chown -R $(whoami) $NPM_PREFIX/{lib/node_modules,bin,share}
```

Where `$NPM_PREFIX` is the value from `npm config get prefix` (typically `/usr/local` on macOS and `/usr` on many Linux distributions).
