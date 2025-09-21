extends Window

signal reply_committed(payload: Dictionary)

@export var thread_list_path: NodePath = NodePath("Content/ThreadList")
@export var reply_container_path: NodePath = NodePath("Content/ReplyContainer")

var _threads: Array[Dictionary] = []
var _current_thread: Dictionary = {}
var _contracts: Dictionary = {}

func _ready() -> void:
    title = tr("Messages")
    size = Vector2i(520, 640)
    var list_node := get_node_or_null(thread_list_path)
    if list_node is ItemList:
        (list_node as ItemList).item_selected.connect(Callable(self, "_on_thread_selected"))

func load_contract(contract: Dictionary) -> void:
    _contracts = contract
    _threads = []
    for entry in contract.get("threads", []):
        if entry is Dictionary:
            _threads.append(entry)
    _populate_thread_list()

func present_threads(threads: Array) -> void:
    _threads = []
    for entry in threads:
        if entry is Dictionary:
            _threads.append(entry)
    _populate_thread_list()

func apply_meter_snapshot(_snapshot: Dictionary) -> void:
    # Placeholder for hooking meter state to message emphasis.
    pass

func _populate_thread_list() -> void:
    var list_node := get_node_or_null(thread_list_path)
    if list_node == null or not (list_node is ItemList):
        return
    var list := list_node as ItemList
    list.clear()
    for thread_entry in _threads:
        var title := String(thread_entry.get("title", "Thread"))
        list.add_item(title)
        list.set_item_metadata(list.get_item_count() - 1, thread_entry)
    if list.get_item_count() > 0:
        list.select(0)
        var metadata := list.get_item_metadata(0)
        if metadata is Dictionary:
            _open_thread(metadata)

func _open_thread(thread_data: Dictionary) -> void:
    _current_thread = thread_data
    var replies: Array = thread_data.get("replies", [])
    var container_node := get_node_or_null(reply_container_path)
    if container_node == null or not (container_node is VBoxContainer):
        return
    var container := container_node as VBoxContainer
    for child in container.get_children():
        child.queue_free()
    for reply_entry in replies:
        if not reply_entry is Dictionary:
            continue
        var reply_dict: Dictionary = reply_entry
        var button := Button.new()
        button.text = String(reply_dict.get("label", "Respond"))
        button.connect("pressed", Callable(self, "_on_reply_pressed").bind(reply_dict))
        container.add_child(button)

func _on_thread_selected(index: int) -> void:
    var list_node := get_node_or_null(thread_list_path)
    if list_node == null or not (list_node is ItemList):
        return
    var list := list_node as ItemList
    var metadata := list.get_item_metadata(index)
    if metadata is Dictionary:
        _open_thread(metadata)

func _on_reply_pressed(reply: Dictionary) -> void:
    emit_signal("reply_committed", {
        "reply_id": reply.get("id"),
        "tag": reply.get("tag"),
        "meter_effects": reply.get("meter_effects", {}),
        "persona_bias": reply.get("persona_bias", {})
    })
