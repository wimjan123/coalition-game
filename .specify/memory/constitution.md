<!--
Sync Impact Report
Version: 2.1.1 → 2.2.0
Modified Principles:
- [PRINCIPLE_1_NAME] placeholder → I. Engineering Craft Is Non-Negotiable
- [PRINCIPLE_2_NAME] placeholder → II. Test-First Delivery Governs Change
- [PRINCIPLE_3_NAME] placeholder → III. Cohesive Desktop Experience Defines UX
- [PRINCIPLE_4_NAME] placeholder → IV. Performance Budgets Protect Immersion
Added Sections:
- Operational Standards
- Development Workflow & Quality Gates
Removed Sections:
- Placeholder fifth principle slot
Templates requiring updates:
- ✅ .specify/templates/plan-template.md (Constitution checks + version reference)
- ✅ .specify/templates/tasks-template.md (Task phases mirror principles)
- ✅ .specify/templates/spec-template.md (Reviewed; no edits required)
Follow-up TODOs:
- None
-->

# COALITION Constitution

## Core Principles

### I. Engineering Craft Is Non-Negotiable
- Every code path MUST remain readable, maintainable, and self-documenting through clear naming, purposeful structure, and concise complexity.
- All code MUST pass automated formatting, linting, and static analysis before review; deviations REQUIRE a documented waiver approved by the technical lead.
- Public-facing APIs, gameplay systems, and data schemas MUST ship with authoritative documentation and inline explanations of non-obvious decisions.
- No TODOs, dead code, or speculative abstractions are allowed in mainline branches; unfinished concepts stay on feature branches until complete.

### II. Test-First Delivery Governs Change
- Test-driven development is mandatory: author tests, confirm they fail, implement minimal code, then refactor with a green suite.
- Unit, integration, and contract tests MUST exist for all gameplay logic, data interactions, and cross-module flows; regression gaps block merges.
- Coverage MUST remain at or above 95% for critical systems (game loop, AI, save/load); deviations demand risk sign-off plus remediation tasks.
- Continuous integration MUST gate merges on deterministic, repeatable test execution; flaky tests pause shipping until resolved.

### III. Cohesive Desktop Experience Defines UX
- The fictional OS shell, political apps, and narrative overlays MUST share interaction patterns, typography, iconography, and feedback timing.
- Player journeys MUST surface contextual guidance, affordances, and error messaging that preserve immersion without breaking the fourth wall.
- Keyboard navigation, accessibility affordances, and localization hooks MUST be implemented and verified for all interactive surfaces.
- UX adjustments that break established patterns REQUIRE dual approval from UX and narrative leads plus regression tests covering the change.

### IV. Performance Budgets Protect Immersion
- Gameplay MUST sustain 60fps on target hardware with scene transitions under 1s, AI/social updates under 2s, and peak memory under 2GB.
- Performance instrumentation, budgets, and automated checks MUST exist alongside features that can degrade frame time or responsiveness.
- Optimization work follows a measure-diagnose-improve loop with captured profiles; guesses without data are prohibited.
- Any intentional budget trade-off MUST include mitigation tasks and approval from the technical lead before merge.

## Operational Standards
- Development artifacts (spec, plan, tasks) MUST precede implementation work and reflect current intentions; drift triggers immediate updates.
- Code reviews REQUIRE explicit confirmation of principle compliance, test coverage, UX impact, and performance considerations.
- Documentation (developer guides, mechanics references, changelogs) MUST update alongside feature completion to maintain a single source of truth.
- Release candidates MUST bundle observability dashboards or scripts covering performance and UX health to support smoke testing.

## Development Workflow & Quality Gates
1. Capture product intent via `/spec`, translate into actionable design with `/plan`, and enumerate executable tasks via `/tasks` before coding.
2. Establish failing unit, integration, contract, and UX regression tests prior to implementing production logic; document test scope in the plan.
3. Enforce pre-commit gates: lint, format, static analysis, test suites, and performance budgets executed locally or via CI before submission.
4. Require self-review, peer review, and domain lead approvals (UX, narrative, performance) before merge; unresolved findings block release.
5. Maintain operational telemetry (profiling traces, UX heuristics dashboards) to validate principle adherence post-deployment.

## Governance
- This constitution supersedes conflicting guidance; feature work that violates any clause MUST halt until alignment or formal exemption.
- Amendments REQUIRE a written proposal, impact analysis, updated templates, and consensus from technical, UX, and narrative leads.
- Versioning follows semantic rules: MAJOR for principle removal/redefinition, MINOR for new principles or sections, PATCH for clarifications.
- Compliance is reviewed at plan approval, code review, and release readiness; deviations demand logged remediation tasks and ownership.

**Version**: 2.2.0 | **Ratified**: 2025-09-21 | **Last Amended**: 2025-09-21
