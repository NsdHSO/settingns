# Fish Performance Monitoring - Quick Reference

## Quick Start

```fish
# Run health check (recommended first step)
perf_check

# View dashboard
perf status

# Measure startup time
fish_startup_time
```

## Commands Overview

| Command | Purpose | Usage |
|---------|---------|-------|
| `perf_check` | Quick health check | `perf_check` |
| `perf status` | Dashboard view | `perf status` |
| `fish_startup_time` | Measure startup | `fish_startup_time [iterations]` |
| `profile_startup` | Analyze startup | `profile_startup` |
| `profile_function` | Time a function | `profile_function <name> [args]` |
| `show_slow_commands` | View slow commands | `show_slow_commands` |
| `performance_tips` | Get optimization tips | `performance_tips` |

## Unified Interface: `perf`

```fish
perf status      # Dashboard
perf startup     # Measure startup time
perf profile     # Profile startup
perf slow        # Show slow commands
perf tips        # Optimization tips
perf function    # Profile function
perf reset       # Clear logs
```

## Common Workflows

### Initial Setup
```fish
# 1. Health check
perf_check

# 2. If issues found, get details
perf profile

# 3. Get optimization suggestions
perf tips
```

### Testing Function Performance
```fish
# Profile a function
perf function gc "commit message"

# Profile with no args
perf function gis
```

### Monitoring Slow Commands
```fish
# Set custom threshold (optional)
set -Ux FISH_SLOW_COMMAND_THRESHOLD 60

# View logged slow commands
perf slow

# Clear the log
perf reset
```

### Regular Maintenance
```fish
# Weekly health check
perf_check

# Monthly startup analysis
fish_startup_time 10

# Review slow commands
show_slow_commands
```

## Performance Targets

| Metric | Target | Status |
|--------|--------|--------|
| Startup time | < 200ms | ✓ Excellent |
| Startup time | 200-500ms | ⚠ Warning |
| Startup time | > 500ms | ✗ Critical |

## File Locations

```
~/.config/fish/functions/
  ├── perf.fish                    # Main dashboard
  ├── perf_check.fish              # Health check
  ├── fish_startup_time.fish       # Startup timer
  ├── profile_startup.fish         # Startup profiler
  ├── profile_function.fish        # Function profiler
  ├── slow_command_warning.fish    # Slow detection
  ├── show_slow_commands.fish      # Log viewer
  └── performance_tips.fish        # Tips generator

~/.config/fish/
  └── slow_commands.log            # Slow command log (auto-created)
```

## Configuration

```fish
# Slow command threshold (default: 30s)
set -Ux FISH_SLOW_COMMAND_THRESHOLD 60

# Disable slow command detection
set -Ux FISH_SLOW_COMMAND_THRESHOLD 0
```

## Troubleshooting

### Problem: Slow startup

**Solution:**
```fish
# 1. Measure
fish_startup_time

# 2. Analyze
profile_startup

# 3. Optimize based on tips
performance_tips
```

### Problem: Function is slow

**Solution:**
```fish
# Profile it
perf function <function_name>

# Check for:
# - External command calls
# - Command substitutions
# - File I/O
```

### Problem: Not logging slow commands

**Solution:**
```fish
# Check threshold
echo $FISH_SLOW_COMMAND_THRESHOLD

# Re-source
source ~/.config/fish/functions/slow_command_warning.fish

# Test with a slow command
sleep 31
```

## Optimization Checklist

- [ ] Run `perf_check` for baseline
- [ ] Startup time < 200ms
- [ ] No unnecessary `eval` calls
- [ ] Minimal command substitutions in config.fish
- [ ] Functions use autoload (not explicit source)
- [ ] Heavy operations deferred or lazy-loaded
- [ ] Event handlers are minimal
- [ ] Unused plugins removed

## Quick Examples

```fish
# Health check
perf_check

# Measure startup (5 runs)
fish_startup_time

# Measure startup (10 runs for accuracy)
fish_startup_time 10

# Profile git commit function
perf function gc "test commit"

# View dashboard
perf status

# Get optimization tips
perf tips

# Profile startup components
profile_startup

# View slow commands
show_slow_commands

# Clear slow command log
rm ~/.config/fish/slow_commands.log
```

## Performance Tips Summary

1. **Lazy Loading**: Defer heavy operations
2. **Minimize Startup**: Reduce config.fish work
3. **Optimize Functions**: Use builtins, cache results
4. **Event Handlers**: Keep them minimal
5. **Plugin Management**: Remove unused plugins

## Color Codes

- 🟢 **Green**: Good/Pass/Fast
- 🟡 **Yellow**: Warning/Needs optimization
- 🔴 **Red**: Critical/Slow/Failed

## Event Handlers (Automatic)

The system uses fish event hooks (no manual setup needed):

- `fish_preexec`: Captures command start time
- `fish_postexec`: Calculates and logs if slow

## Log Management

```fish
# View log
cat ~/.config/fish/slow_commands.log

# Clear log
rm ~/.config/fish/slow_commands.log

# Or use perf
perf reset
```

## Minimal Overhead

- Event handlers: < 1ms per command
- Function profiling: Only when called
- Slow detection: Only logs if > threshold
- No impact on normal operations

## Integration with Other Tools

```fish
# Use with fish profiler
fish --profile /tmp/fish_profile.log -c exit
cat /tmp/fish_profile.log

# Combine with time command
time fish -c exit
```

## Support

For detailed documentation:
- Full guide: `/Users/davidsamuel.nechifor/.config/docs/performance-monitoring.md`
- Fish docs: `man fish`
- Help: `perf` (no args shows help)
