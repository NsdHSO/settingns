# Technical Analysis (TA) Review Template

## Context & Purpose

**When Used**: During brainstorming skill's planning phase, after initial design presented, before Owner review and before proceeding to writing-plans.

**Focus**: Technical soundness, feasibility, and architectural decisions. NOT requirements fit (that's Owner's job).

**Your Role as TA**: Evaluate whether the proposed technical approach is sound, scalable, maintainable, and uses appropriate technologies and patterns. You're the technical gatekeeper ensuring we don't build something that works today but breaks tomorrow.

---

## 1. Technical Feasibility Analysis

### Core Feasibility Questions

- [ ] **Can this actually be built with current technology?**
  - Are there proven libraries/frameworks for this?
  - Any experimental dependencies that could cause issues?
  - Are we relying on unstable APIs or beta features?

- [ ] **Do we have the necessary technical capabilities?**
  - Required expertise level (beginner/intermediate/expert)?
  - Any specialized knowledge needed?
  - Learning curve acceptable for timeline?

- [ ] **Are there known technical blockers?**
  - Platform limitations (OS, browser, hardware)?
  - API rate limits or quotas?
  - Integration constraints with existing systems?

- [ ] **What are the technical risks?**
  - Single points of failure?
  - Dependencies on third-party services?
  - Data migration challenges?

- [ ] **Performance feasibility**
  - Expected data volumes manageable?
  - Response time requirements achievable?
  - Scalability concerns addressed?

### Example Issues to Catch:
- Proposing real-time video processing on client-side for low-end devices (likely infeasible)
- Building mobile app requiring iOS 18 features when 60% of users on iOS 16 (version mismatch)
- Planning to process 10GB files in browser memory (resource constraint violation)

### Follow-up Analysis:
- **If feasible**: What technical constraints or prerequisites exist?
- **If questionable**: What proof-of-concept or validation is needed before proceeding?
- **If infeasible**: What alternative technical approaches could work?

---

## 2. Architecture Decision Review

### Architecture Assessment

- [ ] **Is the overall architecture appropriate for the problem?**
  - Monolith vs microservices vs serverless justified?
  - Client-server separation makes sense?
  - Data flow architecture clear and logical?

- [ ] **Are components properly separated?**
  - Clear boundaries between layers?
  - Appropriate abstraction levels?
  - Minimal coupling, high cohesion?

- [ ] **Does the architecture support stated requirements?**
  - Scalability requirements matched to architecture?
  - Security requirements addressed architecturally?
  - Maintainability considerations included?

- [ ] **Are cross-cutting concerns handled?**
  - Logging and monitoring approach?
  - Error handling strategy?
  - Security model (authentication, authorization)?
  - Configuration management?

- [ ] **Is the architecture over-engineered or under-engineered?**
  - Complexity justified by actual needs?
  - Future extensibility balanced with current simplicity?
  - YAGNI principle respected?

- [ ] **Are there architectural anti-patterns?**
  - God objects or classes doing too much?
  - Circular dependencies?
  - Tight coupling to specific implementations?

### Example Issues to Catch:
- Choosing microservices architecture for 100-user internal tool (overengineering - monolith sufficient)
- No caching layer for read-heavy application querying database 1000x/sec (missing critical component)
- Putting business logic in UI components instead of separate service layer (poor separation of concerns)

### Follow-up Analysis:
- **Architectural trade-offs**: What are we optimizing for? What are we sacrificing?
- **Evolution path**: How will this architecture handle future growth?
- **Technical debt**: Are we accepting any architectural debt? Is it documented and justified?

---

## 3. Technology Choice Evaluation

### Technology Stack Assessment

- [ ] **Are technology choices appropriate for the use case?**
  - Right tool for the job, not just familiar tool?
  - Technology maturity suitable for project risk tolerance?
  - Community support and ecosystem health?

- [ ] **Database/storage technology suitable?**
  - Relational vs NoSQL justified by data model?
  - Read/write patterns matched to database strengths?
  - Data consistency requirements met?

- [ ] **Framework/library selections justified?**
  - Why this framework over alternatives?
  - License compatibility checked?
  - Maintenance status (actively maintained vs abandoned)?

- [ ] **Integration and compatibility**
  - All technologies work together smoothly?
  - Version compatibility issues addressed?
  - Platform compatibility (OS, browser, mobile)?

- [ ] **Long-term viability**
  - Technology likely supported 3-5 years out?
  - Migration path exists if technology becomes obsolete?
  - Vendor lock-in risks acceptable?

- [ ] **Team familiarity vs learning curve**
  - Using familiar tech where appropriate?
  - Learning new tech justified by clear benefits?
  - Documentation and learning resources available?

### Example Issues to Catch:
- Using MongoDB for heavily relational data with complex joins (wrong database type)
- Choosing obscure UI framework with 50 GitHub stars vs mature alternative (sustainability risk)
- Selecting GPL-licensed library for commercial closed-source product (license conflict)

### Follow-up Analysis:
- **Technology trade-offs**: What do we gain? What do we lose?
- **Alternative options**: What else was considered? Why was this chosen?
- **Exit strategy**: If this technology fails us, what's plan B?

---

## 4. Design Pattern Assessment

### Pattern Usage Review

- [ ] **Are appropriate design patterns used?**
  - Patterns solve actual problems, not added for sake of patterns?
  - Patterns correctly implemented (not misapplied)?
  - Common problems addressed with proven patterns?

- [ ] **Creational patterns appropriate?**
  - Factory, Singleton, Builder used where needed?
  - Object creation complexity managed?
  - Dependency injection where appropriate?

- [ ] **Structural patterns appropriate?**
  - Adapter, Facade, Proxy used where needed?
  - Component composition makes sense?
  - Interfaces and abstractions at right levels?

- [ ] **Behavioral patterns appropriate?**
  - Observer, Strategy, Command used where needed?
  - Object interactions and responsibilities clear?
  - State management patterns suitable?

- [ ] **Concurrency patterns (if applicable)?**
  - Thread safety addressed?
  - Race conditions prevented?
  - Deadlock risks mitigated?

- [ ] **Anti-patterns avoided?**
  - No Spaghetti Code or Big Ball of Mud?
  - No premature optimization?
  - No Golden Hammer (forcing same pattern everywhere)?

### Example Issues to Catch:
- Using Singleton for user session data in multi-tenant app (shared state bug waiting to happen)
- Direct database calls scattered throughout UI code instead of Repository pattern (maintenance nightmare)
- Building custom event system when language/framework provides one (reinventing the wheel)

### Follow-up Analysis:
- **Pattern justification**: Why is this pattern the right choice here?
- **Simpler alternatives**: Could we achieve this without the pattern complexity?
- **Pattern interactions**: Do multiple patterns work together cleanly?

---

## 5. Code Organization & Structure

### Structure Assessment

- [ ] **Directory structure logical and scalable?**
  - Clear organization by feature/layer/domain?
  - Easy to find where code lives?
  - Won't become unwieldy as project grows?

- [ ] **Module/package boundaries make sense?**
  - Clear responsibilities for each module?
  - Minimal cross-module dependencies?
  - Public interfaces well-defined?

- [ ] **Naming conventions clear and consistent?**
  - Files, classes, functions named descriptively?
  - Consistent naming patterns throughout?
  - Industry standard conventions followed?

- [ ] **Code reusability planned?**
  - Common functionality identified for shared modules?
  - DRY principle applied appropriately?
  - Not over-abstracting for hypothetical future needs?

- [ ] **Testing strategy clear?**
  - Unit testable components?
  - Integration points identified?
  - Test organization matches code organization?

### Example Issues to Catch:
- All code in single src/ directory with 200 files (no organization)
- Circular dependencies between core modules (design flaw)
- Inconsistent naming: some camelCase, some snake_case, some PascalCase in same codebase (confusion)

---

## 6. Performance & Scalability Considerations

### Performance Review

- [ ] **Expected performance characteristics defined?**
  - Response time targets set?
  - Throughput requirements specified?
  - Resource usage bounds established?

- [ ] **Known performance bottlenecks identified?**
  - Database query optimization needed?
  - Network latency concerns?
  - Computational complexity issues?

- [ ] **Scalability approach clear?**
  - Horizontal vs vertical scaling strategy?
  - Stateless design where needed?
  - Caching strategy defined?

- [ ] **Resource usage reasonable?**
  - Memory footprint acceptable?
  - CPU usage expectations realistic?
  - Storage requirements manageable?

- [ ] **Performance monitoring planned?**
  - Key metrics identified?
  - Alerting thresholds defined?
  - Performance regression detection?

### Example Issues to Catch:
- Loading entire 1M record dataset into memory to filter 10 records (inefficient querying)
- No pagination on list endpoints (performance time bomb)
- Synchronous processing of long-running tasks blocking UI (poor UX and resource waste)

---

## 7. Security & Data Protection

### Security Review

- [ ] **Authentication/authorization approach sound?**
  - Identity management strategy clear?
  - Access control model appropriate?
  - Session management secure?

- [ ] **Data protection adequate?**
  - Sensitive data encrypted at rest/in transit?
  - PII handling compliant with regulations?
  - Secrets management strategy defined?

- [ ] **Common vulnerabilities prevented?**
  - SQL injection prevention (parameterized queries)?
  - XSS prevention (input sanitization)?
  - CSRF protection where needed?

- [ ] **Dependency security considered?**
  - Third-party dependencies vetted?
  - Security update strategy defined?
  - Vulnerability scanning planned?

### Example Issues to Catch:
- Storing passwords in plain text (critical security flaw)
- No rate limiting on API endpoints (DDoS vulnerability)
- Client-side only validation for critical operations (easily bypassed)

---

## 8. Maintainability & DevOps

### Maintainability Review

- [ ] **Code will be maintainable long-term?**
  - Documentation strategy clear?
  - Code complexity manageable?
  - Technical debt minimized or documented?

- [ ] **Deployment strategy defined?**
  - CI/CD pipeline planned?
  - Environment management (dev/staging/prod)?
  - Rollback strategy exists?

- [ ] **Monitoring and observability?**
  - Logging strategy comprehensive?
  - Metrics collection planned?
  - Debugging capabilities built in?

- [ ] **Disaster recovery considered?**
  - Backup strategy defined?
  - Data recovery procedures?
  - Incident response plan outlined?

---

## Approval Decision Framework

### Critical Criteria (Must Pass All)

- [ ] **Technically feasible** - Can actually be built with available technology and resources
- [ ] **No architectural red flags** - No fundamental design flaws that will cause future pain
- [ ] **No security deal-breakers** - No obvious critical security vulnerabilities
- [ ] **Scalability path exists** - Won't hit hard limits immediately as usage grows
- [ ] **Technology choices defensible** - Stack selections have clear rationale and viability

### Important Criteria (Should Pass Most)

- [ ] **Appropriate complexity level** - Neither over-engineered nor under-engineered
- [ ] **Design patterns used well** - Patterns solve real problems, not added for sake of it
- [ ] **Performance approach sound** - Won't have obvious performance disasters
- [ ] **Maintainable structure** - Future developers won't curse us
- [ ] **Testing feasible** - Can actually test this effectively

### Nice-to-Have Criteria (Bonus Points)

- [ ] **Elegant solution** - Simple, clean approach to the problem
- [ ] **Future-friendly** - Easy to extend without major refactoring
- [ ] **Best practices followed** - Industry standard approaches used
- [ ] **Well-documented reasoning** - Decisions explained with clear rationale

---

## Final TA Decision

**[ ] APPROVED** - Technical approach is sound. Proceed to Owner review.
- Summary: [Brief summary of why approved]
- Conditions: [Any caveats or conditions for approval]

**[ ] APPROVED WITH CHANGES** - Good foundation but needs modifications.
- Required changes: [List specific technical changes needed]
- Timeline: [When changes should be implemented - before/during development]

**[ ] NEEDS REVISION** - Significant technical concerns must be addressed.
- Critical issues: [List blocking technical problems]
- Recommended approach: [Suggest alternative technical direction]
- Re-review required: [Yes/No - does TA need to review again after changes?]

**[ ] REJECTED** - Technical approach fundamentally flawed.
- Fatal flaws: [List why this can't work technically]
- Alternative direction: [Suggest completely different technical approach]
- Next steps: [Go back to design phase, spike/POC needed, etc.]

---

## Notes & Observations

[Space for additional technical observations, concerns, or recommendations that don't fit above categories]

---

## TA Reviewer Information

- **Reviewer**: [Your name/identifier]
- **Review Date**: [Date]
- **Time Spent**: [Approximate review duration]
- **Follow-up Contact**: [How to reach you for questions]

---

**Remember**: Your job as TA is to ensure technical excellence and prevent future technical debt. Be thorough but pragmatic. Perfect is the enemy of good, but "good enough" shouldn't mean "technically broken."
