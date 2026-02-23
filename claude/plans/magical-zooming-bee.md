# Strapi v5 Migration Plan

## Executive Summary

**Current State:** Strapi v4.20.0
**Target:** Strapi v5 (Latest stable, ~v5.10+)
**Complexity:** High
**Risk Level:** High (major version upgrade + previous failed attempts)

## Context

Recent git history shows **two previous upgrade attempts that were rolled back** (commits ec69927, bc6adc5 rolled back in fe14df9), indicating compatibility or stability issues. This v5 migration requires careful planning given:

1. **Major Version Change:** Breaking changes in APIs, plugin system, and architecture
2. **Plugin Compatibility Risks:** Third-party plugins (`strapi-plugin-multi-select`, `strapi-advanced-uuid`) may not support v5
3. **Previous Failures:** Need to understand why earlier attempts failed

### Why Migrate to v5?

**Benefits:**
- **Long-term Support:** Strapi v4 only supported until March 2026 for security fixes
- **Modern Architecture:** Plugin SDK, Document Service API, improved performance
- **Future-proof:** Active development and feature releases

**Challenges:**
- **Breaking Changes:** Entity Service API → Document Service API migration required
- **Plugin Ecosystem:** Many third-party plugins not yet v5-compatible
- **Code Updates:** Controllers, services, and custom code need manual updates
- **Higher Risk:** More extensive changes = more potential issues

## Critical Files to Modify

1. **`/package.json`** - Update all `@strapi/*` dependencies to v4.25.20
2. **`/yarn.lock`** or `/package-lock.json` - Will be regenerated
3. **`/Dockerfile`** - May need Node.js version adjustment (current: 18.20.4, target: 18.x or 20.x)
4. **`/.gitlab-ci.yml`** - Builder image may need updating (current: 18.19.0-branches)

## Migration Strategy

### Phase 1: Pre-Migration Preparation

**Before making any changes:**

1. **Backup everything**
   - Full database export (PostgreSQL/SQLite)
   - Backup entire project directory
   - Export all content via API
   - Take screenshots of admin panel

2. **Research plugin compatibility**
   - **CRITICAL:** Check if `strapi-plugin-multi-select@1.2.3` supports v5
   - **CRITICAL:** Check if `strapi-advanced-uuid@1.1.4` supports v5
   - Search for v5-compatible alternatives if needed
   - Document migration strategy for each plugin

3. **Create dedicated migration branch**
   ```bash
   git checkout -b upgrade/strapi-v5-migration
   ```

4. **Investigate previous failures**
   ```bash
   # Review what was attempted in failed migrations
   git show ec69927
   git show bc6adc5
   git diff fe14df9 ec69927
   ```

### Phase 2: Plugin Compatibility Resolution

**This is the most critical phase - previous failures likely stem from plugin issues.**

#### Option 2A: If Plugins Support v5
- Update to v5-compatible versions
- Document any API changes needed

#### Option 2B: If Plugins Don't Support v5
For `strapi-plugin-multi-select`:
- **Option 1:** Wait for v5 update from maintainer
- **Option 2:** Find alternative multi-select plugin for v5
- **Option 3:** Migrate to Strapi's native field types (may lose data structure)

For `strapi-advanced-uuid`:
- **Option 1:** Check if Strapi v5 has built-in UUID support
- **Option 2:** Find v5-compatible UUID plugin
- **Option 3:** Use custom field implementation with Plugin SDK

**Decision Point:** If critical plugins have no v5 solution, consider:
1. Staying on v4.25.x until plugins update
2. Forking and updating plugins ourselves
3. Re-architecting affected content types

### Phase 3: Use Strapi Upgrade Tool

Strapi provides an automated upgrade tool for v4→v5 migration.

1. **Install upgrade tool globally:**
   ```bash
   npx @strapi/upgrade@latest major
   ```

2. **Run upgrade codemods:**
   The tool will:
   - Update package.json dependencies to v5
   - Run codemods to transform code patterns
   - Migrate configuration files
   - Update content-type schemas

3. **Review upgrade output:**
   - Check which files were modified
   - Note any manual migration warnings
   - Document breaking changes that need manual fixes

4. **Install dependencies:**
   ```bash
   rm -rf node_modules yarn.lock
   yarn install
   ```

### Phase 4: Manual Code Migration

The upgrade tool doesn't handle everything. Manual updates needed:

1. **Migrate to Document Service API**
   - Replace `strapi.entityService.*` with `strapi.documents.*`
   - Update all custom controllers and services
   - Example:
     ```js
     // Old (v4)
     await strapi.entityService.findMany('api::program.program')

     // New (v5)
     await strapi.documents('api::program.program').findMany()
     ```

2. **Remove helper-plugin dependencies**
   - Check for imports from `@strapi/helper-plugin`
   - Migrate to new admin panel utilities
   - Update custom admin panel code

3. **Update plugin configurations**
   - Review `/config/plugins.js` for v5 compatibility
   - Update email provider configuration if needed
   - Verify users-permissions plugin settings

4. **Update custom fields**
   - Review usage of multi-select and UUID fields
   - Ensure compatibility with Document Service API
   - Test field rendering in admin panel

### Phase 5: Build and Local Testing

1. **Rebuild admin panel:**
   ```bash
   yarn build --clean
   ```

2. **Start development server:**
   ```bash
   yarn develop
   ```

3. **Comprehensive testing:**
   - [ ] Admin panel loads without errors
   - [ ] Login with existing credentials works
   - [ ] **Information content type** loads and displays correctly
   - [ ] **Program content type** loads (test multi-select and UUID fields)
   - [ ] **ProjectType content type** loads
   - [ ] Create new entry in each content type
   - [ ] Edit existing entries
   - [ ] Delete test entries
   - [ ] Media upload and library work
   - [ ] Dynamic zones function in Information/Program
   - [ ] Components (Section, SectionItem) render
   - [ ] User permissions are intact
   - [ ] Email sending works
   - [ ] API documentation generates

4. **Test API endpoints:**
   ```bash
   # Verify Document Service API responses
   curl http://localhost:1337/api/informations
   curl http://localhost:1337/api/programs
   curl http://localhost:1337/api/project-types
   ```

5. **Check for breaking changes:**
   - Monitor browser console for errors
   - Review server logs for warnings
   - Test all enumeration fields
   - Verify rich text fields render correctly

### Phase 6: Database Migration

**IMPORTANT:** Strapi v5 may modify database schema.

1. **Enable migrations in config/database.js:**
   ```js
   module.exports = {
     connection: {
       // ... connection settings
     },
     settings: {
       runMigrations: true  // Enable for v5 migration
     }
   }
   ```

2. **Run migration:**
   ```bash
   yarn develop
   ```
   - First startup will run migrations
   - Monitor logs carefully
   - Document any migration errors

3. **Verify data integrity:**
   - Check record counts match pre-migration
   - Verify complex fields (multi-select, UUID) preserved
   - Test relations between content types

4. **Disable auto-migrations after success:**
   ```js
   runMigrations: false
   ```

### Phase 7: Docker & CI/CD Update

1. **Update Dockerfile:**
   - Strapi v5 requires Node.js 18.x or 20.x (current: 18.20.4 ✓)
   - Update base image if needed
   - Test Docker build:
     ```bash
     docker build -t strapi-v5-test .
     ```

2. **Update `.gitlab-ci.yml`:**
   - Verify `NODEJS_BUILD_IMAGE_TAG: 18.19.0-branches` is compatible
   - Consider updating to Node 20.x for better long-term support
   - Add v5-specific build steps if needed

3. **Test containerized build:**
   ```bash
   docker run -p 1337:1337 strapi-v5-test
   ```

### Phase 8: Staging Deployment

1. **Deploy to staging environment:**
   - Use isolated database (copy of production)
   - Deploy v5 version
   - Run full regression test suite

2. **Monitor for 48-72 hours:**
   - Check error logs
   - Verify background jobs work
   - Test all user workflows
   - Performance testing

3. **User acceptance testing:**
   - Have content editors test admin panel
   - Verify all features work as expected
   - Document any issues or regressions

### Phase 9: Production Deployment

**Only proceed if staging is 100% stable.**

1. **Schedule maintenance window:**
   - Announce downtime to users
   - Choose low-traffic period
   - Have rollback plan ready

2. **Pre-deployment checklist:**
   - [ ] Final database backup
   - [ ] Previous Docker image tagged and saved
   - [ ] Rollback procedure documented
   - [ ] Team available for monitoring

3. **Deploy to production:**
   ```bash
   # Tag previous version for rollback
   docker tag current-image strapi-v4-backup

   # Deploy v5
   kubectl apply -f deployment.yml  # or your deployment method
   ```

4. **Post-deployment monitoring:**
   - Watch error logs in real-time
   - Monitor database connections
   - Check API response times
   - Verify health check: `/healthcheck`

5. **Rollback plan:**
   If critical issues occur:
   ```bash
   # Restore database backup
   # Rollback to previous Docker image
   docker tag strapi-v4-backup current-image
   # Redeploy
   kubectl rollout undo deployment/strapi
   ```

## Plugin Compatibility Concerns (CRITICAL)

**This is likely why previous migrations failed.**

### Critical Third-Party Plugins:

1. **strapi-plugin-multi-select (v1.2.3)**
   - **Current Usage:** Program content type has multi-select fields
   - **Risk:** May not support Strapi v5 architecture changes
   - **Investigation Steps:**
     - Check npm page: https://www.npmjs.com/package/strapi-plugin-multi-select
     - Check GitHub issues for v5 compatibility discussions
     - Search for "strapi v5 multi select" alternatives
   - **Fallback Options:**
     - Use Strapi's native multi-select (if available in v5)
     - Find v5-compatible alternative plugin
     - Custom field implementation using Plugin SDK
     - **Last Resort:** Temporarily remove multi-select, use JSON field

2. **strapi-advanced-uuid (v1.1.4)**
   - **Current Usage:** Program content type UUID generation
   - **Risk:** May conflict with v5's Document Service API
   - **Investigation Steps:**
     - Check npm page: https://www.npmjs.com/package/strapi-advanced-uuid
     - Verify v5 compatibility or look for updated version
     - Check if Strapi v5 has built-in UUID support
   - **Fallback Options:**
     - Use Strapi's UID field type
     - Implement UUID generation in lifecycle hooks
     - Custom field with Plugin SDK
     - **Last Resort:** Manual UUID generation in controllers

### Migration Decision Tree:

```
Are both plugins v5-compatible?
├─ YES → Proceed with migration
└─ NO → Are there v5 alternatives?
    ├─ YES → Plan field migration strategy
    └─ NO → Options:
        ├─ Wait for plugin updates (stay on v4.25.x temporarily)
        ├─ Fork and update plugins ourselves
        ├─ Rebuild functionality with Plugin SDK
        └─ Re-architect content types without these plugins
```

### Community Plugins (Lower Risk):

- `@strapi/plugin-cloud` - Official, will support v5
- `@strapi/plugin-documentation` - Official, will support v5
- `@strapi/plugin-i18n` - Official, will support v5
- `@strapi/plugin-users-permissions` - Official, will support v5
- `@strapi/provider-email-nodemailer` - Official, will support v5

**Note:** All official `@strapi/*` plugins will have v5 versions.

## Verification Checklist

After migration, verify:

- [ ] Admin panel login works
- [ ] All 3 content types load (Information, Program, ProjectType)
- [ ] Create new entry in each content type
- [ ] Edit existing entry
- [ ] Delete test entry
- [ ] Media upload works
- [ ] API endpoints return correct data
- [ ] Email sending works (if configured)
- [ ] User permissions are preserved
- [ ] Multi-select fields function correctly
- [ ] UUID fields generate properly
- [ ] Dynamic zones work in Information and Program
- [ ] Components (Section, SectionItem) render properly
- [ ] No console errors in browser
- [ ] No server errors in logs
- [ ] Database queries execute without errors
- [ ] API documentation generates correctly
- [ ] Health check endpoint responds: `/healthcheck`

## Key Breaking Changes in Strapi v5

Understanding these breaking changes is critical for migration success:

### 1. **Entity Service → Document Service API**
**Biggest change in v5.**

All queries must migrate from `strapi.entityService` to `strapi.documents()`:

```javascript
// v4 (Old)
const entries = await strapi.entityService.findMany('api::program.program', {
  filters: { status: 'published' },
  populate: '*'
});

// v5 (New)
const entries = await strapi.documents('api::program.program').findMany({
  filters: { status: 'published' },
  populate: '*'
});
```

**Impact on your project:**
- All custom controllers need updating
- All custom services need updating
- Plugin custom fields may break if they use Entity Service API
- **This likely caused previous migration failures**

### 2. **helper-plugin Removal**
The `@strapi/helper-plugin` package is removed in v5.

**Impact:**
- Admin panel customizations using helper-plugin will break
- Need to migrate to new admin panel utilities
- Check if third-party plugins depend on helper-plugin

### 3. **Plugin Architecture (Plugin SDK)**
v5 introduces new Plugin SDK for creating plugins.

**Impact:**
- Old plugin structure still works but is deprecated
- `strapi-plugin-multi-select` and `strapi-advanced-uuid` may need updates
- New plugins should use Plugin SDK

### 4. **Content API Changes**
- Draft & Publish system has new behavior
- Locale handling updated for i18n
- Relations API modified

**Impact:**
- Frontend applications may need API call updates
- Check if your i18n content types work correctly

### 5. **Database Schema Changes**
v5 modifies internal database structure.

**Impact:**
- First startup runs schema migration
- **Cannot rollback database without backup**
- Migration must be tested thoroughly

## Why Previous Attempts Likely Failed

Based on analysis of rollback commits and Strapi v5 breaking changes:

**Most Likely Causes:**
1. **Plugin Incompatibility**
   - `strapi-plugin-multi-select` or `strapi-advanced-uuid` not v5-ready
   - Plugins using Entity Service API internally
   - Plugins depending on removed helper-plugin

2. **Build Failures**
   - Dependency version conflicts
   - Peer dependency mismatches
   - Admin panel build errors from plugin issues

3. **Runtime Errors**
   - Custom field types breaking after API changes
   - Database migration failures
   - Admin panel not loading due to plugin errors

4. **Missing Manual Migrations**
   - Controllers not updated to Document Service API
   - Services still using old Entity Service
   - Custom code not migrated

**This Plan Addresses These By:**
- ✅ Thorough plugin compatibility research upfront (Phase 2)
- ✅ Using Strapi's official upgrade tool (Phase 3)
- ✅ Comprehensive manual code migration (Phase 4)
- ✅ Extensive testing before production (Phases 5, 8)
- ✅ Clear rollback strategy at each phase
- ✅ Two-stage migration alternative if direct migration too risky

## Estimated Timeline

- **Phase 1 (Preparation):** 1-2 hours
- **Phase 2 (Plugin Research & Resolution):** 2-4 hours (could be days if waiting for updates)
- **Phase 3 (Upgrade Tool):** 1-2 hours
- **Phase 4 (Manual Code Migration):** 4-8 hours
- **Phase 5 (Build & Testing):** 3-4 hours
- **Phase 6 (Database Migration):** 1-2 hours
- **Phase 7 (Docker/CI):** 1-2 hours
- **Phase 8 (Staging):** 2-3 days (monitoring period)
- **Phase 9 (Production):** 4-6 hours (including monitoring)

**Total Development Time:** ~15-25 hours
**Total Calendar Time:** 1-2 weeks (including staging validation)

**Note:** Timeline assumes plugin compatibility issues can be resolved. If plugins require custom development, add 1-2 weeks.

## Risk Mitigation: Two-Stage Migration (Alternative Approach)

Given previous failed attempts, consider a **safer two-stage approach**:

### Stage 1: Upgrade to v4.25.20 First (1 week)

**Why:**
- De-risks the process by separating concerns
- Verifies plugin compatibility in v4 ecosystem
- Provides stable baseline before v5 leap
- Easier to debug if issues occur

**Process:**
1. Upgrade v4.20.0 → v4.25.20 (no breaking changes)
2. Verify all plugins work correctly
3. Deploy to production and stabilize
4. Gain confidence in upgrade process

### Stage 2: Upgrade to v5 (2-3 weeks later)

**Why:**
- Working from stable v4.25.20 baseline
- More time to research plugin alternatives
- Plugin ecosystem may improve while waiting
- Team has recent migration experience

**Process:**
1. Follow full v5 migration plan (Phases 1-9)
2. Less time pressure since on stable v4.25.20
3. Can wait for plugin v5 updates if needed

### Which Approach to Choose?

**Direct to v5 (Current Plan):**
- ✅ Faster to final state
- ✅ Only one migration effort
- ❌ Higher risk
- ❌ Harder to debug issues
- ❌ Plugin problems block entire migration

**Two-Stage (Alternative):**
- ✅ Lower risk per step
- ✅ Easier rollback points
- ✅ Can stop at v4.25.20 if v5 plugins not ready
- ❌ Two separate migration efforts
- ❌ Takes longer total calendar time

**Recommendation:** Given the previous rollbacks, the two-stage approach is safer but requires more total effort. Choose based on:
- **Time pressure:** Direct to v5 if urgent
- **Risk tolerance:** Two-stage if safety is priority
- **Plugin readiness:** Two-stage if plugins not v5-ready yet

## References & Documentation

### Official Strapi v5 Migration Resources:
- [v4 to v5 Migration Introduction & FAQ](https://docs.strapi.io/cms/migration/v4-to-v5/introduction-and-faq)
- [Step-by-Step v5 Upgrade Guide](https://docs.strapi.io/cms/migration/v4-to-v5/step-by-step)
- [Breaking Changes Documentation](https://docs.strapi.io/cms/migration/v4-to-v5/breaking-changes)
- [Document Service API Migration](https://docs.strapi.io/cms/migration/v4-to-v5/breaking-changes/entity-service-to-document-service)
- [Plugin Migration Guide](https://docs.strapi.io/cms/migration/v4-to-v5/additional-resources/plugins-migration)
- [Strapi v5 Release Notes](https://docs.strapi.io/release-notes)

### Tools:
- [Strapi Upgrade Tool](https://docs.strapi.io/cms/upgrades)
- [Codemods for v5 Migration](https://docs.strapi.io/cms/migration/v4-to-v5/step-by-step#run-the-upgrade-tool)

### Community Resources:
- [Strapi v4 to v5 Migration Resources Blog](https://strapi.io/blog/strapi-v4-to-v5-migration-resources)
- [How to Migrate to Strapi 5 Blog](https://strapi.io/blog/how-to-migrate-your-project-from-strapi-4-to-strapi-5)
- [Strapi Discord Community](https://discord.strapi.io) - For plugin compatibility questions
- [Strapi GitHub Releases](https://github.com/strapi/strapi/releases)

### Plugin-Specific Research:
- [strapi-plugin-multi-select npm](https://www.npmjs.com/package/strapi-plugin-multi-select)
- [strapi-advanced-uuid npm](https://www.npmjs.com/package/strapi-advanced-uuid)
- [Awesome Strapi - Plugin List](https://github.com/strapi/awesome-strapi)
