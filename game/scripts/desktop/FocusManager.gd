extends Node

@export var dock_path: NodePath = NodePath("../DockAnchor/Dock")

var _dock: Control = null
var _windows: Array[Control] = []
var _window_ids: Dictionary = {}

func _ready() -> void:
    var dock_node := get_node_or_null(dock_path)
    if dock_node is Control:
        _dock = dock_node as Control
        if _dock.focus_mode == Control.FOCUS_NONE:
            _dock.focus_mode = Control.FOCUS_ALL

func register_window(window_id: String, control: Control) -> void:
    if control == null:
        return
    if control.focus_mode != Control.FOCUS_ALL:
        control.focus_mode = Control.FOCUS_ALL
    if control not in _windows:
        _windows.append(control)
    _window_ids[window_id] = control
    _update_focus_chain()

func unregister_window(window_id: String) -> void:
    var control := _window_ids.get(window_id, null)
    if control and control in _windows:
        _windows.erase(control)
    _window_ids.erase(window_id)
    _update_focus_chain()

func _update_focus_chain() -> void:
    if _dock == null:
        return
    var prev: Control = _dock
    for window in _windows:
        if window == null:
            continue
        prev.focus_next = window.get_path()
        window.focus_previous = prev.get_path()
        prev = window
    prev.focus_next = _dock.get_path()
    _dock.focus_previous = prev.get_path()
