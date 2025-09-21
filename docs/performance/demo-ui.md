# Telemetry & Performance Evidence – Demo UI Vertical Slice

## Session Telemetry Schema
Telemetry events are appended to `user://demo_sessions.csv` via `game/scripts/systems/TelemetryLogger.gd`.
Each row captures the immediate impact of a player decision on core meters.

| Column | Description |
| --- | --- |
| `timestamp_iso` | UTC timestamp captured when the event is logged. |
| `source` | Originating system (`messages`, `news`, `social`, `coalition`, etc.). |
| `meter_id` | Meter adjusted by the event (`support`, `legitimacy`, `donations`). |
| `delta` | Signed change applied to the meter (percentage points). |
| `value` | Resulting meter value after the delta. |
| `is_critical` | `true` when the meter fell at or below its critical threshold after the update. |

## Evidence Capture Checklist
- Before running automated suites, clear historical logs with `rm user://demo_sessions.csv` (or via in-game reset).
- After each playtest or automated run, archive the CSV alongside quickstart evidence.
- Flag any row where `is_critical == true` and correlate with toast/headline severity changes.

## Performance Notes
- DesktopShell records toast notifications for each meter delta, enabling quick correlation between telemetry rows and user-visible feedback.
- gdUnit4 budget checks should parse the CSV to ensure no decision exceeds configured latency targets (<2s feedback window).
