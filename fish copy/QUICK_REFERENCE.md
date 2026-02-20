# Language Version Manager - Quick Reference

## TL;DR

**Before:** Shell startup ~500ms
**After:** Shell startup <50ms
**How:** Lazy-loading NVM and SDKMAN

---

## Common Commands

### Check Versions
```fish
versions                    # Show all language versions
```

### NVM (Node.js)
```fish
node --version             # Lazy-loads NVM automatically
npm install                # Also triggers lazy-load
nvm use 20.11.0            # Switch Node version
nvm install 20.11.0        # Install Node version
nvm list                   # List installed versions
nvm_use_auto               # Use .nvmrc from current directory
```

### SDKMAN (Java/Maven)
```fish
java -version              # Already in PATH (no lazy-load needed)
mvn --version              # Already in PATH
sdk use java 21.0.1        # Switch Java version
sdk install java 21.0.1    # Install Java version
sdk list java              # List available versions
sdk_use_auto               # Use .sdkmanrc from current directory
```

---

## Project Setup

### Node.js Projects

Create `.nvmrc`:
```
20.11.0
```

Auto-switches when you `cd` into the directory!

### Java Projects

Create `.sdkmanrc`:
```
java=21.0.1
maven=3.9.6
```

Run `sdk_use_auto` to switch!

---

## Files Created

**Configuration:**
- `conf.d/lazy_nvm.fish` - NVM lazy loading
- `conf.d/lazy_sdkman.fish` - SDKMAN optimization

**Functions:**
- `functions/versions.fish` - Show all versions
- `functions/nvm_use_auto.fish` - Detect .nvmrc
- `functions/sdk_use_auto.fish` - Detect .sdkmanrc

**Cache:**
- `~/.cache/nvm_current_version` - Current Node version
- `~/.cache/sdk_versions` - Current Java/Maven versions

**Documentation:**
- `README_VERSION_MANAGERS.md` - Full guide
- `OPTIMIZATION_SUMMARY.md` - Detailed summary
- `QUICK_REFERENCE.md` - This file

---

## Troubleshooting

**Slow startup?**
```fish
time fish -c exit          # Should be <100ms
```

**NVM not loading?**
```fish
node --version             # Triggers lazy load
```

**Clear cache?**
```fish
rm ~/.cache/nvm_current_version ~/.cache/sdk_versions
exec fish
```

---

## Testing

Run automated tests:
```bash
bash ~/.config/fish/test_version_managers.sh
```

---

## More Info

See `README_VERSION_MANAGERS.md` for complete documentation.
