# Feature Specification: Playable Desktop-Sim Demo UI

**Feature Branch**: `[004-demo-ui]`  
**Created**: 2025-09-21  
**Status**: Draft  
**Input**: User description: "/specify Create a playable “demo UI” in Godot 4 for COALITION, a Dutch political desktop-sim with serious realism and dark/sarcastic undertones. Focus on WHAT the player sees and does (not the tech details). The demo should (1) feel like a satirical modern-OS desktop and (2) include a lightweight 3D debate stage.

Goals (why): let us validate the core vibe (satirical desktop + fast media rhythms + coalition flavor) before deep systems or AI.

Must show (what):
- A fictional OS desktop shell with wallpaper, app dock/taskbar, draggable/resizable windows, and toasts/notifications.
- Core windows/apps: 
  • “Messages” (staff/party chat threads with choice replies), 
  • “News” (headline cards that can be framed in 2–3 ways), 
  • “Polling” (support, legitimacy, donations as simple meters), 
  • “Calendar” (weekly tick and one upcoming milestone), 
  • “Coalition Talks” (single modal where choosing 1 of 3 concessions shifts meters).
- Social feed: a fast-scrolling timeline that reacts to the player’s short post (no real AI yet; use canned but varied persona replies keyed to simple tags like #budget, #immigration, #climate).
- Debate stage (3D): a minimal scene with podiums and audience ambience, a timed question with 3 answer tones (conciliatory / hardline / evasive) that nudge meters and trigger a short news blurb + social ripple.
- Gradual failure feel: if meters fall too low, add harsher headlines/notifications; no hard game-over.
- Save/continue: a single “Continue Session” button that restores meters and latest open windows (stubbed is fine).

Constraints:
- Runs offline; no live LLMs (stub responses/personas).
- macOS build must be possible.
- Keep tone realistic with satirical bite; use real Dutch institutions in copy (Tweede Kamer, Eerste Kamer, Raad van State) but avoid naming real politicians directly in this demo.
- Keep art simple and readable (flat icons/placeholders). Prioritize clarity over polish.

Acceptance:
- Launch shows desktop, dock, and at least three openable windows. 
- Posting once to the social feed and making one coalition choice and one debate answer all update meters and trigger visible feedback (toasts/headlines/persona replies).
- Player can quit and “Continue Session” to see prior meters and last open app."

## Execution Flow (main)
```
1. Parse user description from Input
   → If empty: ERROR "No feature description provided"
2. Extract key concepts from description
   → Identify: actors, actions, data, constraints
3. For each unclear aspect:
   → Mark with [NEEDS CLARIFICATION: specific question]
4. Fill User Scenarios & Testing section
   → If no clear user flow: ERROR "Cannot determine user scenarios"
5. Generate Functional Requirements
   → Each requirement must be testable
   → Mark ambiguous requirements
6. Identify Key Entities (if data involved)
7. Run Review Checklist
   → If any [NEEDS CLARIFICATION]: WARN "Spec has uncertainties"
   → If implementation details found: ERROR "Remove tech details"
8. Return: SUCCESS (spec ready for planning)
```

---

## User Scenarios & Testing *(mandatory)*

### Primary User Story
As a playtester exploring COALITION’s early demo, I want to experience a satirical Dutch political desktop, interact with core political levers, and feel the immediate media ripple so I can judge whether the tone and pacing fit the intended experience.

### Acceptance Scenarios
1. **Given** a fresh session on macOS, **When** the player opens Messages, News, and Polling windows from the dock, **Then** each window appears in the desktop shell with draggable/resizable chrome and active content tied to the current coalition snapshot.
2. **Given** the player posts a tagged social update, chooses a concession in Coalition Talks, and answers one debate prompt, **When** those actions resolve, **Then** support/legitimacy/donations meters adjust, contextual toasts/headlines/social replies fire, and the desktop reflects the shifted mood.
3. **Given** the player exits to the title screen after engaging with at least one app, **When** they press Continue Session, **Then** the prior meters, open-window state, and latest feed items are restored for immediate continuation.

### Edge Cases
- Desktop should gracefully handle multiple overlapping windows (including snapped edges) without losing input focus.
- If any meter crosses the defined “critical” threshold, harsher copy and visuals trigger but the session remains recoverable.
- Offline-only constraint verified by running without network access: all content loads from local stubs.
- Debate timer expiry without selection defaults to a neutral outcome and logs a warning toast.

## Requirements *(mandatory)*

### Functional Requirements
- **FR-001**: The shell MUST display wallpaper, dock/taskbar, and a notifications area on launch.
- **FR-002**: Each core app window (Messages, News, Polling, Calendar, Coalition Talks) MUST open from the dock and support drag, resize, minimize, and close behaviors.
- **FR-003**: Messages MUST present scripted party/staff threads with at least three reply choices per thread that adjust narrative tone and feed cues.
- **FR-004**: News MUST show headline cards with three framing buttons per headline (e.g., pragmatic, sensational, reformist) that alter subsequent copy and meter nudges.
- **FR-005**: Polling MUST visualize support, legitimacy, and donations via meters plus textual summaries that update after every player decision.
- **FR-006**: Calendar MUST surface the current in-game week, one upcoming milestone (e.g., Eerste Kamer vote), and trigger reminder toasts as the week advances.
- **FR-007**: Coalition Talks modal MUST offer three concessions whose selections immediately update meters and push a toast summarizing the trade-off.
- **FR-008**: Social feed MUST allow the player to compose a short tagged post once per in-game day and respond with canned persona replies based on selected tag.
- **FR-009**: The debate stage MUST present a 3D scene with podiums, ambient crowd loop, a timed question, and three answer tones whose selection updates meters and injects a headline plus social feed ripple.
- **FR-010**: All meter adjustments MUST cascade to copy changes (harsher headlines, toasts) when thresholds are crossed; no hard fail state allowed.
- **FR-011**: The experience MUST operate offline with all narrative content, personas, and responses stored locally.
- **FR-012**: A Continue Session entry point MUST persist and restore meters plus the last active window layout between launches.
- **FR-013**: macOS export target MUST be verified by producing a playable build artifact during QA.
- **FR-014**: Session telemetry (time in apps, meter swings, debate choices) MUST be logged locally for qualitative review.

### Key Entities *(include if feature involves data)*
- **Meters**: Support, Legitimacy, Donations — store current value, critical thresholds, last change source.
- **Personas**: Pre-scripted social voices keyed to tags (#budget, #immigration, #climate, #defense) with reply variants.
- **Headlines**: Title, framing options, associated meter deltas, escalation copy for failure states.
- **Calendar Events**: Date, institution (Tweede Kamer, Eerste Kamer, Raad van State), reminder text, consequence description.
- **Save Snapshot**: Timestamp, meters state, open windows list, latest feed entries, pending debate question.

---

## Review & Acceptance Checklist
*GATE: Automated checks run during main() execution*

### Content Quality
- [x] No implementation details (languages, frameworks, APIs)
- [x] Focused on user value and business needs
- [x] Written for non-technical stakeholders
- [x] All mandatory sections completed

### Requirement Completeness
- [x] No [NEEDS CLARIFICATION] markers remain
- [x] Requirements are testable and unambiguous  
- [x] Success criteria are measurable
- [x] Scope is clearly bounded
- [x] Dependencies and assumptions identified

---

## Execution Status
*Updated by main() during processing*

- [x] User description parsed
- [x] Key concepts extracted
- [x] Ambiguities marked
- [x] User scenarios defined
- [x] Requirements generated
- [x] Entities identified
- [x] Review checklist passed

---
