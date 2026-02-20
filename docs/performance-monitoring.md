# Fish Shell Performance Monitoring System

## Overview

A comprehensive performance monitoring and profiling system for fish shell that helps identify bottlenecks and optimize startup time.

**Target**: Shell startup < 200ms

## Components

### 1. Main Dashboard: `perf`

Central command for all performance monitoring operations.

```fish
perf status    # Show current performance status
perf startup   # Measure startup time
perf profile   # Profile startup components
perf slow      # Show slow command history
perf tips      # Show optimization tips
perf function  # Profile a specific function
perf reset     # Clear performance logs
```

### 2. Startup Time Measurement

#### `fish_startup_time [iterations]`

Measures fish shell startup time with multiple iterations for accuracy.

```fish
# Default 5 iterations
fish_startup_time

# Custom iterations
fish_startup_time 10
```

**Output:**
- Individual run times
- Average startup time
- Performance assessment (Excellent/Warning/Critical)
- Recommendations based on results

**Performance Levels:**
- ✓ Excellent: < 200ms (target met)
- ⚠ Warning: 200-500ms (optimization recommended)
- ✗ Critical: > 500ms (optimization required)

### 3. Startup Profiler

#### `profile_startup`

Analyzes fish shell startup to identify slow components.

**What it checks:**
- Total startup time
- config.fish complexity (line count)
- conf.d directory files
- Functions directory size
- Potential bottlenecks:
  - `eval` commands (slow)
  - Command substitutions `$()`
  - Multiple `source` commands

**Output:**
- Component-by-component analysis
- Detected bottlenecks with warnings
- Specific optimization suggestions

**Example bottlenecks:**
```fish
⚠ eval commands detected (can be slow)
⚠ Many command substitutions: 15 (consider lazy loading)
⚠ Multiple source commands: 7
```

### 4. Function Profiler

#### `profile_function <function_name> [args...]`

Times the execution of a specific function.

```fish
# Profile a function without arguments
profile_function gis

# Profile a function with arguments
profile_function gc "my commit message"

# Profile complex functions
profile_function killport 3000
```

**Output:**
- Function name and arguments
- Execution time in milliseconds
- Speed assessment (Fast/Moderate/Slow)
- Exit status

**Speed Levels:**
- Fast: < 100ms
- Moderate: 100-1000ms
- Slow: > 1000ms (>1s)

### 5. Slow Command Detection

#### Automatic Monitoring

The system automatically detects and logs commands that take longer than a threshold.

**Default threshold:** 30 seconds

**Customize threshold:**
```fish
# Set custom threshold (60 seconds)
set -Ux FISH_SLOW_COMMAND_THRESHOLD 60
```

**What happens:**
- Commands running longer than threshold trigger a warning
- Command details logged to `~/.config/fish/slow_commands.log`
- Log limited to last 100 entries

**Warning format:**
```
⚠ Slow command detected!
  Command: npm install
  Duration: 45s (threshold: 30s)
```

#### `show_slow_commands`

Display history of slow commands.

```fish
show_slow_commands
```

**Output:**
- Timestamp of execution
- Duration (color-coded)
- Full command

**Color coding:**
- Green: 30-60s
- Yellow: 60-120s
- Red: > 120s

**Log location:** `~/.config/fish/slow_commands.log`

### 6. Performance Tips

#### `performance_tips`

Comprehensive analysis and optimization suggestions.

**Checks performed:**
1. Current startup time measurement
2. eval command count in config.fish
3. Command substitution count
4. Event handler usage
5. Overall configuration health

**Tip categories:**
1. **Lazy Loading**
   - Use autoloaded functions
   - Defer heavy operations

2. **Minimize Startup Work**
   - Consolidate PATH additions
   - Avoid running commands during startup
   - Use `if status is-interactive`

3. **Function Optimization**
   - Use `builtin` prefix
   - Cache expensive computations
   - Minimize command substitutions

4. **Event Handlers**
   - Keep preexec/postexec minimal
   - Use global variables for state
   - Avoid spawning processes

5. **Plugin Management**
   - Remove unused plugins
   - Check plugin startup cost
   - Consider alternatives

## Usage Examples

### Basic Performance Check

```fish
# Quick status check
perf status
```

Output shows:
- Current startup time vs target
- Function count
- Configuration stats
- Slow command count
- Quick action recommendations

### Detailed Analysis

```fish
# Full startup analysis
perf profile

# Measure accurate startup time
perf startup

# Get optimization suggestions
perf tips
```

### Function Testing

```fish
# Test a git function
perf function gc "test commit"

# Test port killing
perf function killport 3000

# Test status function
perf function gis
```

### Monitoring Slow Commands

```fish
# View slow command history
perf slow

# Clear slow command log
perf reset

# Or manually
rm ~/.config/fish/slow_commands.log
```

## Configuration

### Slow Command Threshold

Default: 30 seconds

Change threshold:
```fish
# Set to 60 seconds
set -Ux FISH_SLOW_COMMAND_THRESHOLD 60

# Set to 10 seconds (more sensitive)
set -Ux FISH_SLOW_COMMAND_THRESHOLD 10
```

### Event Handlers

The slow command detection uses fish event hooks:
- `fish_preexec`: Captures start time before command
- `fish_postexec`: Calculates duration after command

These are automatically loaded when `slow_command_warning.fish` is sourced.

## Performance Optimization Guide

### Current Configuration Analysis

Your config.fish currently has:
- Multiple `eval` calls (brew shellenv, npm config)
- Several `source` commands
- Command substitutions in PATH setup
- SDKMAN function wrapper

### Recommended Optimizations

1. **Lazy load heavy tools:**
```fish
# Instead of running at startup
function brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
    command brew $argv
    functions -e brew  # Remove wrapper after first use
end
```

2. **Cache PATH setup:**
```fish
# Set PATH once instead of multiple additions
set -gx PATH \
    $HOME/.npm-global/bin \
    $HOME/.cargo/bin \
    $HOME/.sdkman/candidates/maven/current/bin \
    $HOME/.sdkman/candidates/java/current/bin \
    /opt/homebrew/bin \
    /opt/homebrew/sbin \
    $PATH
```

3. **Defer npm config:**
```fish
# Only run when needed
if status is-interactive
    npm config set prefix $HOME/.npm-global &
end
```

4. **Optimize function loading:**
```fish
# Instead of sourcing all functions
# Use fish's autoload feature (functions in functions/ dir)
# Remove explicit source in config.fish
```

## Troubleshooting

### Slow Startup

1. Run profile:
   ```fish
   perf profile
   ```

2. Check bottlenecks:
   - Look for eval warnings
   - Check command substitution count
   - Review source commands

3. Measure impact:
   ```fish
   # Before optimization
   fish_startup_time

   # After optimization
   fish_startup_time
   ```

### Function Performance Issues

1. Profile the function:
   ```fish
   perf function <function_name> [args]
   ```

2. Check for:
   - External command calls
   - Command substitutions
   - Loops with many iterations
   - File I/O operations

3. Optimize:
   - Cache results
   - Use builtins
   - Minimize external calls

### Slow Command Detection Not Working

1. Verify event handlers:
   ```fish
   functions __slow_cmd_preexec
   functions __slow_cmd_postexec
   ```

2. Check threshold:
   ```fish
   echo $FISH_SLOW_COMMAND_THRESHOLD
   ```

3. Re-source function:
   ```fish
   source ~/.config/fish/functions/slow_command_warning.fish
   ```

## Files Created

1. **Functions:**
   - `/Users/davidsamuel.nechifor/.config/fish/functions/perf.fish` - Main dashboard
   - `/Users/davidsamuel.nechifor/.config/fish/functions/fish_startup_time.fish` - Startup timer
   - `/Users/davidsamuel.nechifor/.config/fish/functions/profile_function.fish` - Function profiler
   - `/Users/davidsamuel.nechifor/.config/fish/functions/profile_startup.fish` - Startup profiler
   - `/Users/davidsamuel.nechifor/.config/fish/functions/slow_command_warning.fish` - Slow command detection
   - `/Users/davidsamuel.nechifor/.config/fish/functions/show_slow_commands.fish` - Log viewer
   - `/Users/davidsamuel.nechifor/.config/fish/functions/performance_tips.fish` - Tips generator

2. **Logs:**
   - `~/.config/fish/slow_commands.log` - Slow command history (auto-created)

3. **Documentation:**
   - `/Users/davidsamuel.nechifor/.config/docs/performance-monitoring.md` - This file

## Minimal Overhead Design

The performance monitoring system is designed to have minimal impact:

1. **Event handlers are lightweight:**
   - Only capture timestamps
   - No complex computations during command execution
   - Cleanup happens after command completes

2. **Lazy evaluation:**
   - Functions only loaded when called
   - No startup overhead unless monitoring tools are used

3. **Efficient logging:**
   - Simple file append operations
   - Automatic log rotation (max 100 entries)
   - No database or complex storage

4. **Smart defaults:**
   - 30-second threshold means most commands aren't logged
   - Only warns when necessary
   - Background operations where possible

## Performance Targets

- **Startup time:** < 200ms (Excellent)
- **Function overhead:** < 5ms per function call
- **Event handler overhead:** < 1ms per command
- **Log file size:** < 10KB (100 entries)

## Next Steps

1. Run initial performance check:
   ```fish
   perf status
   ```

2. Measure current startup:
   ```fish
   fish_startup_time
   ```

3. If startup > 200ms, profile:
   ```fish
   profile_startup
   ```

4. Get optimization suggestions:
   ```fish
   performance_tips
   ```

5. Implement recommended optimizations

6. Re-measure to verify improvements

## Advanced Usage

### Custom Performance Tests

```fish
# Time a specific operation
set -l start (date +%s%N)
# ... your operation ...
set -l end (date +%s%N)
set -l duration_ms (math \( $end - $start \) / 1000000)
echo "Operation took: {$duration_ms}ms"
```

### Batch Function Profiling

```fish
# Test multiple functions
for func in gc gis gip
    echo "Testing $func..."
    perf function $func
    echo ""
end
```

### Continuous Monitoring

```fish
# Add to config.fish for daily startup check
if test (random 1 100) -eq 1  # 1% chance
    fish_startup_time 1 &
end
```

## Summary

The performance monitoring system provides:

✓ Comprehensive startup time analysis
✓ Function-level profiling
✓ Automatic slow command detection
✓ Actionable optimization tips
✓ Minimal overhead design
✓ Easy-to-use unified interface

Target achieved when: `perf status` shows "✓ Excellent"
