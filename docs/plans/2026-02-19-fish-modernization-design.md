# Fish Shell Modernization Design
**Date:** 2026-02-19
**Objective:** Transform fish shell into a next-level modern development environment

## Vision

Modernize the fish shell setup with 20 independent components that work together to create a powerful, productive, and delightful terminal experience. All components integrate seamlessly with existing Phenomenon theme and custom functions.

## Architecture

### Three-Layer Design

**1. Fish Shell Layer (User Interface)**
- Preserve existing Phenomenon-themed prompt and custom functions
- New modular configuration system in `conf.d/`
- Enhanced with modern CLI tools and smart integrations

**2. Tool Integration Layer**
- Modern CLI replacements: bat, eza, fd, ripgrep, delta, zoxide
- Plugin manager: Fisher with curated plugins
- Smart completions and abbreviations

**3. Developer Productivity Layer**
- Git workflow enhancements
- Docker/K8s helpers
- Project environment management
- Session and state management

### Directory Structure

```
~/.config/fish/
├── config.fish                    # Simplified loader
├── conf.d/
│   ├── 00-env.fish               # PATH, environment variables
│   ├── 01-tools.fish             # Modern CLI tools setup
│   ├── 02-plugins.fish           # Fisher plugins
│   ├── 03-prompt.fish            # Enhanced Phenomenon prompt
│   ├── 04-abbreviations.fish     # Command abbreviations
│   └── 05-keybindings.fish       # Custom keybindings
├── functions/                     # Existing + new functions
│   ├── [existing functions]      # Preserved
│   └── [new enhanced functions]  # Added by agents
├── completions/                   # Auto-completions
├── personalized/                  # User customizations (unchanged)
│   └── alias.fish
└── themes/                        # Theme system
```

## 20 Components (Agent Assignments)

### Infrastructure Components (1-5)

**1. Plugin Manager Setup**
- Install Fisher plugin manager
- Configure auto-update system
- Set up plugin isolation

**2. Config Modularization**
- Split monolithic config.fish into conf.d/ modules
- Create load order system (00-05 prefix)
- Migrate existing config to appropriate modules

**3. Modern CLI Tools Installation**
- Install: bat (cat replacement), eza (ls replacement)
- Install: fd (find replacement), ripgrep (grep replacement)
- Install: delta (git diff), zoxide (cd replacement)
- Configure aliases and integrations

**4. Enhanced Prompt System**
- Extend Phenomenon theme with additional context
- Add: Kubernetes context, Docker status, Node version
- Add: Python venv, Java version, battery indicator
- Maintain existing color scheme and styling

**5. Automatic Backup System**
- Git-based config backup to dedicated repo
- Auto-commit on config changes
- Scheduled backups (daily)
- Easy restore functionality

### Developer Tools Components (6-10)

**6. Advanced Git Integration**
- Delta for beautiful diffs
- Smart branch switching with fzf
- Enhanced stash management functions
- Git worktree helpers

**7. Project Environment Manager**
- Auto-load .envrc files (direnv-style)
- Project-specific PATH and variables
- Auto-activate virtual environments
- Project detection and context switching

**8. Docker & Kubernetes Helpers**
- Container management functions (start, stop, logs, exec)
- Context switching for k8s
- Docker Compose shortcuts
- Container resource monitoring

**9. Context-Aware Completions**
- Smart completions for git, docker, kubectl
- Project-aware file completions
- Command history-based suggestions
- Tool-specific completion enhancements

**10. Language Version Manager Optimization**
- Lazy-load NVM for faster startup
- Optimized SDKMAN integration
- Auto-switch Node/Java versions per project
- Version manager status in prompt

### Productivity Components (11-15)

**11. Fuzzy Finder Integration (fzf)**
- Fuzzy command history search (Ctrl+R)
- Fuzzy file finder (Ctrl+T)
- Fuzzy directory changer (Alt+C)
- Git branch/tag selector
- Process finder for killport enhancement

**12. Smart Navigation (zoxide)**
- Install and configure zoxide
- Create `z` function for smart directory jumping
- Project-based shortcuts
- Frecency-based directory suggestions

**13. Dynamic Abbreviation System**
- Common command abbreviations
- Context-aware expansions
- Personal abbreviation management
- Git command abbreviations

**14. Session Management**
- Save/restore terminal sessions
- Project-based session templates
- Command history per project
- Working directory restoration

**15. Enhanced Keybindings**
- Vim-style navigation (optional)
- Custom productivity keybindings
- Multi-line editing improvements
- Clipboard integration shortcuts

### Quality & Documentation Components (16-20)

**16. Function Testing Framework**
- Test harness for fish functions
- Unit tests for existing functions
- Integration test examples
- CI/CD testing setup

**17. Performance Monitoring**
- Startup time profiling
- Slow command detection
- Function execution timing
- Performance optimization suggestions

**18. Advanced Error Handling**
- Better error messages for functions
- Graceful fallbacks for missing tools
- Error recovery mechanisms
- User-friendly error display

**19. Automatic Documentation**
- Generate docs from function comments
- Function usage examples
- README for custom functions
- Keybinding reference card

**20. Theme Management System**
- Easy theme switching framework
- Theme preview functionality
- Custom theme creation tools
- Community theme integration

## Integration Strategy

### Preserve Existing Setup
- All current functions remain untouched
- Phenomenon theme colors preserved
- Existing aliases in alias.fish stay
- Git hooks and personalized settings unchanged

### Side-by-Side Approach
- New features added without removing old ones
- Feature flags for toggling new functionality
- Gradual migration path
- Rollback capability

### Migration Process
1. Create automatic backup of current config
2. Agents create new files/modules (no deletions)
3. New modules load alongside existing config
4. Testing phase with both old and new features active
5. Optional cleanup of redundant old config

## Success Criteria

- All 20 components successfully installed and configured
- Fish shell startup time < 200ms
- Zero breaking changes to existing workflow
- All existing functions continue to work
- Enhanced productivity with new tools
- Comprehensive documentation for all new features

## Execution Plan

20 agents work in parallel, each implementing one component independently. No shared state or sequential dependencies. Each agent:
1. Installs required tools/plugins
2. Creates necessary configuration files
3. Writes fish functions for their component
4. Adds tests for new functions
5. Documents their component

## Risk Mitigation

- Automatic backup before any changes
- Each component isolated in separate files
- Feature flags for disabling problematic components
- Rollback script for complete restoration
- Testing in non-interactive mode first

## Post-Implementation

- Restart fish shell to load all new features
- Review generated documentation
- Run test suite to verify all functions
- Customize enabled features based on preference
- Set up automatic updates for tools/plugins
