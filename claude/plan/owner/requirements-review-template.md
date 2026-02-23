# Owner Requirements Review Template

## Context & Purpose

**When Used**: During brainstorming skill's planning phase, after TA (Technical Analysis) review passes, before proceeding to writing-plans.

**Focus**: Requirements alignment, user needs, scope clarity, and success criteria. NOT technical implementation (that's TA's job).

**Your Role as Owner**: Evaluate whether we're building the right thing for the right reasons. You're the product gatekeeper ensuring we solve actual user problems with clear, measurable outcomes. TA ensures we can build it correctly; you ensure it's worth building at all.

---

## 1. Requirements Alignment Analysis

### Core Alignment Questions

- [ ] **Does this solve an actual user problem?**
  - Is the problem clearly defined and validated?
  - Do we have evidence this problem exists (not just assumptions)?
  - How many users/use cases does this affect?

- [ ] **Is the proposed solution appropriate for the problem?**
  - Does the solution directly address the root cause?
  - Are we solving symptoms vs the actual problem?
  - Is this the simplest solution that could work?

- [ ] **Are the stated requirements complete?**
  - All user needs captured?
  - Edge cases and error scenarios included?
  - Non-functional requirements specified (performance, usability, accessibility)?

- [ ] **Are requirements prioritized appropriately?**
  - Must-haves vs nice-to-haves clearly separated?
  - Priority based on user value, not technical preference?
  - Dependencies between requirements identified?

- [ ] **Do requirements align with user goals?**
  - What user outcome are we enabling?
  - How does this fit into user workflows?
  - What value does this deliver from user perspective?

- [ ] **Are there conflicting requirements?**
  - Requirements that contradict each other?
  - Trade-offs between different user needs clearly identified?
  - Conflicts resolved with clear rationale?

### Example Issues to Catch:
- Building complex analytics dashboard when users actually just need simple CSV export (solution doesn't match need)
- Requirements say "make search faster" but don't specify target response time or current baseline (vague, unmeasurable)
- Adding 15 new features to "improve engagement" with no evidence users want any of them (assumption-based, not validated)

### Follow-up Analysis:
- **If aligned**: What evidence supports that this solves the right problem?
- **If questionable**: What user research or validation is needed before proceeding?
- **If misaligned**: What alternative approach would better serve user needs?

---

## 2. Scope Clarity Review

### Scope Definition Assessment

- [ ] **Is the scope clearly bounded?**
  - What is explicitly IN scope?
  - What is explicitly OUT of scope?
  - Are boundaries unambiguous and well-defined?

- [ ] **Is the scope appropriate for the problem size?**
  - Not too small (solves toy problem, misses real need)?
  - Not too large (trying to boil the ocean)?
  - Right-sized for delivering user value?

- [ ] **Are success boundaries clear?**
  - When is this "done"?
  - What does minimum viable look like?
  - What constitutes "good enough" vs "perfect"?

- [ ] **Are dependencies and prerequisites identified?**
  - What must exist before this can be built?
  - What other systems/features does this depend on?
  - Are those dependencies available/stable?

- [ ] **Is the scope creep risk managed?**
  - Scope defined tightly enough to prevent drift?
  - Process for handling scope change requests?
  - Clear criteria for what gets deferred to "later"?

- [ ] **Are user personas and use cases specific?**
  - Who exactly are we building for?
  - What specific scenarios are we supporting?
  - Are we trying to serve too many different user types?

- [ ] **Is the timeline realistic for this scope?**
  - Scope matches available time/resources?
  - Can deliver meaningful value in planned timeframe?
  - Phased delivery approach if scope is large?

### Example Issues to Catch:
- Scope says "improve user authentication" but includes OAuth, SSO, 2FA, biometrics, magic links (scope too broad and vague)
- Building "notification system" without specifying channels (email? push? SMS? all?), triggers, or user preferences (undefined boundaries)
- Planning 2-week project that requires integrating 5 third-party APIs we've never used (scope/timeline mismatch)

### Follow-up Analysis:
- **Scope trade-offs**: What are we consciously choosing NOT to include? Why?
- **MVP definition**: What's the absolute minimum that delivers value?
- **Future extensibility**: Are we leaving room to expand scope later without rebuilding?

---

## 3. Success Criteria Validation

### Success Measurement Assessment

- [ ] **Are success metrics clearly defined?**
  - Specific, measurable outcomes identified?
  - Baseline current state established?
  - Target state numerically specified?

- [ ] **Are metrics meaningful to users?**
  - Do metrics reflect actual user value delivered?
  - Avoiding vanity metrics (downloads vs active usage)?
  - Outcomes vs outputs (impact vs activity)?

- [ ] **Are success criteria achievable?**
  - Targets realistic given constraints?
  - Historical data supports achievability?
  - Not setting up for guaranteed failure?

- [ ] **Is measurement feasible?**
  - Can we actually track these metrics?
  - Instrumentation/analytics in place or planned?
  - Data collection doesn't violate privacy/compliance?

- [ ] **Are failure criteria defined?**
  - What would indicate this isn't working?
  - When would we pivot or kill this feature?
  - Early warning signals identified?

- [ ] **Is success timeframe specified?**
  - When do we evaluate success?
  - Short-term vs long-term success differentiated?
  - Milestones for progressive validation?

- [ ] **Are qualitative and quantitative measures balanced?**
  - Numbers AND user feedback considered?
  - User satisfaction metrics included?
  - Not just optimizing metrics at expense of experience?

### Example Issues to Catch:
- Success = "users like it" with no definition of "like" or measurement plan (vague, unmeasurable)
- Target: "increase engagement by 500%" when current engagement is 2% (unrealistic)
- Success measured by "features shipped" not "problems solved" (output not outcome)

### Follow-up Analysis:
- **Leading indicators**: What early signals suggest we're on track?
- **Lagging indicators**: What final measures confirm success?
- **Monitoring plan**: How often will we check metrics? Who reviews them?

---

## 4. User Needs Assessment

### User-Centered Evaluation

- [ ] **Do we understand our users?**
  - User research conducted or available?
  - User personas based on actual data?
  - User pain points clearly articulated?

- [ ] **Does this serve actual user needs vs wants?**
  - Solving real problems vs adding "cool features"?
  - Users asking for this or we're assuming they need it?
  - Evidence of user demand (surveys, feedback, usage data)?

- [ ] **Is the user experience considered?**
  - User workflow impact understood?
  - Learning curve acceptable for user base?
  - Accessibility requirements addressed?

- [ ] **Are all user types accounted for?**
  - Primary users clearly identified?
  - Secondary/indirect users considered?
  - Edge case users not forgotten?

- [ ] **Does this create new user problems?**
  - Unintended negative consequences considered?
  - New complexity balanced with new value?
  - User migration/transition path smooth?

- [ ] **Is user feedback incorporated?**
  - Previous user feedback addressed?
  - User testing planned before full rollout?
  - Feedback loop established for iteration?

- [ ] **Does this align with user mental models?**
  - Behavior matches user expectations?
  - Terminology familiar to users?
  - Workflow fits how users actually work?

### Example Issues to Catch:
- Building keyboard shortcuts for power users when 95% of user base is casual mobile users (serving wrong audience)
- Adding required 10-field form because "we need the data" when users abandon at 3 fields (business need vs user tolerance)
- Redesigning UI that users have muscle memory for with no migration path (ignoring user adaptation cost)

### Follow-up Analysis:
- **User validation plan**: How will we validate with real users before full launch?
- **User segments**: Are different user types served appropriately?
- **User education**: What onboarding/help is needed for users to get value?

---

## 5. Value Proposition Review

### Value Delivery Assessment

- [ ] **Is the value proposition clear?**
  - What specific value does this deliver?
  - Why would users care about this?
  - What problem goes away or what gets easier?

- [ ] **Is the value significant enough to justify effort?**
  - Value delivered proportional to cost/time invested?
  - ROI positive from user perspective?
  - "Nice to have" or "must have" for users?

- [ ] **Is value delivered early and often?**
  - Can users get value from partial implementation?
  - Phased delivery provides incremental value?
  - Not a "big bang" that delivers nothing until 100% complete?

- [ ] **Is the value sustainable?**
  - One-time benefit or ongoing value?
  - Value grows with usage/time?
  - Creates positive user habits/behaviors?

- [ ] **Does value outweigh user cost?**
  - Learning curve worth the benefit?
  - Disruption to current workflow justified?
  - Migration effort balanced with improvement?

- [ ] **Is value differentiated?**
  - How is this different from existing solutions?
  - Unique value vs commodity feature?
  - Competitive advantage or table stakes?

### Example Issues to Catch:
- 6-month project to save users 30 seconds per week (value too small for effort)
- Feature delivers value only after 100% of users adopt it (chicken-egg problem)
- Building exactly what competitors have, no differentiation (me-too feature, no unique value)

### Follow-up Analysis:
- **Value communication**: How will users discover and understand this value?
- **Value measurement**: How will we know users are actually getting value?
- **Value evolution**: How might value change as users adopt and adapt?

---

## 6. Risk & Constraint Analysis

### Risk Assessment from Product Perspective

- [ ] **Are user adoption risks identified?**
  - Will users actually use this?
  - Change management challenges?
  - Activation barriers too high?

- [ ] **Are business risks considered?**
  - Regulatory/compliance risks?
  - Brand/reputation risks?
  - Revenue/business model risks?

- [ ] **Are resource constraints realistic?**
  - Time constraints appropriate for scope?
  - Budget/cost constraints considered?
  - People/skill constraints acknowledged?

- [ ] **Are external dependencies risky?**
  - Third-party service reliability?
  - Partner/vendor stability?
  - Market/competitive timing risks?

- [ ] **Are there ethical concerns?**
  - Privacy implications acceptable?
  - Potential for misuse addressed?
  - Inclusive and equitable for all users?

- [ ] **Is there a rollback plan?**
  - If this fails, how do we recover?
  - Can we turn it off without breaking things?
  - Data/state migration reversible?

### Example Issues to Catch:
- Building feature dependent on startup API that could shut down any time (external dependency risk)
- Collecting user data without clear privacy policy/consent (ethical/legal risk)
- Launching major redesign to all users at once with no rollback (adoption/rollback risk)

---

## 7. Requirements Documentation Quality

### Documentation Assessment

- [ ] **Are requirements written clearly?**
  - Unambiguous language used?
  - Technical jargon avoided or explained?
  - Acceptance criteria specific and testable?

- [ ] **Are user stories well-formed?**
  - "As a [user], I want [action] so that [benefit]" format?
  - User perspective maintained?
  - Value/benefit always stated?

- [ ] **Are examples and scenarios provided?**
  - Concrete examples for each requirement?
  - Edge cases illustrated?
  - Success and failure scenarios shown?

- [ ] **Are assumptions documented?**
  - What are we assuming about users?
  - What are we assuming about environment/context?
  - Assumptions validated or flagged for validation?

- [ ] **Are open questions tracked?**
  - Unknowns explicitly called out?
  - Decisions needed identified?
  - Responsible parties assigned?

- [ ] **Is requirements traceability clear?**
  - Can trace requirement back to user need?
  - Can trace implementation forward to requirement?
  - Change history tracked?

### Example Issues to Catch:
- Requirement: "System should be fast" (vague, not measurable - needs specific performance target)
- User story: "As a developer, I want to use React" (technical preference, not user need)
- Requirements doc with no examples, all abstract descriptions (hard to validate understanding)

---

## Approval Decision Framework

### Critical Criteria (Must Pass All)

- [ ] **Solves real user problem** - Validated user need exists, not building in a vacuum
- [ ] **Clear scope boundaries** - Know exactly what we're building and what we're not
- [ ] **Measurable success criteria** - Can objectively determine if this worked
- [ ] **Value justifies effort** - User value delivered is worth the cost/time
- [ ] **Requirements are complete** - Have enough detail to actually build the right thing

### Important Criteria (Should Pass Most)

- [ ] **User needs well understood** - Know our users and what they actually need
- [ ] **Appropriate scope size** - Not too big (overwhelming) or too small (trivial)
- [ ] **Success criteria achievable** - Targets are realistic and measurable
- [ ] **Risk level acceptable** - Major risks identified and mitigated
- [ ] **Documentation quality good** - Requirements clear and unambiguous

### Nice-to-Have Criteria (Bonus Points)

- [ ] **Strong value proposition** - Compelling user value, not just incremental
- [ ] **Phased delivery possible** - Can deliver value incrementally, not big bang
- [ ] **User validation planned** - Built-in feedback loops and testing
- [ ] **Well-researched and evidence-based** - Decisions backed by data/research

---

## Final Owner Decision

**[ ] APPROVED** - Requirements are solid. Proceed to writing-plans.
- Summary: [Brief summary of why approved]
- Key value: [What user value this delivers]
- Success measures: [How we'll know it worked]

**[ ] APPROVED WITH CLARIFICATIONS** - Good foundation but needs refinement.
- Required clarifications: [List specific requirements questions to resolve]
- Timeline: [When clarifications should be ready - before development starts]
- Re-review needed: [Yes/No - does Owner need to check clarifications?]

**[ ] NEEDS REVISION** - Significant requirements gaps must be addressed.
- Critical gaps: [List missing requirements or unclear user needs]
- Recommended research: [User research, validation, or analysis needed]
- Re-review required: [Yes - Owner must review revised requirements]

**[ ] REJECTED** - Requirements don't justify building this.
- Fatal flaws: [List why this doesn't meet user needs or business goals]
- Alternative direction: [Suggest different approach or problem to solve]
- Next steps: [Go back to discovery, pivot to different solution, etc.]

---

## Notes & Observations

[Space for additional product observations, user insights, or recommendations that don't fit above categories]

---

## Owner Reviewer Information

- **Reviewer**: [Your name/identifier]
- **Review Date**: [Date]
- **Time Spent**: [Approximate review duration]
- **Follow-up Contact**: [How to reach you for questions]

---

**Remember**: Your job as Owner is to ensure we're building the right thing for the right users with clear success measures. TA ensures we build it correctly; you ensure it's worth building. Be the user advocate and the voice of product clarity. Don't approve vague requirements just because the technical approach is sound.
