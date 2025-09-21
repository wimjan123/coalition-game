extends Window

signal framing_committed(payload: Dictionary)

@export var headline_list_path: NodePath = NodePath("Content/HeadlineList")
@export var framing_container_path: NodePath = NodePath("Content/FramingOptions")
@export var headline_title_path: NodePath = NodePath("Content/HeadlineTitle")
@export var headline_lead_path: NodePath = NodePath("Content/HeadlineLead")

var _headlines: Array[Dictionary] = []
var _current: Dictionary = {}

func _ready() -> void:
    title = tr("News")
    size = Vector2i(580, 520)
    var list_node := get_node_or_null(headline_list_path)
    if list_node is ItemList:
        (list_node as ItemList).item_selected.connect(Callable(self, "_on_headline_selected"))

func load_headlines(headlines: Array) -> void:
    _headlines = []
    for entry in headlines:
        if entry is Dictionary:
            _headlines.append(entry)
    _populate_list()

func update_headline(headline: Dictionary) -> void:
    for i in _headlines.size():
        if _headlines[i].get("id") == headline.get("id"):
            _headlines[i] = headline
            break
    _populate_list()

func _populate_list() -> void:
    var list_node := get_node_or_null(headline_list_path)
    if list_node == null or not (list_node is ItemList):
        return
    var list := list_node as ItemList
    list.clear()
    for data in _headlines:
        var title := String(data.get("title", "Headline"))
        list.add_item(title)
        list.set_item_metadata(list.get_item_count() - 1, data)
    if list.get_item_count() > 0:
        list.select(0)
        var metadata := list.get_item_metadata(0)
        if metadata is Dictionary:
            _open_headline(metadata)

func _open_headline(headline: Dictionary) -> void:
    _current = headline
    var title_label := get_node_or_null(headline_title_path)
    if title_label is Label:
        (title_label as Label).text = headline.get("title", "")
    var lead_label := get_node_or_null(headline_lead_path)
    if lead_label is Label:
        (lead_label as Label).text = headline.get("lead", "")
    var container_node := get_node_or_null(framing_container_path)
    if container_node is VBoxContainer:
        var container := container_node as VBoxContainer
        for child in container.get_children():
            child.queue_free()
        for option_entry in headline.get("framing_options", []):
            if not option_entry is Dictionary:
                continue
            var option := option_entry as Dictionary
            var button := Button.new()
            button.text = String(option.get("label", "Frame"))
            button.connect("pressed", Callable(self, "_on_framing_selected").bind(option))
            container.add_child(button)

func _on_headline_selected(index: int) -> void:
    var list_node := get_node_or_null(headline_list_path)
    if list_node == null or not (list_node is ItemList):
        return
    var list := list_node as ItemList
    var metadata := list.get_item_metadata(index)
    if metadata is Dictionary:
        _open_headline(metadata)

func _on_framing_selected(option: Dictionary) -> void:
    emit_signal("framing_committed", {
        "headline_id": _current.get("id"),
        "framing_id": option.get("id"),
        "meter_effects": option.get("meter_effects", {}),
        "headline_variant_key": option.get("headline_variant_key"),
        "social_tag": option.get("social_tag")
    })
