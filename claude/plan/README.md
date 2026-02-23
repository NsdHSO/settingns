# Multi-Role Review Framework

A comprehensive quality gate system for software development that enforces rigorous technical and product reviews through specialized roles during planning and verification phases.

---

## Framework Overview

The Multi-Role Review Framework implements a **multi-stage quality assurance process** with specialized reviewers that act at critical decision points:

1. **Planning Phase Reviews** (before implementation begins)
   - **TA (Technical Architect)** reviews technical soundness, architecture, and feasibility
   - **Owner (Product Owner)** reviews requirements alignment, scope clarity, and user value
   - Both must approve before proceeding to implementation

2. **Verification Phase Reviews** (before marking work complete)
   - **20 Specialized Directors** review implementation quality from different perspectives
   - Directors run as **parallel Task agents** for efficiency
   - Each Director focuses on their domain expertise
   - Only relevant Directors are selected based on work type

**Key Principle:** Prevent problems through early architectural/product review (Planning), and catch implementation issues through specialized inspection (Verification).

---

## The Three Review Roles

### 1. Technical Architect (TA)

**When:** During planning phase, after initial design is proposed

**Purpose:** Ensure the technical approach is sound, feasible, and maintainable

**What TA Reviews:**
- **Technical Feasibility:** Can this actually be built with available technology and resources?
- **Architecture Decisions:** Is the system design appropriate and scalable?
- **Technology Choices:** Are the selected technologies suitable and sustainable?
- **Design Patterns:** Are patterns used correctly and appropriately?
- **Code Organization:** Is the structure logical and maintainable?
- **Performance & Scalability:** Will this handle expected load and growth?
- **Security & Data Protection:** Are security fundamentals addressed?
- **Maintainability & DevOps:** Can this be deployed, monitored, and maintained?

**TA Authority:**
- Block planning if technical approach is fundamentally flawed
- Require architectural changes before implementation
- Flag technical risks and constraints
- Approve technical soundness

**Template:** `/Users/davidsamuel.nechifor/.claude/plan/ta/technical-analysis-template.md`

---

### 2. Product Owner (Owner)

**When:** During planning phase, after TA review passes

**Purpose:** Ensure we're building the right thing for the right users with clear success criteria

**What Owner Reviews:**
- **Requirements Alignment:** Does this solve an actual user problem with validated need?
- **Scope Clarity:** Are boundaries clear? Is scope appropriately sized?
- **Success Criteria:** Are metrics measurable, meaningful, and achievable?
- **User Needs:** Do we understand users and serve their actual needs?
- **Value Proposition:** Is delivered value worth the effort?
- **Risk & Constraints:** Are adoption, business, and resource risks acceptable?
- **Requirements Documentation:** Are requirements clear, complete, and testable?

**Owner Authority:**
- Block planning if requirements are vague or don't serve user needs
- Require additional user research or validation
- Flag scope issues (too large, too small, or poorly defined)
- Approve product/user alignment

**Template:** `/Users/davidsamuel.nechifor/.claude/plan/owner/requirements-review-template.md`

---

### 3. Directors (20 Specialized Reviewers)

**When:** During verification phase, after implementation is complete

**Purpose:** Review implementation quality from specialized perspectives before marking work complete

**How Directors Work:**
- Directors are spawned as **parallel Task agents** for efficiency
- Each Director independently reviews using their specialized template
- Directors focus on IMPLEMENTATION quality, not design decisions
- Only relevant Directors are selected (not all 20 for every task)
- Directors coordinate findings but review independently

**Director Roster:**

| Director | Focus Area | When to Use |
|----------|-----------|-------------|
| **Architecture** | System design, component organization, patterns | Backend, full-stack, new components, refactoring |
| **Security** | Vulnerabilities, auth, data protection, OWASP | Backend, API, auth changes, data handling |
| **Performance** | Speed, optimization, resource usage, bottlenecks | Backend, database queries, high-traffic features |
| **Testing** | Test coverage, quality, edge cases | All production code, bug fixes, new features |
| **Code Quality** | Readability, maintainability, best practices | All code changes |
| **Data Design** | Data models, schema design, data flow | Database changes, data modeling |
| **API Design** | API contracts, REST principles, versioning | API endpoints, integrations |
| **DevOps** | CI/CD, deployment, infrastructure as code | Deployment changes, pipeline modifications |
| **Frontend** | UI/UX, component design, browser compatibility | UI changes, component libraries |
| **Backend** | Server logic, business rules, service architecture | Backend services, business logic |
| **Database** | Query optimization, indexing, migrations | Database queries, schema changes |
| **Infrastructure** | Scaling, reliability, cloud resources | Infrastructure changes, scaling work |
| **Documentation** | Code comments, API docs, user guides | Public APIs, complex features, libraries |
| **Standards Compliance** | Coding standards, conventions, style guides | All code (style, linting) |
| **Accessibility** | WCAG compliance, screen readers, keyboard nav | UI changes, user-facing features |
| **Scalability** | Growth handling, load capacity, horizontal scaling | High-growth features, architecture changes |
| **Maintainability** | Code clarity, refactoring needs, technical debt | Large changes, refactoring |
| **Error Handling** | Exception handling, recovery, user feedback | Error-prone code, user-facing features |
| **Monitoring** | Logging, metrics, alerting, observability | Production features, critical paths |
| **Deployment** | Release process, rollback strategy, zero-downtime | Deployment changes, release process |

**Director Templates:** All templates in `/Users/davidsamuel.nechifor/.claude/plan/directors/`

---

## When Reviews Trigger

### Planning Phase (Before Implementation)

```
User Request → Design Proposal → TA Review → Owner Review → Approved → Writing-Plans → Implementation
                                      ↓            ↓
                                   Needs         Needs
                                  Revision      Revision
```

**Sequence:**
1. Initial design/plan is created
2. **TA reviews technical approach** - Must approve before Owner review
3. **Owner reviews requirements/product fit** - Must approve before implementation
4. Both approvals required to proceed to writing-plans
5. Reviews documented in `plan/reviews/<date>-<topic>-planning.md`

**Integration:** Works with `superpowers:brainstorming` skill - reviews happen during planning phase

---

### Verification Phase (Before Completion)

```
Implementation Complete → Select Directors → Parallel Reviews → All Pass → Mark Complete
                                ↓                    ↓
                          Spawn as Tasks      Find Issues → Fix → Re-review
```

**Sequence:**
1. Implementation is complete
2. **Select relevant Directors** based on work type
3. **Spawn Directors as parallel Task agents** for concurrent review
4. Each Director independently reviews their domain
5. Critical issues block completion, must be fixed and re-reviewed
6. Reviews documented in `plan/reviews/<date>-<topic>-verification.md`

**Integration:** Works with `superpowers:verification-before-completion` skill - reviews happen before marking tasks complete

---

## Directory Structure

```
/Users/davidsamuel.nechifor/.claude/plan/
├── README.md                          # This file - framework overview
├── ta/
│   └── technical-analysis-template.md # TA review checklist and guide
├── owner/
│   └── requirements-review-template.md # Owner review checklist and guide
├── directors/
│   ├── architecture.md                # System design, component organization
│   ├── security.md                    # Vulnerabilities, auth, data protection
│   ├── performance.md                 # Speed, optimization, bottlenecks
│   ├── testing.md                     # Test coverage, quality, edge cases
│   ├── code-quality.md                # Readability, maintainability
│   ├── data-design.md                 # Data models, schema design
│   ├── api-design.md                  # API contracts, REST principles
│   ├── devops.md                      # CI/CD, deployment, IaC
│   ├── frontend.md                    # UI/UX, component design
│   ├── backend.md                     # Server logic, business rules
│   ├── database.md                    # Query optimization, indexing
│   ├── infrastructure.md              # Scaling, reliability, cloud
│   ├── documentation.md               # Code comments, API docs
│   ├── standards-compliance.md        # Coding standards, style guides
│   ├── accessibility.md               # WCAG compliance, a11y
│   ├── scalability.md                 # Growth handling, load capacity
│   ├── maintainability.md             # Code clarity, technical debt
│   ├── error-handling.md              # Exception handling, recovery
│   ├── monitoring.md                  # Logging, metrics, alerting
│   └── deployment.md                  # Release process, rollback
└── reviews/
    ├── <date>-<topic>-planning.md     # TA + Owner reviews
    ├── <date>-<topic>-verification.md # Directors reviews
    └── EXAMPLE-*.md                   # Example reviews for reference
```

**Note:** The entire `plan/*` directory is excluded from git via `.gitignore` - reviews are for reference, not version control.

---

## How to Read Templates

Each template (TA, Owner, Directors) follows a consistent structure:

### Template Structure

1. **Role Description**
   - What this role focuses on
   - When this review happens (planning vs verification)
   - Authority and scope of the reviewer

2. **Review Checklist**
   - Comprehensive checklist of items to evaluate
   - Organized by category/concern area
   - Each item is a specific question or criterion

3. **Examples of Issues to Catch**
   - Real code examples showing GOOD vs BAD
   - Illustrates what the role should flag
   - Provides concrete patterns to recognize

4. **Success Criteria**
   - What constitutes a passing review
   - Quality standards that must be met
   - When to approve vs require changes

5. **Failure Criteria**
   - What blocks approval
   - Critical issues that must be fixed
   - When to reject vs request revisions

6. **Applicability Rules** (Directors only)
   - When to invoke this Director
   - When to skip this Director
   - Coordination with other Directors

### How to Use a Template

**For TA/Owner (Planning Phase):**
1. Read the entire template to understand the role
2. Go through each checklist section systematically
3. Note any concerns, risks, or issues discovered
4. Refer to examples to clarify what to flag
5. Use approval decision framework to determine outcome
6. Document findings in a review document

**For Directors (Verification Phase):**
1. Check applicability rules - should this Director review this work?
2. If applicable, review the specific domain area
3. Use checklist to identify issues
4. Compare against success/failure criteria
5. Coordinate with other Directors to avoid duplicate findings
6. Report issues with severity (blocking vs warning)

---

## Smart Director Selection Guide

**Don't invoke all 20 Directors for every task.** Select Directors relevant to the work being verified.

### Selection Strategy

#### Always Include (Core Quality)
- **Architecture** - For any non-trivial code changes
- **Security** - For backend, API, or data handling
- **Code Quality** - For all production code
- **Testing** - For all production code

#### Add Based on Work Type

**Backend/API Work:**
- Backend, API Design, Database, Security, Performance, Error Handling

**Frontend Work:**
- Frontend, Accessibility, Standards Compliance, Performance (client-side)

**Full-Stack Features:**
- Architecture, Backend, Frontend, API Design, Database, Testing, Security

**Database Changes:**
- Database, Data Design, Performance, Security (data protection)

**Infrastructure/Deployment:**
- Infrastructure, DevOps, Deployment, Monitoring, Scalability

**Refactoring:**
- Architecture, Code Quality, Testing, Maintainability

**Public APIs/Libraries:**
- API Design, Documentation, Testing, Standards Compliance, Security

**Critical User Features:**
- Architecture, Testing, Security, Accessibility, Error Handling, Monitoring

### Example Selections

| Work Type | Directors to Include |
|-----------|---------------------|
| New API endpoint | API Design, Security, Backend, Testing, Code Quality, Documentation |
| UI component library | Frontend, Accessibility, Standards Compliance, Testing, Documentation |
| Database migration | Database, Data Design, Backend, Testing, Deployment |
| Payment processing | Security, Backend, Testing, Error Handling, Monitoring, Architecture |
| Performance optimization | Performance, Architecture, Testing, Code Quality |
| Infrastructure scaling | Infrastructure, Scalability, DevOps, Monitoring, Deployment |

**Rule of Thumb:** Select 4-8 Directors per verification. More for critical/complex work, fewer for simple changes.

---

## Integration with Superpowers Skills

This framework enhances existing superpowers skills with quality gates:

### Integration with `brainstorming` Skill

**When planning any project:**

1. User provides requirements
2. Brainstorming skill generates design/plan
3. **→ TA Review** (technical soundness check)
   - If rejected: Revise technical approach
   - If approved: Proceed to Owner review
4. **→ Owner Review** (requirements/product check)
   - If rejected: Revise requirements/scope
   - If approved: Proceed to writing-plans
5. Writing-plans creates implementation tasks
6. Implementation begins

**Benefit:** Prevents technically infeasible or product-misaligned implementations before any code is written.

---

### Integration with `verification-before-completion` Skill

**When completing any work:**

1. Implementation finished
2. Developer/agent claims work complete
3. **→ Director Selection** (based on work type)
4. **→ Parallel Director Reviews** (spawned as Task agents)
   - Each Director independently reviews their domain
   - Directors report findings concurrently
5. **→ Consolidate Findings**
   - Critical issues: Block completion, must fix
   - High issues: Should fix before merge
   - Medium/Low issues: Document for later or fix opportunistically
6. **→ Decision:**
   - All critical issues resolved → Mark complete
   - Critical issues remain → Return to implementation
7. Document verification review

**Benefit:** Catches implementation issues before they reach production, ensuring code quality across multiple dimensions.

---

## Usage Examples

### Example 1: Planning a New Feature

```
User: "Build a user authentication system with OAuth"

Brainstorming Skill:
- Generates design with JWT tokens, OAuth 2.0 flow, database schema

TA Review (Technical Analysis):
✓ Technical feasibility: OAuth libraries available, JWT standard
✓ Architecture: Clean separation of auth service from business logic
✓ Technology choices: Passport.js appropriate, PostgreSQL for user data
⚠ Security: Need to add refresh token rotation and secure token storage
⚠ Performance: Add caching for token validation
→ APPROVED WITH CHANGES

Owner Review (Requirements):
✓ Requirements alignment: Solves user login problem
✓ Scope clarity: OAuth providers defined (Google, GitHub)
✓ Success criteria: Login success rate, token security
⚠ User needs: Should support email/password fallback for non-OAuth users
→ APPROVED WITH CLARIFICATIONS

Result: Proceed to writing-plans with TA/Owner feedback incorporated
```

---

### Example 2: Verifying a Backend API Implementation

```
Work Complete: New REST API for order processing

Director Selection:
- API Design (REST endpoints)
- Security (auth, data validation)
- Backend (business logic)
- Database (query optimization)
- Testing (coverage)
- Code Quality (readability)
- Error Handling (edge cases)
- Monitoring (logging)

Parallel Director Reviews:

API Design Director:
✓ RESTful design correct
✓ Versioning in place
✗ Missing HATEOAS links (minor)
→ PASS

Security Director:
✗ SQL injection risk in order filtering (CRITICAL)
✗ Missing authorization check for order access (CRITICAL)
⚠ API rate limiting not configured (HIGH)
→ BLOCK - Fix critical issues

Backend Director:
✓ Business logic well-separated
✓ Service layer clean
⚠ Order validation could be more robust (MEDIUM)
→ PASS

Database Director:
✗ Missing index on orders.customer_id (HIGH)
⚠ N+1 query in order items fetching (HIGH)
→ NEEDS FIXES

Testing Director:
✓ Happy path covered
✗ Missing edge case tests (empty cart, invalid payment)
⚠ No integration test for full order flow
→ NEEDS ADDITIONAL TESTS

Result: BLOCKED - Must fix:
1. SQL injection vulnerability (Security)
2. Authorization check (Security)
3. Database index (Database)
4. Edge case tests (Testing)

After fixes applied → Re-review → APPROVED
```

---

## Best Practices

### For Planning Reviews

1. **Run TA before Owner** - Technical feasibility must be established before validating product requirements
2. **Don't skip reviews for "small" changes** - Small features can have big technical or product implications
3. **Document decisions** - Capture why certain approaches were chosen or rejected
4. **Iterate if needed** - It's okay to revise designs multiple times based on feedback

### For Verification Reviews

1. **Select Directors thoughtfully** - More Directors ≠ better quality, focus on relevance
2. **Let Directors run in parallel** - Don't review sequentially, spawn as Task agents
3. **Triage findings** - Not all issues are blocking, prioritize critical/high severity
4. **Don't skip verification for "trivial" changes** - Bugs often hide in "simple" code
5. **Use consistent severity levels** - CRITICAL (blocks), HIGH (should fix), MEDIUM (nice to fix), LOW (optional)

### General Guidelines

1. **Reviews are not adversarial** - Goal is quality improvement, not blame
2. **Be specific in findings** - "Code quality poor" is useless, "Function X is 300 lines, should be split" is actionable
3. **Provide examples** - Show what good looks like when flagging issues
4. **Balance perfection with pragmatism** - Perfect code doesn't exist, focus on meaningful quality
5. **Keep reviews focused** - TA reviews technical, Owner reviews product, Directors review implementation

---

## Review Documentation Format

### Planning Reviews

**Filename:** `plan/reviews/<date>-<topic>-planning.md`

**Contents:**
- Project/feature name
- Date of review
- TA Review section (technical findings)
- Owner Review section (product findings)
- Consolidated decision (proceed/revise/reject)
- Action items for design revision if needed

### Verification Reviews

**Filename:** `plan/reviews/<date>-<topic>-verification.md`

**Contents:**
- Project/feature name
- Date of review
- Directors selected (and why)
- Individual Director findings
- Consolidated issues list (grouped by severity)
- Overall verification decision (pass/blocked)
- Required fixes before approval

---

## Frequently Asked Questions

**Q: Do I need all 20 Directors for every change?**
A: No! Select 4-8 relevant Directors based on work type. See "Smart Director Selection Guide" above.

**Q: What if TA and Owner disagree?**
A: TA and Owner review different aspects. TA can approve technical approach while Owner requests product changes, or vice versa. Both must ultimately approve.

**Q: Can Directors override each other?**
A: No, Directors review independent domains. Security blocking for vulnerabilities doesn't override Architecture approving design. Fix all critical issues across all Directors.

**Q: How long should reviews take?**
A: Planning reviews (TA/Owner): 15-30 minutes for thorough analysis. Verification reviews: 5-10 minutes per Director, run in parallel.

**Q: What if I disagree with a Director's finding?**
A: Directors use objective checklists and criteria. If you believe a finding is incorrect, document your reasoning and provide evidence the criterion is actually met.

**Q: Should I create review documents for every change?**
A: Yes for non-trivial work. Skip for truly trivial changes (typo fixes, copy updates). When in doubt, create the review.

**Q: Can I customize Director templates?**
A: Yes! Templates are guidelines. Adapt to your project needs, but maintain the core review principles.

---

## Summary

The Multi-Role Review Framework provides **two layers of quality gates**:

1. **Planning Phase:** TA + Owner ensure we design the right thing the right way
2. **Verification Phase:** Directors ensure we built it correctly across multiple dimensions

**Key Benefits:**
- Catch architectural and product issues before implementation
- Multi-perspective quality verification before completion
- Parallel review execution for efficiency
- Comprehensive coverage across technical, product, and quality domains
- Documented decision-making and quality standards

**Integration:** Works seamlessly with superpowers skills (brainstorming, verification-before-completion) to create quality gates at critical decision points.

**Philosophy:** Quality is everyone's job, but specialized expertise catches issues generalists miss. This framework systematizes that expertise into a repeatable process.

---

**Framework Version:** 1.0
**Last Updated:** 2026-02-18
**Maintained By:** Claude Code Framework Team
