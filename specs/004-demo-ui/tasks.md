# Tasks: Playable Desktop-Sim Demo UI

**Input**: plan.md, research.md, data-model.md, contracts/
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Setup & Tooling
- [x] T001 Populate `specs/004-demo-ui/research.md` with context7 pulls for constitution, workflow, and Godot `Window`/`Theme` APIs (include citations).
- [x] T002 Document Rijksvoorlichtingsdienst tone guardrails and parliamentary references in `specs/004-demo-ui/research.md` with sourced copy guidelines.
- [x] T003 Capture Rijkshuisstijl accessibility requirements (contrast, focus, typography) and localization key strategy in `specs/004-demo-ui/research.md`.
- [x] T004 Resolve save snapshot format, meter threshold copy variants, and telemetry schema decisions in `specs/004-demo-ui/research.md`.
- [x] T005 Author `specs/004-demo-ui/data-model.md` detailing meters, personas, headlines, calendar events, and save snapshot fields/relationships.
- [x] T006 Create interaction contracts in `specs/004-demo-ui/contracts/` for Messages, News, Polling, Calendar, Coalition Talks, Social, and Debate flows (JSON/YAML as defined in plan).
- [x] T007 Draft `specs/004-demo-ui/quickstart.md` covering desktop launch, social post, coalition decision, debate answer, failure escalation, and save/continue validation steps.
- [x] T008 Update agent context via `.specify/scripts/bash/update-agent-context.sh claude` with demo UI tech stack summary (≤150 lines) once plan artifacts stabilize.

## Tests First (TDD)
- [x] T009 [P] Author failing unit tests in `checks/unit/test_demo_ui_meters.gd` for meter math, threshold flags, and telemetry hooks.
- [x] T010 [P] Author failing integration tests in `checks/integration/test_demo_ui_desktop_flow.gd` covering dock launches, window focus repair, and save/continue restore.
- [x] T011 [P] Author failing contract tests in `checks/contract/test_demo_ui_interactions.gd` validating each app modal/state machine against contracts data.
- [x] T012 [P] Author failing UX regression script in `checks/ui/test_demo_ui_desktop_ux.gd` capturing focus order, keyboard navigation, localization tokens, and screenshot diffs.
- [x] T013 [P] Author failing performance guard tests in `checks/performance/test_demo_ui_budget.gd` asserting <1s window spawn, <2s feedback loops, and <2GB memory.

## Core Implementation
- [x] T014 Build desktop root and window manager in `game/scenes/desktop/DesktopRoot.tscn` and `game/scripts/desktop/DesktopShell.gd` using embedded `Window` subwindows, focus repair, and `request_attention()` hooks.
- [x] T015 Implement dock launch controller in `game/scenes/desktop/Dock.tscn` and `game/scripts/desktop/DockController.gd` with `popup_on_parent()` placement rules and minimized state handling.
- [x] T016 Implement notification/toast pipeline in `game/scenes/desktop/ToastLayer.tscn` and `game/scripts/systems/ToastBus.gd` with priority channels and debounce.
- [x] T017 Implement Messages app UI/logic in `game/scenes/apps/Messages.tscn` and `game/scripts/apps/messages/MessagesApp.gd` consuming contract data for choices and meter deltas.
- [x] T018 Implement News app framing interactions in `game/scenes/apps/News.tscn` and `game/scripts/apps/news/NewsApp.gd` with three framing buttons and copy updates.
- [x] T019 Implement Polling dashboard in `game/scenes/apps/Polling.tscn` and `game/scripts/apps/polling/PollingApp.gd` rendering meters and textual summaries.
- [x] T020 Implement Calendar window in `game/scenes/apps/Calendar.tscn` and `game/scripts/apps/calendar/CalendarApp.gd` with weekly tick and reminder toasts.
- [x] T021 Implement Coalition Talks modal in `game/scenes/apps/CoalitionTalks.tscn` and `game/scripts/apps/coalition/CoalitionTalksApp.gd` producing concessions and toast summaries.
- [x] T022 Implement Social feed composer in `game/scenes/apps/Social.tscn` and `game/scripts/apps/social/SocialFeedApp.gd` triggering persona replies by tag.
- [x] T023 Build debate stage scene in `game/scenes/debate/DebateStage.tscn` and `game/scripts/debate/DebateController.gd` integrating timer, podium animation, and meter impacts.
- [x] T024 Implement save/continue pipeline in `game/scripts/persistence/SessionSerializer.gd` with sample snapshot stored in `game/data/saves/demo_session.json`.

## Experience Integration
- [x] T025 Implement meter feedback orchestrator in `game/scripts/systems/MeterFeedback.gd` to drive escalated copy across toasts, headlines, and social replies.
- [x] T026 Hook telemetry logging via `game/scripts/systems/TelemetryLogger.gd`, persisting to `game/data/logs/demo_sessions.csv`, and document schema in `docs/performance/demo-ui.md`.
- [x] T027 Apply shared theme tokens in `game/ui/themes/DemoDesktopTheme.tres` (desktop) and `game/ui/themes/DebateTheme.tres`, merging variants with `Theme.merge_with()`.
- [x] T028 Implement accessibility and keyboard focus map in `game/scenes/desktop/DesktopRoot.tscn` and `game/scripts/desktop/FocusManager.gd`, including narrator copy annotations.
- [x] T029 Generate localization stub `game/data/localization/demo_ui.pot` and wire localization keys across app scenes.
- [ ] T030 Update `specs/004-demo-ui/quickstart.md` with validation evidence and screenshots after first integrated pass.

## Performance & Polish
- [ ] T031 [P] Execute gdUnit4 performance suite (from `checks/performance/test_demo_ui_budget.gd`) and capture traces plus threshold notes in `docs/performance/demo-ui.md`.
- [ ] T032 [P] Capture UX regression screenshots/diffs from `checks/ui/test_demo_ui_desktop_ux.gd` and archive in `docs/ux/demo-ui/`.
- [ ] T033 [P] Produce macOS export via Godot build pipeline, document steps and artifact location in `docs/mechanics/demo-ui.md`.
- [ ] T034 Review telemetry outputs in `game/data/logs/demo_sessions.csv`, refine schema, and summarize learnings in `docs/performance/demo-ui.md`.
- [ ] T035 Conduct manual playtest per `specs/004-demo-ui/quickstart.md`, logging observations and open issues in `docs/mechanics/demo-ui.md`.

## Dependencies
- T009–T013 must be completed (and fail) before starting T014–T024.
- T014–T024 must be completed before T025–T030 begin.
- T025–T030 must be completed before T031–T035.
- Documentation updates in T030, T033–T035 depend on the corresponding systems being functional.

## Parallel Execution Example
```
# After completing Setup & Tooling (T001–T008), run the test authoring tasks in parallel:
T009 [P] checks/unit/test_demo_ui_meters.gd
T010 [P] checks/integration/test_demo_ui_desktop_flow.gd
T011 [P] checks/contract/test_demo_ui_interactions.gd
T012 [P] checks/ui/test_demo_ui_desktop_ux.gd
T013 [P] checks/performance/test_demo_ui_budget.gd
```

## Notes
- Ensure each [P] task touches isolated files to avoid conflicts.
- Capture evidence (citations, screenshots, performance traces) as part of task completion.
- Update research and documentation artifacts whenever new decisions emerge during implementation.
