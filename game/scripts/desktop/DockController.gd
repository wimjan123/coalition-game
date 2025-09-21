extends Control

signal app_toggled(window_id: String)

@export var app_container_path: NodePath = NodePath("AppContainer")

var _app_buttons: Dictionary = {}

func register_app(window_id: String, metadata: Dictionary = {}) -> void:
    if _app_buttons.has(window_id):
        return
    var container := get_node_or_null(app_container_path) as Control
    if container == null:
        push_warning("DockController: App container missing for %s" % window_id)
        return
    var button := Button.new()
    button.name = StringName(window_id)
    button.text = String(metadata.get("display_name", window_id.capitalize()))
    button.toggle_mode = true
    button.pressed = metadata.get("start_open", false)
    button.connect("pressed", Callable(self, "_on_button_pressed").bind(window_id))
    container.add_child(button)
    _app_buttons[window_id] = button

func set_window_state(window_id: String, is_open: bool) -> void:
    var button := _app_buttons.get(window_id, null)
    if button is Button:
        (button as Button).set_pressed_no_signal(is_open)

func _ready() -> void:
    if not has_node(app_container_path):
        push_warning("DockController: Missing app container")

func _on_button_pressed(window_id: String) -> void:
    emit_signal("app_toggled", window_id)
