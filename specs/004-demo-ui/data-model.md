# Data Model: Playable Desktop-Sim Demo UI

## Meters
| Field | Type | Description |
| --- | --- | --- |
| `id` | String (`support` \| `legitimacy` \| `donations`) | Unique meter identifier. |
| `display_name` | Localized String Key | UI label resolved via localization table. |
| `value` | Float (0–100) | Current score. |
| `delta_last_turn` | Float | Change applied by the most recent player action. |
| `trend` | Enum (`rising`, `steady`, `falling`) | Derived from moving average of last 3 deltas. |
| `critical_threshold` | Float | Value triggering failure messaging when crossed. |
| `is_critical` | Bool | Computed flag when `value <= critical_threshold`. |
| `copy_variant` | String | Tone variant (`neutral`, `pressure`, `crisis`) used by toasts/headlines when `is_critical` flips. |
| `last_updated_by` | String | Source app (`messages`, `news`, `polling`, `calendar`, `coalition`, `social`, `debate`). |

## Personas (Social Feed)
| Field | Type | Description |
| --- | --- | --- |
| `id` | String | Persona slug (e.g., `press_correspondent`). |
| `display_name` | Localized String Key | Name shown in feed. |
| `affiliation` | Enum (`media`, `party`, `ngo`, `citizen`) | Tone and language guidance. |
| `tags_supported` | Array<String> | Tags persona reacts to (`#budget`, `#immigration`, `#climate`, `#defense`). |
| `reply_variants` | Map<Tag, Array<Localized String Key>> | Reply pool keyed by tag. |
| `escalation_variant` | Localized String Key | Sharper reply used when related meter is critical. |
| `avatar_icon` | Resource Path | Flat icon reference in `game/ui/icons/`. |

## Headlines (News)
| Field | Type | Description |
| --- | --- | --- |
| `id` | String | Headline slug. |
| `title` | Localized String Key | Base headline copy. |
| `lead` | Localized String Key | One-sentence summary. |
| `framing_options` | Array<Framing Option> | Each option contains `id`, `label_key`, `meter_effects`, `headline_variant_key`. |
| `meter_effects` | Map<Meter ID, Float> | Delta applied when framing is selected. |
| `threshold_variant_key` | Localized String Key | Harsher copy when any linked meter is critical. |
| `tag` | String | Social tag triggered when story is reframed. |

### Framing Option (embedded)
| Field | Type | Description |
| --- | --- | --- |
| `id` | String | Option slug (`pragmatic`, `sensational`, `reformist`). |
| `label_key` | Localized String Key | Button title. |
| `meter_effects` | Map<Meter ID, Float> | Applied immediately. |
| `headline_variant_key` | Localized String Key | Alternated copy.

## Calendar Events
| Field | Type | Description |
| --- | --- | --- |
| `id` | String | Event slug (e.g., `raad_van_state_review`). |
| `week` | Integer | Week index within demo timeline (0-based). |
| `institution` | Enum (`Tweede Kamer`, `Eerste Kamer`, `Raad van State`) | Drives iconography. |
| `reminder_text_key` | Localized String Key | Toast copy triggered when approaching week. |
| `consequence_summary_key` | Localized String Key | Describes what happens if player is unprepared. |
| `meter_targets` | Map<Meter ID, Float> | Minimum recommended meter values; drives warning highlights. |

## Debate Questions
| Field | Type | Description |
| --- | --- | --- |
| `id` | String | Question slug. |
| `prompt_key` | Localized String Key | Debate question copy. |
| `answers` | Array<Answer Option> | Each option toggles a tone. |
| `timer_seconds` | Int | Response window; default 25s. |
| `follow_up_headline_key` | Localized String Key | News blurb injected post-answer. |
| `social_ripple_tag` | String | Tag used to fetch persona replies. |

### Answer Option (embedded)
| Field | Type | Description |
| --- | --- | --- |
| `tone` | Enum (`conciliatory`, `hardline`, `evasive`) | Display label and animation state. |
| `meter_effects` | Map<Meter ID, Float> | Applied to relevant meters. |
| `toast_key` | Localized String Key | Summary toast copy. |
| `persona_bias` | Map<Tag, Float> | Weighting to decide persona reply order. |

## Save Snapshot
| Field | Type | Description |
| --- | --- | --- |
| `schema_version` | Int | Incremented on breaking changes. |
| `timestamp_iso` | String | ISO timestamp when snapshot written. |
| `week_index` | Int | Current week in calendar. |
| `meters` | Array<Meter Snapshot> | Values for each meter. |
| `open_windows` | Array<Window Snapshot> | Windows to restore with geometry/state. |
| `toast_queue` | Array<Toast Snapshot> | Pending notifications. |
| `social_feed` | Array<Feed Item> | Latest 10 feed entries. |
| `latest_headlines` | Array<String> | Headline IDs shown in News window.
| `pending_calendar_events` | Array<String> | IDs of events not yet resolved. |
| `debate_state` | Debate Snapshot | Active question, timer, answer history. |

### Meter Snapshot (embedded)
| Field | Type | Description |
| --- | --- | --- |
| `id` | String | Meter identifier. |
| `value` | Float | Current value. |
| `trend` | Enum | Last trend state. |
| `is_critical` | Bool | Critical flag persisted for UI restore. |

### Window Snapshot (embedded)
| Field | Type | Description |
| --- | --- | --- |
| `id` | String | Scene identifier (e.g., `messages`, `polling`). |
| `rect` | Rect2 | Position/size in pixels. |
| `is_minimized` | Bool | Dock minimized state. |
| `scroll_state` | Map | Optional map storing scroll offsets or selected index. |

### Toast Snapshot (embedded)
| Field | Type | Description |
| --- | --- | --- |
| `id` | String | Toast slug. |
| `title_key` | Localized String Key | Toast title. |
| `body_key` | Localized String Key | Body copy. |
| `severity` | Enum (`info`, `warning`, `critical`) | Visual style.

### Feed Item (embedded)
| Field | Type | Description |
| --- | --- | --- |
| `persona_id` | String | Persona posting the reply. |
| `tag` | String | Hash tag associated with the reply. |
| `text_key` | Localized String Key | Reply content. |
| `meter_reference` | String | Optional meter id referenced in copy. |

### Debate Snapshot (embedded)
| Field | Type | Description |
| --- | --- | --- |
| `question_id` | String | ID of the current prompt. |
| `timer_remaining` | Float | Seconds remaining when saved. |
| `answers_taken` | Array<String> | History of tones chosen. |
| `news_triggered` | Array<String> | Headline IDs already injected. |

## Relationships & Derived Data
- `meter_effects` fields across entities feed into `MeterFeedback.gd` to calculate copy variants.
- Social feed consumes personas filtered by `tags_supported`; persona replies escalate when linked meter snapshot marks `is_critical`.
- Calendar reminders schedule toasts and docking badges when `week_index` approaches an event's `week` minus one.
- Debate outcomes push new headlines and social tags, ensuring telemetry logs capture both the answer taken and downstream copy triggers.
