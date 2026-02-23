# Complete Removal of Quiz Functionality

## Context

This project has an extensive quiz system that was recently migrated from a standalone Quiz content type to a page-based architecture where quizzes are embedded as Page content with `pageType="quiz"`. The user has requested complete removal of all quiz functionality including:

- The legacy Quiz API (`/src/api/quiz/`)
- Quiz components used by pages (`/src/components/quiz/`)
- Quiz-related fields in the Page content type
- All quiz data (5 quiz pages in Romanian and English)
- Migration scripts and documentation

The quiz system is no longer needed. Complete removal will simplify the codebase and reduce maintenance burden.

## Critical Files

**Files to Modify:**
- `/src/api/page/content-types/page/schema.json` - Remove quiz fields (pageType enum "quiz", quizConfig, quizLanding)
- `/src/api/page/controllers/page.js` - Remove quiz populate queries (lines 52-61)

**Directories to Delete:**
- `/src/api/quiz/` - Legacy Quiz content type (controllers, services, routes, schema)
- `/src/components/quiz/` - Quiz components (quiz-config, quiz-landing, question, option)
- `/scripts/` - Quiz migration scripts (3 files)
- `/docs/` - Quiz documentation (6 files)

## Implementation Plan

### Phase 1: Backup (Safety First)

**Create database backup:**
```bash
# For SQLite (check if .tmp/data.db exists)
cp .tmp/data.db .tmp/data.db.backup-$(date +%Y%m%d)

# For PostgreSQL (if using)
pg_dump strapi > backup-$(date +%Y%m%d).sql
```

**Export quiz data for records:**
```bash
# Ensure Strapi is running
npm run develop &

# Export quiz pages (update token if needed)
node scripts/export-quiz-backup.js
```

### Phase 2: Delete Quiz Data

**Delete quiz pages from database** (Strapi must be running):

Use Strapi API to delete all pages where `pageType="quiz"`:
- Delete quiz-actions (ro, en)
- Delete quiz-etf (ro, en)
- Delete quiz-fond (ro, en)
- Delete quiz-state-title (ro, en)
- Delete quiz-volatility (ro, en)

**Delete legacy quiz content** (if exists):

Query `/api/quizzes` and delete all entries.

**Stop Strapi** before code changes:
```bash
pkill -f "strapi develop"
```

### Phase 3: Update Page Content Type

**Edit `/src/api/page/content-types/page/schema.json`:**

1. **Line 71**: Remove "quiz" from pageType enum:
   ```json
   "enum": ["landing", "detail"]
   ```

2. **Lines 113-122**: Delete entire `quizConfig` field

3. **Lines 123-132**: Delete entire `quizLanding` field

**Edit `/src/api/page/controllers/page.js`:**

1. **Lines 52-60**: Delete `quizConfig` populate block
2. **Line 61**: Delete `quizLanding: true`

### Phase 4: Remove Quiz Code

**Delete directories:**
```bash
rm -rf src/api/quiz/
rm -rf src/components/quiz/
```

**Delete migration scripts:**
```bash
rm scripts/migrate-quizzes-to-pages.js
rm scripts/link-quizzes.js
rm scripts/seed-quiz-pages.js
```

**Delete documentation:**
```bash
rm docs/PAGE_QUIZ_SETUP.md
rm docs/QUICK_START_PAGE_QUIZ.md
rm docs/SUMMARY_PAGE_QUIZ_ARCHITECTURE.md
rm docs/QUIZ_MIGRATION.md
rm docs/QUIZ_MIGRATION_SUMMARY.md
rm docs/ARCHITECTURE_CHANGES.md
rm docs/seed-quiz-pages.js
```

**Clean test file:**
- Remove quiz tests from `test-populate.js` or delete the entire file if it's quiz-only

### Phase 5: Clean and Restart

**Clear Strapi cache:**
```bash
rm -rf .cache build
```

**Restart Strapi:**
```bash
npm run develop
```

**Watch for errors:**
- No schema sync errors
- No missing component errors
- Successful startup on http://localhost:1337

### Phase 6: Verification

**Admin Panel Verification:**

1. Open http://localhost:1337/admin
2. Content Manager → Pages:
   - No "Quiz Config" field
   - No "Quiz Landing" field
   - pageType dropdown shows only "landing" and "detail"
3. Content-Types Builder:
   - No "Quiz" content type
   - No quiz components in Components section

**API Verification:**

```bash
# Legacy quiz endpoint should return 404
curl http://localhost:1337/api/quizzes

# Quiz pages should not exist
curl "http://localhost:1337/api/pages?filters[pageType][$eq]=quiz"
# Expected: {"data":[],"meta":{"pagination":{"total":0}}}

# Regular pages should work normally
curl "http://localhost:1337/api/pages?filters[pageType][$eq]=landing&populate=deep"
# Expected: Full page data with hero, contentSections, hits, seo (no quiz fields)

# Test findBySlug custom route
curl http://localhost:1337/api/pages/find/investment?locale=en
# Expected: Page data without quiz fields
```

**Functionality Verification:**

- Create a new landing page → Should work
- Create a new detail page → Should work
- Edit existing pages → Should work
- Query pages with populate=deep → Should work
- No quiz fields visible anywhere

### Phase 7: Database Cleanup (Optional)

After verifying Strapi works, optionally drop orphaned component tables:

```sql
-- For SQLite
DROP TABLE IF EXISTS quizzes;
DROP TABLE IF EXISTS quizzes_localizations_links;
DROP TABLE IF EXISTS components_quiz_quiz_landings;
DROP TABLE IF EXISTS components_quiz_quiz_configs;
DROP TABLE IF EXISTS components_quiz_questions;
DROP TABLE IF EXISTS components_quiz_options;
DROP TABLE IF EXISTS components_quiz_questions_components;
```

**Only run after full verification** to avoid data loss.

### Phase 8: Commit

```bash
git add -A
git commit -m "feat: remove all quiz functionality from Strapi

BREAKING CHANGE: Complete removal of quiz system

Removed:
- Legacy Quiz content type (src/api/quiz/)
- Quiz components (src/components/quiz/)
- Quiz-related Page fields (quizConfig, quizLanding, pageType enum 'quiz')
- Migration scripts (migrate-quizzes-to-pages.js, link-quizzes.js, seed-quiz-pages.js)
- Quiz documentation (6 markdown files)
- Quiz data from database (5 quiz pages in ro/en)

Updated:
- Page content type schema (removed quiz fields)
- Page controller (removed quiz populate queries)

Non-quiz pages continue to work without any changes.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

## Reusable Code Patterns

The Page content type uses a flexible component-based architecture:
- `hero`: Shared hero component
- `contentSections`: Section info with nested cards and assets
- `hits`: Repeatable hits component
- `seo`: SEO metadata with images

This pattern should be maintained. Quiz removal simplifies the schema back to the core page architecture.

## Rollback Plan

If issues arise:

**Option 1: Database Backup**
```bash
cp .tmp/data.db.backup-YYYYMMDD .tmp/data.db
```

**Option 2: Git Revert**
```bash
git revert HEAD
```

**Option 3: Restore from JSON backups**

Use exported JSON to recreate quiz pages through Strapi admin.

## Success Criteria

- ✅ Strapi starts without errors
- ✅ Admin panel loads correctly
- ✅ Page content type shows only "landing" and "detail" in pageType
- ✅ No quiz-related fields in Page schema
- ✅ Quiz content type not visible in admin
- ✅ Quiz components not in Component list
- ✅ `/api/quizzes` returns 404
- ✅ `/api/pages` with landing/detail pages works normally
- ✅ All non-quiz pages render correctly with full populate
- ✅ No console errors in browser or terminal
- ✅ Custom findBySlug route works for non-quiz pages

## Breaking Changes

**For Frontend:**

If an Angular/React frontend uses quiz endpoints or displays quiz pages:
- `/api/quizzes` endpoint will no longer exist
- Quiz page slugs (quiz-actions, quiz-etf, etc.) will return 404
- Quiz-related Page fields (quizConfig, quizLanding) will not be in API responses

Frontend must be updated before or alongside this change.

**For Backend:**

- No breaking changes for non-quiz pages
- Landing and detail pages continue to work identically
- All shared components (hero, seo, contentSections, hits) unaffected

## Notes

- **Order matters**: Delete data before removing schema to avoid orphaned references
- **Strapi must be running**: For data deletion (Phase 2)
- **Strapi must be stopped**: For code changes (Phases 3-4)
- **Cache clearing is critical**: Old schema cached can cause errors
- **Backup is essential**: No automated rollback after data deletion
