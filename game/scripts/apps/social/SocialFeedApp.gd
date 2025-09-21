extends Window

signal post_committed(payload: Dictionary)

@export var tag_option_path: NodePath = NodePath("Content/Composer/TagOptions")
@export var body_input_path: NodePath = NodePath("Content/Composer/Body")
@export var remaining_label_path: NodePath = NodePath("Content/Composer/RemainingLabel")
@export var feed_list_path: NodePath = NodePath("Content/FeedList")

var _tag_configs: Array[Dictionary] = []
var _remaining_posts := 1

func _ready() -> void:
    title = tr("Social")
    size = Vector2i(480, 600)
    var send_button := get_node_or_null(NodePath("Content/Composer/SendButton"))
    if send_button is Button:
        (send_button as Button).pressed.connect(Callable(self, "_on_send_pressed"))

func set_tags(tags: Array, remaining_posts: int = 1) -> void:
    var configs: Array[Dictionary] = []
    for tag_variant in tags:
        var tag_string := String(tag_variant)
        configs.append({"tag": tag_string})
    configure_posts(configs, remaining_posts)

func configure_posts(configs: Array, remaining_posts: int = 1) -> void:
    _tag_configs = []
    for config in configs:
        if config is Dictionary:
            _tag_configs.append(config)
    _remaining_posts = remaining_posts
    _populate_tags()
    _update_remaining_label()

func append_feed(entries: Array) -> void:
    var list_node := get_node_or_null(feed_list_path)
    if list_node == null or not (list_node is ItemList):
        return
    var list := list_node as ItemList
    for entry in entries:
        if not entry is Dictionary:
            continue
        var entry_dict: Dictionary = entry
        var prefix := String(entry_dict.get("persona", ""))
        var text := String(entry_dict.get("text", ""))
        list.add_item("%s: %s" % [prefix, text])
    list.ensure_current_is_visible()

func reset_composer() -> void:
    var body_node := get_node_or_null(body_input_path)
    if body_node is TextEdit:
        (body_node as TextEdit).text = ""

func _populate_tags() -> void:
    var option_node := get_node_or_null(tag_option_path)
    if option_node == null or not (option_node is OptionButton):
        return
    var option_button := option_node as OptionButton
    option_button.clear()
    for config in _tag_configs:
        var tag := String(config.get("tag", ""))
        option_button.add_item(tag)
    if option_button.item_count > 0:
        option_button.select(0)

func _update_remaining_label() -> void:
    var label := get_node_or_null(remaining_label_path)
    if label is Label:
        (label as Label).text = "Posts remaining: %d" % _remaining_posts

func _on_send_pressed() -> void:
    if _remaining_posts <= 0:
        push_warning("Social composer locked; no posts remaining.")
        return
    var option_node := get_node_or_null(tag_option_path)
    var body_node := get_node_or_null(body_input_path)
    if option_node == null or body_node == null or not (option_node is OptionButton) or not (body_node is TextEdit):
        return
    var option_button := option_node as OptionButton
    var body := body_node as TextEdit
    var selected_tag := option_button.get_item_text(option_button.get_selected())
    var config := _tag_config_for_tag(selected_tag)
    emit_signal("post_committed", {
        "tag": selected_tag,
        "body": body.text,
        "meter_effects": config.get("meter_effects", {}),
        "persona_replies": config.get("persona_replies", [])
    })
    _remaining_posts -= 1
    _update_remaining_label()
    reset_composer()

func _tag_config_for_tag(tag: String) -> Dictionary:
    for config in _tag_configs:
        if config.get("tag") == tag:
            return config
    return {}
