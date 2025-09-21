extends Control

## DesktopShell orchestrates window lifecycle and integrates dock + toast systems.
## Windows are expected to be Window nodes instanced as embedded subwindows.

signal window_opened(window_id: String, window_instance: Window)
signal window_closed(window_id: String)

@export var dock_scene: PackedScene
@export var toast_layer_path: NodePath = NodePath("ToastCanvas")
@export var meter_feedback_path: NodePath = NodePath("MeterFeedback")
@export var telemetry_logger_path: NodePath = NodePath("TelemetryLogger")
@export var focus_manager_path: NodePath = NodePath("FocusManager")
@export var bootstrap_path: NodePath = NodePath("DemoBootstrap")
@export var window_configs: Array[Dictionary] = []

const WINDOW_ROOT_PATH := NodePath("WindowRoot")
const DOCK_ANCHOR_PATH := NodePath("DockAnchor")

var _window_registry: Dictionary = {}
var _active_windows: Dictionary = {}
var _toast_bus: Node = null
var _meter_feedback: Node = null
var _telemetry_logger: Node = null
var _focus_manager: Node = null
var _bootstrap: Node = null

func _ready() -> void:
    _ensure_dock()
    _toast_bus = get_node_or_null(toast_layer_path)
    _meter_feedback = get_node_or_null(meter_feedback_path)
    if _meter_feedback and _meter_feedback.has_signal("meters_updated"):
        _meter_feedback.connect("meters_updated", Callable(self, "_on_meters_updated"))
    _telemetry_logger = get_node_or_null(telemetry_logger_path)
    _focus_manager = get_node_or_null(focus_manager_path)
    _bootstrap = get_node_or_null(bootstrap_path)
    _bootstrap_windows()

func register_window(window_id: String, scene: PackedScene, metadata: Dictionary = {}) -> void:
    _window_registry[window_id] = {
        "scene": scene,
        "metadata": metadata
    }
    if dock_scene:
        var dock: Node = _get_dock()
        if dock and dock.has_method("register_app"):
            dock.call("register_app", window_id, metadata)

func toggle_window(window_id: String) -> void:
    if not _window_registry.has(window_id):
        push_warning("toggle_window: Unknown window id %s" % window_id)
        return
    if _active_windows.has(window_id):
        _close_window(window_id)
    else:
        _spawn_window(window_id)

func open_window(window_id: String) -> void:
    if _active_windows.has(window_id):
        _focus_window(window_id)
        return
    _spawn_window(window_id)

func close_window(window_id: String) -> void:
    if _active_windows.has(window_id):
        _close_window(window_id)

func get_window_instance(window_id: String) -> Window:
    return _active_windows.get(window_id, null)

func request_attention(window_id: String) -> void:
    var window := _active_windows.get(window_id, null)
    if window and window.has_method("request_attention"):
        window.request_attention()

func show_toast(payload: Dictionary) -> void:
    if _toast_bus and _toast_bus.has_method("queue_toast"):
        _toast_bus.call("queue_toast", payload)

func _spawn_window(window_id: String) -> void:
    var record: Dictionary = _window_registry.get(window_id, {})
    if record.is_empty():
        return
    var scene := record.get("scene", null) as PackedScene
    if scene == null:
        return
    var instance := scene.instantiate() as Window
    if instance == null:
        return
    instance.name = window_id
    var metadata: Dictionary = record.get("metadata", {})
    instance.position = _get_spawn_position(metadata)
    instance.transient = true
    instance.popup()
    _active_windows[window_id] = instance
    var window_root := get_node(WINDOW_ROOT_PATH)
    window_root.add_child(instance)
    instance.connect("close_requested", Callable(self, "_on_window_close_requested").bind(window_id))
    _wire_window_signals(window_id, instance)
    _register_focus_target(window_id, instance, metadata)
    _focus_window(window_id)
    _update_dock_state(window_id, true)
    if _bootstrap and _bootstrap.has_method("on_window_opened"):
        _bootstrap.call("on_window_opened", window_id, instance)
    window_opened.emit(window_id, instance)

func _close_window(window_id: String) -> void:
    var instance: Window = _active_windows.get(window_id, null)
    if instance:
        instance.queue_free()
    _active_windows.erase(window_id)
    _update_dock_state(window_id, false)
    if _focus_manager and _focus_manager.has_method("unregister_window"):
        _focus_manager.call("unregister_window", window_id)
    if _bootstrap and _bootstrap.has_method("on_window_closed"):
        _bootstrap.call("on_window_closed", window_id)
    window_closed.emit(window_id)

func _focus_window(window_id: String) -> void:
    var instance: Window = _active_windows.get(window_id, null)
    if instance:
        instance.grab_focus()
        if instance.has_method("move_to_front"):
            instance.move_to_front()

func _get_spawn_position(metadata: Dictionary) -> Vector2:
    var spawn_variant := metadata.get("spawn_position", null)
    if spawn_variant is Vector2:
        return spawn_variant
    return Vector2(120, 120) + Vector2(_active_windows.size() * 24, _active_windows.size() * 24)

func _ensure_dock() -> void:
    if not dock_scene:
        return
    var dock_anchor := get_node(DOCK_ANCHOR_PATH)
    if dock_anchor.get_child_count() > 0:
        return
    var dock_instance := dock_scene.instantiate()
    dock_anchor.add_child(dock_instance)
    dock_instance.owner = dock_anchor
    if dock_instance.has_signal("app_toggled"):
        dock_instance.connect("app_toggled", Callable(self, "_on_dock_app_toggled"))

func _get_dock() -> Node:
    var dock_anchor := get_node(DOCK_ANCHOR_PATH)
    if dock_anchor.get_child_count() == 0:
        return null
    return dock_anchor.get_child(0)

func _update_dock_state(window_id: String, is_open: bool) -> void:
    var dock := _get_dock()
    if dock and dock.has_method("set_window_state"):
        dock.call("set_window_state", window_id, is_open)

func _bootstrap_windows() -> void:
    for config_variant in window_configs:
        var config := config_variant
        if not config is Dictionary:
            continue
        var window_id := String(config.get("window_id", ""))
        var scene := config.get("scene", null) as PackedScene
        if scene == null or window_id == "":
            continue
        var metadata: Dictionary = config.duplicate()
        metadata.erase("scene")
        metadata.erase("window_id")
        register_window(window_id, scene, metadata)
        if metadata.get("start_open", false):
            open_window(window_id)

func _on_window_close_requested(window_id: String) -> void:
    close_window(window_id)

func _on_dock_app_toggled(window_id: String) -> void:
    toggle_window(window_id)

func _wire_window_signals(window_id: String, window_instance: Node) -> void:
    match window_id:
        "messages":
            if window_instance.has_signal("reply_committed"):
                window_instance.connect("reply_committed", Callable(self, "_on_messages_reply").bind(window_id))
        "news":
            if window_instance.has_signal("framing_committed"):
                window_instance.connect("framing_committed", Callable(self, "_on_news_framing").bind(window_id))
        "coalition":
            if window_instance.has_signal("offer_committed"):
                window_instance.connect("offer_committed", Callable(self, "_on_coalition_offer").bind(window_id))
        "social":
            if window_instance.has_signal("post_committed"):
                window_instance.connect("post_committed", Callable(self, "_on_social_post").bind(window_id))

func _on_messages_reply(payload: Dictionary, window_id: String) -> void:
    _process_meter_event("messages", payload)

func _on_news_framing(payload: Dictionary, window_id: String) -> void:
    _process_meter_event("news", payload)

func _on_coalition_offer(payload: Dictionary, window_id: String) -> void:
    _process_meter_event("coalition", payload)

func _on_social_post(payload: Dictionary, window_id: String) -> void:
    _process_meter_event("social", payload)

func _process_meter_event(source: String, payload: Dictionary) -> void:
    if _meter_feedback:
        var result := _meter_feedback.call("apply_meter_effects", source, payload.get("meter_effects", {}))
        _record_meter_event(source, result)
        _dispatch_meter_update(result)
        if _bootstrap and _bootstrap.has_method("on_meter_event"):
            _bootstrap.call("on_meter_event", source, payload, result)

func _on_meters_updated(snapshot: Array) -> void:
    _dispatch_meter_update({"meters": snapshot})

func _dispatch_meter_update(result: Dictionary) -> void:
    if result == null:
        return
    var meters := result.get("meters", [])
    var commentary: Array = []
    if _bootstrap and _bootstrap.has_method("build_polling_commentary"):
        commentary = _bootstrap.call("build_polling_commentary", meters)
    for window_id_variant in _active_windows.keys():
        var window_id := String(window_id_variant)
        var window := _active_windows[window_id_variant] as Window
        if window and window_id == "polling" and window.has_method("apply_snapshot"):
            window.call("apply_snapshot", meters, commentary)

func _record_meter_event(source: String, result: Dictionary) -> void:
    if _telemetry_logger == null or result == null:
        return
    var deltas := result.get("deltas", [])
    if deltas.is_empty():
        return
    if _telemetry_logger.has_method("log_meter_deltas"):
        _telemetry_logger.call("log_meter_deltas", source, deltas)

func _register_focus_target(window_id: String, window_instance: Node, metadata: Dictionary) -> void:
    if _focus_manager == null or not _focus_manager.has_method("register_window"):
        return
    var focus_path_variant := metadata.get("focus_path", NodePath(""))
    var focus_path: NodePath = focus_path_variant if focus_path_variant is NodePath else NodePath(String(focus_path_variant))
    var focus_node: Control = null
    if not focus_path.is_empty() and window_instance.has_node(focus_path):
        focus_node = window_instance.get_node(focus_path)
    elif window_instance.has_node("Content"):
        var candidate := window_instance.get_node("Content")
        if candidate is Control:
            focus_node = candidate
    if focus_node:
        var label := String(metadata.get("display_name", window_id.capitalize()))
        if focus_node is Control:
            focus_node.accessible_description = "Desktop window: %s" % label
        _focus_manager.call("register_window", window_id, focus_node)
