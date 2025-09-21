# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: tech stack, libraries, structure
2. Load optional design documents:
   → data-model.md: Extract entities → model tasks
   → contracts/: Each file → contract test task
   → research.md: Extract decisions → setup tasks
3. Generate tasks by category:
   → Setup: tooling, linting, repository scaffolding updates
   → Tests First: unit, integration, contract, and UX regression suites
   → Core Implementation: gameplay logic, data structures, AI behaviors
   → Experience Integration: UI flows, accessibility, narrative alignment
   → Performance & Polish: profiling, optimization, documentation, release prep
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Tests before implementation (TDD)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   → All contracts/data exchanges have tests?
   → All entities and gameplay systems have implementation tasks?
   → All UX flows, accessibility checks, and performance guardrails accounted for?
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- Core gameplay scripts in `src/scripts/`
- Systems/data models in `src/models/` and `src/data/`
- UI scenes and styles in `src/ui/` (or `scenes/` where applicable)
- Tests organized under `tests/unit/`, `tests/integration/`, `tests/contract/`, `tests/ui/`, `tests/performance/`
- Documentation updates in `docs/implementation_plan.md`, `docs/mechanics/`, `docs/ux/`, and `docs/performance/`

## Phase 3.1: Setup & Tooling
- [ ] T001 Align repository structure with plan (e.g., scenes/, scripts/, ui/) and register required assets.
- [ ] T002 Configure linting, formatting, and static analysis (gdlint, gdformat, ESLint) per Principle I.
- [ ] T003 [P] Update docs/implementation_plan.md and docs/mechanics/[feature].md with scope, acceptance criteria, and rationale.

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [ ] T004 [P] Unit tests for gameplay logic in tests/unit/test_[feature]_logic.gd
- [ ] T005 [P] Integration tests across systems in tests/integration/test_[feature]_flows.gd
- [ ] T006 [P] Contract tests covering data/AI boundaries in tests/contract/test_[feature]_contracts.gd
- [ ] T007 [P] UX regression script (input, accessibility, localization) in tests/ui/test_[feature]_ux.gd
- [ ] T008 [P] Performance/profiling guardrails in tests/performance/test_[feature]_budget.gd (assert fps, load, memory targets)

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [ ] T009 [P] Implement gameplay controller in src/scripts/[feature]_controller.gd
- [ ] T010 [P] Model feature state/data in src/models/[feature]_state.gd
- [ ] T011 [P] Build UI scene in src/ui/[feature]_screen.tscn and wire signals
- [ ] T012 Integrate feature with existing systems (story beats, save/load, telemetry)
- [ ] T013 Implement validation, error handling, and narrative-safe fallbacks

## Phase 3.4: Experience Integration
- [ ] T014 Align UI with design system (typography, iconography, spacing) in src/ui/styles/
- [ ] T015 Verify accessibility and localization hooks in src/ui/[feature]_screen.tscn
- [ ] T016 Sync narrative/AI content in src/data/[feature]_dialogue.json and regenerate fixtures
- [ ] T017 Update UX regression suite and screenshots in docs/ux/[feature]/

## Phase 3.5: Performance & Polish
- [ ] T018 [P] Profile feature with godot --check-only or performance tooling; capture traces in docs/performance/[feature].md
- [ ] T019 [P] Optimize hotspots to meet budgets (60fps, <1s transitions, <2s AI, <2GB memory)
- [ ] T020 [P] Verify telemetry dashboards or scripts reporting UX/performance health
- [ ] T021 Update documentation (docs/mechanics/, changelog) and mark constitutional compliance in PR notes
- [ ] T022 Run manual playtest script and capture UX/performance validation evidence

## Dependencies
- Tests (T004-T008) MUST fail before implementation tasks (T009-T013) begin.
- Core implementation (T009-T013) completes before experience integration (T014-T017).
- Performance & polish tasks (T018-T022) require prior phases complete and green test suites.
- Documentation and telemetry updates (T017, T020-T021) depend on finalized behavior from earlier tasks.

## Parallel Example
```
# Launch T004-T008 together:
Task: "Unit tests for gameplay logic in tests/unit/test_[feature]_logic.gd"
Task: "Integration tests across systems in tests/integration/test_[feature]_flows.gd"
Task: "Contract tests covering data/AI boundaries in tests/contract/test_[feature]_contracts.gd"
Task: "UX regression script in tests/ui/test_[feature]_ux.gd"
Task: "Performance guardrail in tests/performance/test_[feature]_budget.gd"
```

## Notes
- [P] tasks = different files, no dependencies
- Verify tests fail before implementing
- Commit after each task
- Avoid: vague tasks, same file conflicts
- Capture evidence for performance budgets and UX validation alongside task completion notes

## Task Generation Rules
*Applied during main() execution*

1. **From Specifications**:
   - Identify tooling, documentation, and environment updates → Phase 3.1 tasks
   - Extract acceptance criteria → corresponding test cases before implementation

2. **From Data & Systems**:
   - Each gameplay system or data entity → implementation task mapping to src/scripts/, src/models/, src/data/
   - Cross-system interactions → integration tasks tying into save/load, AI, telemetry

3. **From UX & Narrative Requirements**:
   - Interaction flows → UX regression tasks
   - Accessibility/localization notes → dedicated validation tasks

4. **From Performance Budgets**:
   - Frame time, load time, memory targets → performance guard tests and optimization tasks
   - Observability needs → telemetry instrumentation tasks

5. **Ordering**:
   - Setup & Tooling → Tests First → Core Implementation → Experience Integration → Performance & Polish
   - Dependencies block parallel execution

## Validation Checklist
*GATE: Checked by main() before returning*

- [ ] All contracts have corresponding tests
- [ ] All entities have model tasks
- [ ] All tests come before implementation
- [ ] Parallel tasks truly independent
- [ ] Each task specifies exact file path
- [ ] No task modifies same file as another [P] task
- [ ] UX and accessibility validation tasks included when UI changes exist
- [ ] Performance instrumentation and optimization tasks cover constitutional budgets
- [ ] Evidence capture (docs/screenshots/profiles) identified for each validation task
