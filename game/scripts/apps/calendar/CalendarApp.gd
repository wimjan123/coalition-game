extends Window

signal week_advanced(new_week: int)
signal event_opened(event_id: String)

@export var week_label_path: NodePath = NodePath("Content/Header/WeekLabel")
@export var event_list_path: NodePath = NodePath("Content/EventList")
@export var detail_title_path: NodePath = NodePath("Content/EventDetail/Title")
@export var detail_body_path: NodePath = NodePath("Content/EventDetail/Body")

var _current_week: int = 0
var _events: Array[Dictionary] = []
var _events_by_id: Dictionary = {}

func _ready() -> void:
    title = tr("Calendar")
    size = Vector2i(420, 500)
    var list := get_node_or_null(event_list_path)
    if list is ItemList:
        (list as ItemList).item_selected.connect(Callable(self, "_on_event_selected"))
    var advance_button_node := get_node_or_null(NodePath("Content/Header/AdvanceButton"))
    if advance_button_node is Button:
        (advance_button_node as Button).pressed.connect(Callable(self, "advance_week"))

func set_timeline(current_week: int, events: Array) -> void:
    _current_week = current_week
    _events = []
    for event_data in events:
        if event_data is Dictionary:
            _events.append(event_data)
    _events_by_id.clear()
    for event_entry in _events:
        var event_id := String(event_entry.get("id", ""))
        if event_id != "":
            _events_by_id[event_id] = event_entry
    _refresh()

func advance_week() -> void:
    _current_week += 1
    emit_signal("week_advanced", _current_week)
    _refresh()

func _refresh() -> void:
    _update_week_label()
    _populate_event_list()

func _update_week_label() -> void:
    var label := get_node_or_null(week_label_path)
    if label is Label:
        (label as Label).text = "Week %d" % (_current_week + 1)

func _populate_event_list() -> void:
    var list_node := get_node_or_null(event_list_path)
    if list_node == null or not (list_node is ItemList):
        return
    var list := list_node as ItemList
    list.clear()
    for event_entry in _events:
        var title := "%s – Week %d" % [event_entry.get("title", event_entry.get("id")), int(event_entry.get("week", 0)) + 1]
        list.add_item(title)
        list.set_item_metadata(list.get_item_count() - 1, event_entry)
    if list.get_item_count() > 0:
        list.select(0)
        var metadata := list.get_item_metadata(0)
        if metadata is Dictionary:
            _open_event(metadata)

func _open_event(event: Dictionary) -> void:
    var title_label := get_node_or_null(detail_title_path)
    if title_label is Label:
        (title_label as Label).text = event.get("title", "")
    var body_label := get_node_or_null(detail_body_path)
    if body_label is Label:
        (body_label as Label).text = event.get("consequence", "")
    emit_signal("event_opened", event.get("id"))

func _on_event_selected(index: int) -> void:
    var list_node := get_node_or_null(event_list_path)
    if list_node == null or not (list_node is ItemList):
        return
    var list := list_node as ItemList
    var metadata := list.get_item_metadata(index)
    if metadata is Dictionary:
        _open_event(metadata)
