extends Window

signal reply_committed(payload: Dictionary)

@export var thread_list_path: NodePath = NodePath("Content/ThreadList")
@export var reply_container_path: NodePath = NodePath("Content/ReplyContainer")

var _threads: Array = []
var _current_thread: Dictionary = {}
var _contracts: Dictionary = {}

func _ready() -> void:
    title = tr("Messages")
    size = Vector2i(520, 640)
    var list := get_node_or_null(thread_list_path)
    if list:
        list.item_selected.connect(Callable(self, "_on_thread_selected"))

func load_contract(contract: Dictionary) -> void:
    _contracts = contract
    _threads = contract.get("threads", [])
    _populate_thread_list()

func present_threads(threads: Array) -> void:
    _threads = threads
    _populate_thread_list()

func apply_meter_snapshot(_snapshot: Dictionary) -> void:
    # Placeholder for hooking meter state to message emphasis.
    pass

func _populate_thread_list() -> void:
    var list := get_node_or_null(thread_list_path)
    if list == null:
        return
    list.clear()
    for thread in _threads:
        list.add_item(thread.get("title", "Thread"))
        list.set_item_metadata(list.get_item_count() - 1, thread)
    if list.get_item_count() > 0:
        list.select(0)
        _open_thread(list.get_item_metadata(0))

func _open_thread(thread_data: Dictionary) -> void:
    _current_thread = thread_data
    var replies := thread_data.get("replies", [])
    var container := get_node_or_null(reply_container_path)
    if container == null:
        return
    for child in container.get_children():
        child.queue_free()
    for reply in replies:
        var button := Button.new()
        button.text = reply.get("label", "Respond")
        button.connect("pressed", Callable(self, "_on_reply_pressed").bind(reply))
        container.add_child(button)

func _on_thread_selected(index: int) -> void:
    var list := get_node_or_null(thread_list_path)
    if list == null:
        return
    var thread_data: Dictionary = list.get_item_metadata(index)
    _open_thread(thread_data)

func _on_reply_pressed(reply: Dictionary) -> void:
    emit_signal("reply_committed", {
        "reply_id": reply.get("id"),
        "tag": reply.get("tag"),
        "meter_effects": reply.get("meter_effects", {}),
        "persona_bias": reply.get("persona_bias", {})
    })
