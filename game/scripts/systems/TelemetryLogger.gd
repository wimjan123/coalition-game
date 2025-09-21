extends Node

@export var log_path := "user://demo_sessions.csv"
@export var include_headers := true

var _headers_written: bool = false
var _headers: Array[String] = ["timestamp_iso", "source", "meter_id", "delta", "value", "is_critical"]

func _ready() -> void:
    _ensure_directory()
    _headers_written = FileAccess.file_exists(log_path)

func log_meter_deltas(source: String, deltas: Array) -> void:
    if deltas.is_empty():
        return
    var mode: FileAccess.ModeFlags = FileAccess.WRITE_APPEND if _headers_written else FileAccess.WRITE
    var file := FileAccess.open(log_path, mode)
    if file == null:
        push_error("TelemetryLogger: Unable to open %s" % log_path)
        return
    if include_headers and not _headers_written:
        file.store_line(_headers.join(","))
        _headers_written = true
    var timestamp := Time.get_datetime_string_from_system(true)
    for delta_variant in deltas:
        if not delta_variant is Dictionary:
            continue
        var delta := delta_variant as Dictionary
        var row := [
            timestamp,
            source,
            str(delta.get("meter_id", "")),
            _format_float(delta.get("delta", 0.0)),
            _format_float(delta.get("value", 0.0)),
            str(delta.get("is_critical", false))
        ]
        file.store_line(row.join(","))
    file.close()

func _ensure_directory() -> void:
    var dir_path := log_path.get_base_dir()
    if dir_path == "":
        return
    var dir := DirAccess.open(dir_path)
    if dir == null:
        DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir_path))

func _format_float(value: float) -> String:
    return String.num(value, 2)
