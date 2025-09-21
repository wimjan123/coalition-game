extends Node

@export var save_path := "user://demo_session.json"
@export var sample_path := "res://data/saves/demo_session.json"

func save_snapshot(snapshot: Dictionary) -> void:
    snapshot["schema_version"] = snapshot.get("schema_version", 1)
    var content := JSON.stringify(snapshot, "  ")
    var file := FileAccess.open(save_path, FileAccess.WRITE)
    if file == null:
        push_error("SessionSerializer: Unable to open %s for writing" % save_path)
        return
    file.store_string(content)
    file.close()

func load_snapshot() -> Dictionary:
    var path := save_path
    if not FileAccess.file_exists(path):
        path = sample_path
    if not FileAccess.file_exists(path):
        push_warning("SessionSerializer: No snapshot available")
        return {}
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_error("SessionSerializer: Unable to open %s" % path)
        return {}
    var text := file.get_as_text()
    file.close()
    var parsed := JSON.parse_string(text)
    if typeof(parsed) != TYPE_DICTIONARY:
        push_warning("SessionSerializer: Snapshot parse failed")
        return {}
    return parsed

func delete_snapshot() -> void:
    if FileAccess.file_exists(save_path):
        DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
