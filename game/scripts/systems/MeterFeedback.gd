extends Node

signal meters_updated(snapshot: Array)

@export var desktop_shell_path: NodePath = NodePath("../DesktopRoot")
@export var default_threshold: float = 35.0

var _meters: Dictionary = {
    "support": {"value": 60.0, "threshold": 35.0, "trend": "steady", "is_critical": false},
    "legitimacy": {"value": 55.0, "threshold": 35.0, "trend": "steady", "is_critical": false},
    "donations": {"value": 50.0, "threshold": 35.0, "trend": "steady", "is_critical": false}
}
var _window_snapshots: Dictionary = {}
var _desktop_shell: Control = null

func _ready() -> void:
    _desktop_shell = get_node_or_null(desktop_shell_path) as Control

func load_snapshot(snapshot: Dictionary) -> void:
    if snapshot.has("meters"):
        _meters.clear()
        for meter_entry in snapshot.get("meters", []):
            if not meter_entry is Dictionary:
                continue
            var meter_dict := meter_entry as Dictionary
            var meter_id := String(meter_dict.get("id", "meter"))
            var data: Dictionary = {
                "value": float(meter_dict.get("value", 0.0)),
                "threshold": float(meter_dict.get("critical_threshold", default_threshold)),
                "trend": meter_dict.get("trend", "steady"),
                "is_critical": bool(meter_dict.get("is_critical", false))
            }
            _meters[meter_id] = data
    if snapshot.has("open_windows"):
        _window_snapshots.clear()
        for window_entry in snapshot.get("open_windows", []):
            if window_entry is Dictionary:
                var window_dict := window_entry as Dictionary
                var window_id := String(window_dict.get("id", ""))
                if window_id != "":
                    _window_snapshots[window_id] = window_dict
    _emit_updated()

func apply_meter_effects(source: String, meter_effects: Dictionary) -> Dictionary:
    var deltas: Array[Dictionary] = []
    for meter_id_variant in meter_effects.keys():
        var meter_id := String(meter_id_variant)
        var delta := float(meter_effects[meter_id_variant])
        var meter: Dictionary = _meters.get(meter_id, {
            "value": 50.0,
            "threshold": default_threshold,
            "trend": "steady",
            "is_critical": false
        })
        var current_value := float(meter.get("value", 0.0))
        var new_value := clamp(current_value + delta, 0.0, 100.0)
        meter["value"] = new_value
        meter["trend"] = _resolve_trend(delta)
        var threshold := float(meter.get("threshold", default_threshold))
        var was_critical := bool(meter.get("is_critical", new_value <= threshold))
        var now_critical := new_value <= threshold
        meter["is_critical"] = now_critical
        _meters[meter_id] = meter
        deltas.append({
            "meter_id": meter_id,
            "delta": delta,
            "value": new_value,
            "is_critical": now_critical,
            "was_critical": was_critical
        })
    _emit_updated()
    _publish_toasts(source, deltas)
    return {"deltas": deltas, "meters": _snapshot_array()}

func _publish_toasts(source: String, deltas: Array) -> void:
    if _desktop_shell == null:
        return
    for delta_data_variant in deltas:
        if not delta_data_variant is Dictionary:
            continue
        var delta_data := delta_data_variant as Dictionary
        var delta_value := float(delta_data.get("delta", 0.0))
        var severity := "critical" if bool(delta_data.get("is_critical", false)) else ("warning" if delta_value < 0.0 else "info")
        _desktop_shell.call("show_toast", {
            "toast_id": "%s_%s" % [source, delta_data.get("meter_id", "")],
            "title": "%s meter adjusted" % String(delta_data.get("meter_id", "meter")).capitalize(),
            "body": "Δ %0.1f from %s" % [delta_value, source],
            "severity": severity
        })

func _resolve_trend(delta: float) -> String:
    if delta > 1.0:
        return "rising"
    if delta < -1.0:
        return "falling"
    return "steady"

func _snapshot_array() -> Array[Dictionary]:
    var arr: Array[Dictionary] = []
    for meter_id_variant in _meters.keys():
        var meter_id := String(meter_id_variant)
        var meter := _meters[meter_id_variant] as Dictionary
        arr.append({
            "id": meter_id,
            "value": meter.get("value", 0.0),
            "trend": meter.get("trend", "steady"),
            "is_critical": meter.get("is_critical", false),
            "critical_threshold": meter.get("threshold", default_threshold)
        })
    return arr

func _emit_updated() -> void:
    emit_signal("meters_updated", _snapshot_array())

func current_snapshot() -> Dictionary:
    return {
        "meters": _snapshot_array(),
        "open_windows": _window_snapshots.values()
    }

func record_window_state(window_id: String, data: Dictionary) -> void:
    _window_snapshots[window_id] = data

func window_snapshot(window_id: String) -> Dictionary:
    return _window_snapshots.get(window_id, {})
