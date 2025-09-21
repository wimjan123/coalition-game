# Quickstart Playtest Script – Demo UI Vertical Slice

## Pre-Flight
1. Launch `game/project.godot` in Godot 4.3.
2. Ensure demo content packs (`game/data/personas`, `game/data/headlines`, `game/data/calendar`) are loaded.
3. Clear existing snapshot by deleting `game/data/saves/demo_session.json`.

## Flow Overview
1. **Desktop Boot**
   - Start the demo and observe wallpaper, dock, notification tray.
   - Verify three default windows (Messages, News, Polling) openable from dock and draggable/resizable.
2. **Messages Decision**
   - Open Messages, pick the highlighted thread, choose a reply with `#budget` tag.
   - Confirm toast summary appears; Polling updates support meter.
3. **News Framing**
   - Reframe a headline using the `pragmatic` option.
   - Validate headline copy swap and persona chatter in social sidebar.
4. **Social Post**
   - Post a social update tagged `#immigration`.
   - Confirm persona replies populate feed; Polling shows legitimacy delta.
5. **Coalition Talks**
   - Open Coalition Talks modal, select “Infrastructure compromise”.
   - Ensure toast and feed insert reflect concession; check donations meter adjustment.
6. **Calendar Reminder**
   - Advance to next week via Calendar; confirm reminder toast for institutional milestone.
7. **Debate Stage**
   - Enter debate scene, choose `hardline` answer before timer expires.
   - Verify news blurb injection, social ripple, and animation playback.
8. **Failure Escalation Check**
   - Continue actions until any meter falls below its critical threshold.
   - Confirm harsher headlines/toasts and Polling crisis copy.
9. **Save & Continue**
   - Exit to title, hit “Continue Session”.
   - Validate meters, open window layout, toast queue, feed items restore.

## Evidence Capture
- Record clips or screenshots for: initial desktop, Messages reply toast, News framing change, debate podium response, post-resume desktop.
- Export telemetry log (`game/data/logs/demo_sessions.csv`) after playtest and attach to test artefacts.
- Archive gdUnit4 performance run results in `docs/performance/demo-ui.md`.

## Regression Checklist
- Dock launches correct window every time; no orphaned focus states.
- Notifications stack without overlap and respect priority ordering.
- Keyboard navigation traverses dock → windows → modals without traps.
- Debate timer resets between questions; timeout shows neutral resolution toast.
- Save snapshot version matches expected `schema_version`.
