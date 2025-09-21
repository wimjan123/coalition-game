extends Window

signal week_advanced(new_week: int)
signal event_opened(event_id: String)

@export var week_label_path: NodePath = NodePath("Content/Header/WeekLabel")
@export var event_list_path: NodePath = NodePath("Content/EventList")
@export var detail_title_path: NodePath = NodePath("Content/EventDetail/Title")
@export var detail_body_path: NodePath = NodePath("Content/EventDetail/Body")

var _current_week := 0
var _events: Array = []
var _events_by_id: Dictionary = {}

func _ready() -> void:
    title = tr("Calendar")
    size = Vector2i(420, 500)
    var list := get_node_or_null(event_list_path)
    if list:
        list.item_selected.connect(Callable(self, "_on_event_selected"))
    var advance_button := get_node_or_null(NodePath("Content/Header/AdvanceButton"))
    if advance_button:
        advance_button.pressed.connect(Callable(self, "advance_week"))

func set_timeline(current_week: int, events: Array) -> void:
    _current_week = current_week
    _events = events
    _events_by_id.clear()
    for event in events:
        _events_by_id[event.get("id")] = event
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
    if label:
        label.text = "Week %d" % (_current_week + 1)

func _populate_event_list() -> void:
    var list := get_node_or_null(event_list_path)
    if list == null:
        return
    list.clear()
    for event in _events:
        var title := "%s – Week %d" % [event.get("title", event.get("id")), event.get("week", 0) + 1]
        list.add_item(title)
        list.set_item_metadata(list.get_item_count() - 1, event)
    if list.get_item_count() > 0:
        list.select(0)
        _open_event(list.get_item_metadata(0))

func _open_event(event: Dictionary) -> void:
    var title_label := get_node_or_null(detail_title_path)
    if title_label:
        title_label.text = event.get("title", "")
    var body_label := get_node_or_null(detail_body_path)
    if body_label:
        body_label.text = event.get("consequence", "")
    emit_signal("event_opened", event.get("id"))

func _on_event_selected(index: int) -> void:
    var list := get_node_or_null(event_list_path)
    if list == null:
        return
    var event := list.get_item_metadata(index)
    _open_event(event)
