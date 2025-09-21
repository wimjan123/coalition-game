extends Window

@export var meter_container_path: NodePath = NodePath("Content/MeterList")
@export var commentary_path: NodePath = NodePath("Content/Commentary")

var _meters: Array = []
var _commentary: Array = []

func _ready() -> void:
    title = tr("Polling")
    size = Vector2i(420, 560)

func apply_snapshot(meters: Array, commentary: Array = []) -> void:
    _meters = meters
    _commentary = commentary
    _render_meters()
    _render_commentary()

func _render_meters() -> void:
    var container := get_node_or_null(meter_container_path)
    if container == null:
        return
    for child in container.get_children():
        child.queue_free()
    for meter in _meters:
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
    var list := get_node_or_null(commentary_path)
    if list == null:
        return
    list.clear()
    for line in _commentary:
        list.add_item(line.get("body", ""))
