extends Node

@export var desktop_shell_path: NodePath = NodePath("..")
@export var meter_feedback_path: NodePath = NodePath("../MeterFeedback")
@export var serializer_path: NodePath = NodePath("../SessionSerializer")

const PERSONA_TAGS_PATH := "res://data/personas/personas.json"
const MESSAGES_PATH := "res://data/messages/threads.json"
const HEADLINES_PATH := "res://data/news/headlines.json"
const CALENDAR_PATH := "res://data/calendar/events.json"
const COALITION_PATH := "res://data/coalition/offers.json"
const SOCIAL_PATH := "res://data/social/social_config.json"

var _desktop_shell: Node = null
var _meter_feedback: Node = null
var _serializer: Node = null
var _messages_contract := {}
var _headlines := []
var _calendar_events := []
var _coalition_context := {}
var _coalition_offers := []
var _social_config := {}
var _persona_map := {}
var _initial_snapshot := {}
var _window_rects := {}
var _meter_titles := {
    "support": "Support",
    "legitimacy": "Legitimacy",
    "donations": "Donations"
}

func _ready() -> void:
    _desktop_shell = get_node_or_null(desktop_shell_path)
    _meter_feedback = get_node_or_null(meter_feedback_path)
    _serializer = get_node_or_null(serializer_path)
    _load_content()
    if _desktop_shell:
        _desktop_shell.window_opened.connect(on_window_opened)
    if _serializer and _serializer.has_method("load_snapshot"):
        _initial_snapshot = _serializer.call("load_snapshot")
        if _meter_feedback and _meter_feedback.has_method("load_snapshot"):
            _meter_feedback.call("load_snapshot", _initial_snapshot)
        for window_dict in _initial_snapshot.get("open_windows", []):
            var window_id := window_dict.get("id", "")
            if window_id != "":
                _window_rects[window_id] = window_dict

func _load_content() -> void:
    var messages_payload := _load_json(MESSAGES_PATH)
    _messages_contract = {"threads": messages_payload.get("threads", [])}
    _headlines = _load_json(HEADLINES_PATH).get("headlines", [])
    var calendar_payload := _load_json(CALENDAR_PATH)
    _calendar_events = calendar_payload.get("events", [])
    _coalition_context = _load_json(COALITION_PATH).get("context", {})
    _coalition_offers = _load_json(COALITION_PATH).get("offers", [])
    _social_config = _load_json(SOCIAL_PATH)
    _persona_map = _load_json(PERSONA_TAGS_PATH).get("personas", {})

func _load_json(path: String) -> Dictionary:
    if not ResourceLoader.exists(path):
        return {}
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return {}
    var text := file.get_as_text()
    file.close()
    var parsed := JSON.parse_string(text)
    if typeof(parsed) == TYPE_DICTIONARY:
        return parsed
    return {}

func on_window_opened(window_id: String, window_instance: Window) -> void:
    match window_id:
        "messages":
            if window_instance.has_method("load_contract"):
                window_instance.call("load_contract", _messages_contract)
        "news":
            if window_instance.has_method("load_headlines"):
                window_instance.call("load_headlines", _headlines)
        "polling":
            if _meter_feedback and _meter_feedback.has_method("current_snapshot"):
                var snapshot := _meter_feedback.call("current_snapshot")
                window_instance.call("apply_snapshot", snapshot.get("meters", []), build_polling_commentary(snapshot.get("meters", [])))
        "calendar":
            var week := int(_initial_snapshot.get("week_index", 0))
            if window_instance.has_method("set_timeline"):
                window_instance.call("set_timeline", week, _calendar_events)
        "coalition":
            if window_instance.has_method("load_context"):
                window_instance.call("load_context", _coalition_context, _coalition_offers)
        "social":
            if window_instance.has_method("configure_posts"):
                window_instance.call("configure_posts", _social_config.get("posts", []), _social_config.get("posts_remaining", 1))
            if window_instance.has_method("append_feed"):
                window_instance.call("append_feed", _social_config.get("initial_feed", []))
    _apply_window_snapshot(window_id, window_instance)

func on_meter_event(source: String, payload: Dictionary, result: Dictionary) -> void:
    if source == "social":
        _handle_social_ripple(payload)
    elif source == "messages":
        _handle_message_followup(payload)
    elif source == "news":
        _handle_news_followup(payload)
    elif source == "coalition":
        _handle_coalition_followup(payload)

func _handle_social_ripple(payload: Dictionary) -> void:
    var tag := payload.get("tag", "")
    var replies := payload.get("persona_replies", [])
    if replies.is_empty():
        replies = _persona_replies_for_tag(tag)
    _push_social_feed(replies)

func _handle_message_followup(payload: Dictionary) -> void:
    var tag := payload.get("tag", "")
    _push_social_feed(_persona_replies_for_tag(tag))

func _handle_news_followup(payload: Dictionary) -> void:
    var tag := payload.get("social_tag", "")
    _push_social_feed(_persona_replies_for_tag(tag))

func _handle_coalition_followup(payload: Dictionary) -> void:
    var tag := payload.get("tag", "")
    _push_social_feed(_persona_replies_for_tag(tag))

func _push_social_feed(entries: Array) -> void:
    if entries.is_empty():
        return
    if _desktop_shell == null:
        return
    var social_window := _desktop_shell.get_window("social")
    if social_window and social_window.has_method("append_feed"):
        social_window.call("append_feed", entries)
    else:
        _social_config["initial_feed"] = _social_config.get("initial_feed", []) + entries

func _persona_replies_for_tag(tag: String) -> Array:
    if tag == "" or _persona_map.is_empty():
        return []
    var replies: Array = []
    for persona_id in _persona_map.keys():
        var persona := _persona_map[persona_id]
        var tag_map := persona.get("replies", {})
        if tag_map.has(tag):
            replies.append({
                "persona": persona.get("display_name", persona_id.capitalize()),
                "text": tag_map[tag]
            })
    return replies

func build_polling_commentary(meters: Array) -> Array:
    var commentary: Array = []
    for meter in meters:
        var tone := meter.get("is_critical", false) ? "crisis" : meter.get("trend", "steady")
        var name := _meter_titles.get(meter.get("id", ""), meter.get("id", "Meter").capitalize())
        var message := "%s %s" % [name, tone]
        commentary.append({"body": message})
    return commentary

func on_window_closed(_window_id: String) -> void:
    pass

func _apply_window_snapshot(window_id: String, window_instance: Window) -> void:
    var snapshot := _window_rects.get(window_id, null)
    if snapshot == null:
        return
    var rect := snapshot.get("rect", [])
    if rect.size() == 4:
        window_instance.position = Vector2(rect[0], rect[1])
        window_instance.size = Vector2(rect[2], rect[3])
