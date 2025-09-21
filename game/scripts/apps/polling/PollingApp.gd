extends Window

@export var meter_container_path: NodePath = NodePath("Content/MeterList")
@export var commentary_path: NodePath = NodePath("Content/Commentary")

var _meters: Array[Dictionary] = []
var _commentary: Array[Dictionary] = []

func _ready() -> void:
    title = tr("Polling")
    size = Vector2i(420, 560)

func apply_snapshot(meters: Array, commentary: Array = []) -> void:
    _meters = []
    for entry in meters:
        if entry is Dictionary:
            _meters.append(entry)
    _commentary = []
    for entry in commentary:
        if entry is Dictionary:
            _commentary.append(entry)
    _render_meters()
    _render_commentary()

func _render_meters() -> void:
    var container_node := get_node_or_null(meter_container_path)
    if container_node == null or not (container_node is VBoxContainer):
        return
    var container := container_node as VBoxContainer
    for child in container.get_children():
        child.queue_free()
    for meter_entry in _meters:
        var meter := meter_entry
        var hb := HBoxContainer.new()
        hb.custom_minimum_size = Vector2(0, 32)
        var name_label := Label.new()
        name_label.text = meter.get("display_name", meter.get("id", "Meter"))
        name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        hb.add_child(name_label)
        var value_label := Label.new()
        value_label.text = str(round(meter.get("value", 0))) + "%"
        value_label.add_theme_font_size_override("font_size", 18)
        hb.add_child(value_label)
        container.add_child(hb)

func _render_commentary() -> void:
    var list_node := get_node_or_null(commentary_path)
    if list_node == null or not (list_node is ItemList):
        return
    var list := list_node as ItemList
    list.clear()
    for line in _commentary:
        list.add_item(String(line.get("body", "")))
