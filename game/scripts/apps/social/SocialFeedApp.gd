extends Window

signal post_committed(payload: Dictionary)

@export var tag_option_path: NodePath = NodePath("Content/Composer/TagOptions")
@export var body_input_path: NodePath = NodePath("Content/Composer/Body")
@export var remaining_label_path: NodePath = NodePath("Content/Composer/RemainingLabel")
@export var feed_list_path: NodePath = NodePath("Content/FeedList")

var _tag_configs: Array = []
var _remaining_posts := 1

func _ready() -> void:
    title = tr("Social")
    size = Vector2i(480, 600)
    var send_button := get_node_or_null(NodePath("Content/Composer/SendButton"))
    if send_button:
        send_button.pressed.connect(Callable(self, "_on_send_pressed"))

func set_tags(tags: Array, remaining_posts: int = 1) -> void:
    var configs: Array = []
    for tag in tags:
        configs.append({"tag": tag})
    configure_posts(configs, remaining_posts)

func configure_posts(configs: Array, remaining_posts: int = 1) -> void:
    _tag_configs = configs
    _remaining_posts = remaining_posts
    _populate_tags()
    _update_remaining_label()

func append_feed(entries: Array) -> void:
    var list := get_node_or_null(feed_list_path)
    if list == null:
        return
    for entry in entries:
        var prefix := entry.get("persona", "")
        var text := entry.get("text", "")
        list.add_item("%s: %s" % [prefix, text])
    list.ensure_current_is_visible()

func reset_composer() -> void:
    var body := get_node_or_null(body_input_path)
    if body:
        body.text = ""

func _populate_tags() -> void:
    var option_button := get_node_or_null(tag_option_path)
    if option_button == null:
        return
    option_button.clear()
    for config in _tag_configs:
        option_button.add_item(config.get("tag", ""))
    if option_button.item_count > 0:
        option_button.select(0)

func _update_remaining_label() -> void:
    var label := get_node_or_null(remaining_label_path)
    if label:
        label.text = "Posts remaining: %d" % _remaining_posts

func _on_send_pressed() -> void:
    if _remaining_posts <= 0:
        push_warning("Social composer locked; no posts remaining.")
        return
    var option_button := get_node_or_null(tag_option_path)
    var body := get_node_or_null(body_input_path)
    if option_button == null or body == null:
        return
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
