extends CanvasLayer

@export var default_duration: float = 3.5
@export var max_visible: int = 4
@export var container_path: NodePath = NodePath("ToastContainer")

var _queue: Array[Dictionary] = []
var _active_panels: Array[PanelContainer] = []

func _ready() -> void:
    if not has_node(container_path):
        var container := VBoxContainer.new()
        container.name = "ToastContainer"
        container.anchor_right = 1.0
        container.offset_right = -32.0
        container.anchor_top = 0.0
        container.anchor_bottom = 0.0
        container.grow_horizontal = Control.GROW_DIRECTION_BEGIN
        add_child(container)

func queue_toast(payload: Dictionary) -> void:
    _queue.append(payload)
    _process_queue()

func clear_toasts() -> void:
    for panel in _active_panels:
        if is_instance_valid(panel):
            panel.queue_free()
    _active_panels.clear()
    _queue.clear()

func _process_queue() -> void:
    while _queue.size() > 0 and _active_panels.size() < max_visible:
        var payload_variant := _queue.pop_front()
        var payload := payload_variant if payload_variant is Dictionary else {}
        _spawn_toast(payload)

func _spawn_toast(payload: Dictionary) -> void:
    var container := get_node(container_path) as VBoxContainer
    if container == null:
        return
    var panel := PanelContainer.new()
    panel.name = "ToastPanel"
    panel.custom_minimum_size = Vector2(320, 0)
    panel.modulate = _resolve_color(payload.get("severity", "info"))

    var margin := MarginContainer.new()
    margin.add_theme_constant_override("margin_left", 16)
    margin.add_theme_constant_override("margin_right", 16)
    margin.add_theme_constant_override("margin_top", 12)
    margin.add_theme_constant_override("margin_bottom", 12)
    panel.add_child(margin)

    var vbox := VBoxContainer.new()
    vbox.custom_minimum_size = Vector2(0, 0)
    margin.add_child(vbox)

    var title := Label.new()
    title.text = payload.get("title", payload.get("toast_id", "Notification"))
    title.add_theme_font_size_override("font_size", 18)
    vbox.add_child(title)

    var body_text := String(payload.get("body", ""))
    if body_text != "":
        var body := Label.new()
        body.text = body_text
        body.add_theme_font_size_override("font_size", 14)
        body.autowrap_mode = TextServer.AUTOWRAP_WORD
        vbox.add_child(body)

    container.add_child(panel)
    _active_panels.append(panel)

    var timer := Timer.new()
    timer.one_shot = true
    timer.wait_time = float(payload.get("duration", default_duration))
    timer.connect("timeout", Callable(self, "_on_toast_timeout").bind(panel))
    panel.add_child(timer)
    timer.start()

func _on_toast_timeout(panel: PanelContainer) -> void:
    if is_instance_valid(panel):
        panel.queue_free()
    _active_panels.erase(panel)
    _process_queue()

func _resolve_color(severity: String) -> Color:
    match severity:
        "critical":
            return Color(0.8, 0.2, 0.2, 0.95)
        "warning":
            return Color(0.9, 0.6, 0.2, 0.95)
        _:
            return Color(0.1, 0.7, 0.9, 0.95)
