extends Window

signal offer_committed(payload: Dictionary)

@export var offer_container_path: NodePath = NodePath("Content/OfferContainer")
@export var summary_path: NodePath = NodePath("Content/Summary")

var _offers: Array[Dictionary] = []
var _context: Dictionary = {}

func _ready() -> void:
    title = tr("Coalition Talks")
    size = Vector2i(420, 360)

func load_context(context: Dictionary, offers: Array) -> void:
    _context = context
    _offers = []
    for offer in offers:
        if offer is Dictionary:
            _offers.append(offer)
    _render_offers()

func _render_offers() -> void:
    var container_node := get_node_or_null(offer_container_path)
    if container_node == null or not (container_node is VBoxContainer):
        return
    var container := container_node as VBoxContainer
    for child in container.get_children():
        child.queue_free()
    for offer_dict in _offers:
        var button := Button.new()
        button.text = String(offer_dict.get("label", "Offer"))
        button.connect("pressed", Callable(self, "_on_offer_selected").bind(offer_dict))
        container.add_child(button)
    var summary_node := get_node_or_null(summary_path)
    if summary_node is Label:
        (summary_node as Label).text = _context.get("summary", "Select a concession to keep negotiations moving.")

func _on_offer_selected(offer: Dictionary) -> void:
    emit_signal("offer_committed", {
        "offer_id": offer.get("id"),
        "meter_effects": offer.get("meter_effects", {}),
        "tag": offer.get("tag"),
        "toast_template_id": offer.get("toast_template_id")
    })
