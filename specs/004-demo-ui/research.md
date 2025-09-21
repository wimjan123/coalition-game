# Research Notes: Playable Desktop-Sim Demo UI

## Engine References
- Embed desktop apps using Godot 4 `Window` subwindows with `popup()` and `popup_on_parent()` to control launch positions and keep windows within the main viewport; fall back on `get_focused_window()` to repair focus when multiple dialogs overlap; use `request_attention()` to surface high-priority toasts for urgent copy.【turn6search0】【turn6search7】
- Keep window chrome in single-window mode by enabling `ProjectSettings.display/window/subwindows/embed_subwindows` so all app windows draw within the desktop scene; rely on `Window.is_embedded()` checks before spawning modal views.【turn6search0】

## Theme Strategy
- Centralize typography, color, spacing, and corner radius tokens in `game/ui/themes/DemoDesktopTheme.tres`; derive debate-specific tweaks via `Theme.merge_with()` to reuse base tokens while adjusting lighting and podium colors.【turn7search5】
- Define reusable theme types (`desktop_window`, `toast`, `debate_prompt`) and scope constants (padding, min sizes) to keep Control nodes aligned with the design tokens.

## Tone & Narrative Guardrails
- Rijksvoorlichtingsdienst (RVD) communication is responsible for delivering accurate, neutral government information; tone should balance clarity with respectful satire by referencing authentic Dutch institutions without naming current politicians.【turn3search1】
- Dutch government communication principles emphasize accessibility, transparency, and providing citizens with timely, understandable context; copy should stay plain-language, explain consequences of decisions, and avoid jargon unless the interface defines it.【turn5search2】

## Accessibility & Localization
- Follow the Rijkshuisstijl digital accessibility guidance: maintain minimum 4.5:1 contrast for body text, provide visible focus indicators, and expose keyboard navigation for all interactive desktop elements.【turn1search7】
- Provide localization hooks for Dutch/English toggle by routing all user-facing strings through `.pot` keys; include narrator copy variants that expand acronyms at first mention.

## Save Snapshot Decisions
- Persist a single-slot snapshot (`demo_session.json`) capturing meters (value, trend, threshold flag), open window IDs with geometry, unread toast queue, social feed buffer (latest 10 items), current calendar week, upcoming milestone, debate state (active question, timer), and last persona replies.
- Use `ConfigFile` to serialize/deserialize the snapshot for simplicity; provide migration header (`schema_version`) to guard future changes.

## Telemetry & Profiling Plan
- Log structured CSV rows per decision event (timestamp, app source, choice tag, meter delta summary) to `game/data/logs/demo_sessions.csv` for qualitative review.
- Instrument critical flows (dock open, message send, debate choice) with Godot `@profile` markers and sample memory usage at debate start/end; align with gdUnit4 performance guard thresholds.

## Outstanding Questions
- Debate stage camera polish TBD after first integrated pass; will capture findings in quickstart validation notes.
- Persona library currently stubbed; expand variants after initial playtest feedback.
