extends Node

signal meters_updated(snapshot: Array)

@export var desktop_shell_path: NodePath = NodePath("../DesktopRoot")
@export var default_threshold := 35.0

var _meters := {
    "support": {"value": 60.0, "threshold": 35.0, "trend": "steady"},
    "legitimacy": {"value": 55.0, "threshold": 35.0, "trend": "steady"},
    "donations": {"value": 50.0, "threshold": 35.0, "trend": "steady"}
}
var _window_snapshots := {}
var _desktop_shell: Node = null

func _ready() -> void:
    _desktop_shell = get_node_or_null(desktop_shell_path)

func load_snapshot(snapshot: Dictionary) -> void:
    if snapshot.has("meters"):
        _meters.clear()
        for meter in snapshot["meters"]:
            var data := {
                "value": float(meter.get("value", 0.0)),
                "threshold": float(meter.get("critical_threshold", default_threshold)),
                "trend": meter.get("trend", "steady")
            }
            _meters[meter.get("id", "meter")] = data
    if snapshot.has("open_windows"):
        _window_snapshots = {}
        for window in snapshot["open_windows"]:
            _window_snapshots[window.get("id")] = window
    _emit_updated()

func apply_meter_effects(source: String, meter_effects: Dictionary) -> Dictionary:
    var deltas := []
    for meter_id in meter_effects.keys():
        var delta := float(meter_effects[meter_id])
        var meter := _meters.get(meter_id, {
            "value": 50.0,
            "threshold": default_threshold,
            "trend": "steady"
        })
        meter["value"] = clamp(meter["value"] + delta, 0.0, 100.0)
        meter["trend"] = _resolve_trend(delta)
        var was_critical := meter.get("is_critical", meter["value"] <= meter["threshold"])
        meter["is_critical"] = meter["value"] <= meter["threshold"]
        _meters[meter_id] = meter
        deltas.append({
            "meter_id": meter_id,
            "delta": delta,
            "value": meter["value"],
            "is_critical": meter["is_critical"],
            "was_critical": was_critical
        })
    _emit_updated()
    _publish_toasts(source, deltas)
    return {"deltas": deltas, "meters": _snapshot_array()}

func _publish_toasts(source: String, deltas: Array) -> void:
    if _desktop_shell == null:
        return
    for delta_data in deltas:
        var severity := "info"
        if delta_data["is_critical"]:
            severity = "critical"
        elif delta_data["delta"] < 0:
            severity = "warning"
        _desktop_shell.show_toast({
            "toast_id": "%s_%s" % [source, delta_data["meter_id"]],
            "title": "%s meter adjusted" % delta_data["meter_id"].capitalize(),
            "body": "Δ %0.1f from %s" % [delta_data["delta"], source],
            "severity": severity
        })

func _resolve_trend(delta: float) -> String:
    if delta > 1.0:
        return "rising"
    if delta < -1.0:
        return "falling"
    return "steady"

func _snapshot_array() -> Array:
    var arr: Array = []
    for meter_id in _meters.keys():
        var meter := _meters[meter_id]
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
