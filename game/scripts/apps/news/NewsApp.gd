extends Window

signal framing_committed(payload: Dictionary)

@export var headline_list_path: NodePath = NodePath("Content/HeadlineList")
@export var framing_container_path: NodePath = NodePath("Content/FramingOptions")
@export var headline_title_path: NodePath = NodePath("Content/HeadlineTitle")
@export var headline_lead_path: NodePath = NodePath("Content/HeadlineLead")

var _headlines: Array = []
var _current: Dictionary = {}

func _ready() -> void:
    title = tr("News")
    size = Vector2i(580, 520)
    var list := get_node_or_null(headline_list_path)
    if list:
        list.item_selected.connect(Callable(self, "_on_headline_selected"))

func load_headlines(headlines: Array) -> void:
    _headlines = headlines
    _populate_list()

func update_headline(headline: Dictionary) -> void:
    for i in _headlines.size():
        if _headlines[i].get("id") == headline.get("id"):
            _headlines[i] = headline
            break
    _populate_list()

func _populate_list() -> void:
    var list := get_node_or_null(headline_list_path)
    if list == null:
        return
    list.clear()
    for data in _headlines:
        list.add_item(data.get("title", "Headline"))
        list.set_item_metadata(list.get_item_count() - 1, data)
    if list.get_item_count() > 0:
        list.select(0)
        _open_headline(list.get_item_metadata(0))

func _open_headline(headline: Dictionary) -> void:
    _current = headline
    var title_label := get_node_or_null(headline_title_path)
    if title_label:
        title_label.text = headline.get("title", "")
    var lead_label := get_node_or_null(headline_lead_path)
    if lead_label:
        lead_label.text = headline.get("lead", "")
    var container := get_node_or_null(framing_container_path)
    if container:
        for child in container.get_children():
            child.queue_free()
        for option in headline.get("framing_options", []):
            var button := Button.new()
            button.text = option.get("label", "Frame")
            button.connect("pressed", Callable(self, "_on_framing_selected").bind(option))
            container.add_child(button)

func _on_headline_selected(index: int) -> void:
    var list := get_node_or_null(headline_list_path)
    if list == null:
        return
    var headline := list.get_item_metadata(index)
    _open_headline(headline)

func _on_framing_selected(option: Dictionary) -> void:
    emit_signal("framing_committed", {
        "headline_id": _current.get("id"),
        "framing_id": option.get("id"),
        "meter_effects": option.get("meter_effects", {}),
        "headline_variant_key": option.get("headline_variant_key"),
        "social_tag": option.get("social_tag")
    })
