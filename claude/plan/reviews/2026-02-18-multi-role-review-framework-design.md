# Multi-Role Review Framework Design

**Date:** 2026-02-18
**Status:** Approved
**Purpose:** Enforce quality through parallel expert reviews integrated into Claude's workflow

---

## Overview

A comprehensive review framework integrated into the global Claude configuration that enforces quality through multi-role expert reviews. The framework operates in two phases: sequential TA+Owner review during planning, and parallel Directors review during verification.

## Core Architecture

### Roles & Responsibilities

**TA (Technical Analysis) - Sequential**
- Reviews technical approach during planning phase
- Analyzes: technical feasibility, architecture decisions, technology choices, design patterns
- Executes before design approval

**Owner - Sequential**
- Validates requirements and goals alignment
- Analyzes: requirements clarity, scope definition, success criteria, user needs
- Executes with TA during planning phase

**Directors (20 Roles) - Parallel Task Agents**
All Directors execute simultaneously as independent Task agents during verification:

1. **Architecture Director** - System design, component organization, patterns
2. **Security Director** - Vulnerabilities, auth, data protection, OWASP compliance
3. **Performance Director** - Speed, optimization, resource usage, bottlenecks
4. **Testing Director** - Test coverage, test quality, edge cases
5. **Code Quality Director** - Readability, maintainability, best practices
6. **Data Design Director** - Data models, schema design, data flow
7. **API Design Director** - API contracts, REST principles, versioning
8. **DevOps Director** - CI/CD, deployment, infrastructure as code
9. **Frontend Director** - UI/UX, component design, browser compatibility
10. **Backend Director** - Server logic, business rules, service architecture
11. **Database Director** - Query optimization, indexing, migrations
12. **Infrastructure Director** - Scaling, reliability, cloud resources
13. **Documentation Director** - Code comments, API docs, user guides
14. **Standards Compliance Director** - Coding standards, conventions, style guides
15. **Accessibility Director** - WCAG compliance, screen readers, keyboard navigation
16. **Scalability Director** - Growth handling, load capacity, horizontal scaling
17. **Maintainability Director** - Code clarity, refactoring needs, technical debt
18. **Error Handling Director** - Exception handling, recovery, user feedback
19. **Monitoring Director** - Logging, metrics, alerting, observability
20. **Deployment Director** - Release process, rollback strategy, blue-green deployment

## Execution Flow

### Phase 1: Planning Review (Sequential)

```
brainstorming skill runs
    ↓
User approves initial design
    ↓
TA reviews technical approach
    ↓
Owner reviews requirements alignment
    ↓
Both approve? → Proceed to writing-plans
Both reject? → Revise design and retry
```

### Phase 2: Verification Review (Parallel)

```
verification-before-completion skill runs
    ↓
Select relevant Directors (smart selection)
    ↓
Spawn all Directors as parallel Task agents
    ↓
Each Director analyzes independently using their template
    ↓
Collect all Director reports
    ↓
Present consolidated findings
    ↓
Critical issues resolved? → Mark complete
Issues exist? → Fix and re-verify
```

## Integration Points

### With Existing Superpowers Skills

**brainstorming skill:**
- After user approves initial design presentation
- Before invoking writing-plans
- TA + Owner reviews execute sequentially
- Cannot proceed until both approve

**verification-before-completion skill:**
- Before claiming work is complete
- Relevant Directors spawn as parallel Task agents
- Uses dispatching-parallel-agents pattern
- Cannot mark complete until critical issues resolved

**dispatching-parallel-agents skill:**
- Used to spawn multiple Director agents simultaneously
- Each Director gets their review template as context
- All Directors analyze in parallel
- Results collected and consolidated

### With CLAUDE.md

New rules added to enforce review framework:
- Mandatory TA + Owner review during planning
- Mandatory Directors review before completion
- Documentation requirements for all reviews
- .gitignore enforcement for plan/* directory

## Directory Structure

```
~/.claude/
├── CLAUDE.md (extended with review framework rules)
├── .gitignore (plan/* excluded from commits)
└── plan/
    ├── README.md (framework overview & usage guide)
    ├── ta/
    │   └── technical-analysis-template.md
    ├── owner/
    │   └── requirements-review-template.md
    ├── directors/
    │   ├── architecture.md
    │   ├── security.md
    │   ├── performance.md
    │   ├── testing.md
    │   ├── code-quality.md
    │   ├── data-design.md
    │   ├── api-design.md
    │   ├── devops.md
    │   ├── frontend.md
    │   ├── backend.md
    │   ├── database.md
    │   ├── infrastructure.md
    │   ├── documentation.md
    │   ├── standards-compliance.md
    │   ├── accessibility.md
    │   ├── scalability.md
    │   ├── maintainability.md
    │   ├── error-handling.md
    │   ├── monitoring.md
    │   └── deployment.md
    └── reviews/
        └── <date>-<topic>-<phase>.md (review outputs)
```

## Template Structure

Each role template (TA, Owner, Directors) contains:

1. **Role Description** - Scope and purpose
2. **Review Checklist** - Specific questions to answer
3. **Success Criteria** - What "passing" looks like
4. **Failure Criteria** - What issues block approval
5. **Examples** - Sample issues to catch
6. **Applicability** - When this review is needed

## CLAUDE.md Rules Extension

```markdown
# Multi-Role Review Framework

## MUST - Planning Phase Reviews
Before finalizing any design during brainstorming:
- MUST run TA (Technical Analysis) review of technical approach
- MUST run Owner review of requirements alignment
- CANNOT proceed to writing-plans until both approve
- Document TA/Owner findings in plan/reviews/<date>-<topic>-planning.md

## MUST - Verification Phase Reviews
Before claiming any work is complete:
- MUST spawn Directors as parallel Task agents for verification
- Select relevant Directors based on work type (frontend → Frontend Director, etc.)
- Each Director reviews independently using their plan/directors/<role>.md template
- CANNOT mark work complete until critical issues are resolved
- Document Director findings in plan/reviews/<date>-<topic>-verification.md

## Review Documentation
- All review documents go in plan/* directory
- NEVER commit plan/* (must be in .gitignore)
- Keep review docs for reference but don't track in git

## Director Selection
Choose Directors relevant to the work:
- Always include: Architecture, Security, Code Quality, Testing
- Add domain-specific: Frontend/Backend/Database/Infrastructure as needed
- Add process-specific: Documentation, Standards, Accessibility as needed
```

## Smart Director Selection

Not all Directors review every task. Selection based on work type:

**Frontend Work:**
- Always: Architecture, Security, Code Quality, Testing
- Domain: Frontend, Accessibility, Performance
- Optional: Documentation, Standards Compliance

**Backend Work:**
- Always: Architecture, Security, Code Quality, Testing
- Domain: Backend, API Design, Error Handling
- Optional: Performance, Monitoring, Documentation

**Database Work:**
- Always: Architecture, Security, Code Quality, Testing
- Domain: Database, Data Design, Performance
- Optional: Scalability, Backend

**Infrastructure Work:**
- Always: Architecture, Security
- Domain: Infrastructure, DevOps, Deployment, Scalability
- Optional: Monitoring, Performance

**Full-Stack Work:**
- Always: Architecture, Security, Code Quality, Testing
- Domain: Frontend, Backend, API Design, Database
- Optional: All others as relevant

## Benefits

1. **Automatic Enforcement** - CLAUDE.md rules ensure reviews always happen
2. **Parallel Efficiency** - Directors review simultaneously, not sequentially
3. **Specialized Expertise** - Each Director focuses on their domain
4. **Quality Gates** - Cannot proceed past planning or mark complete until approved
5. **Documentation** - All reviews documented but never committed
6. **Flexible Scope** - Smart Director selection based on work type
7. **Integration** - Works seamlessly with existing superpowers skills

## Implementation Requirements

1. Create `/plan` directory structure
2. Write all role templates (TA, Owner, 20 Directors)
3. Write framework README
4. Update CLAUDE.md with new rules
5. Verify .gitignore excludes `plan/*`
6. Create sample review documents

---

**Next Steps:** Invoke writing-plans skill to create detailed implementation plan.
