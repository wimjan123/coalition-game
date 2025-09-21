extends Window

signal offer_committed(payload: Dictionary)

@export var offer_container_path: NodePath = NodePath("Content/OfferContainer")
@export var summary_path: NodePath = NodePath("Content/Summary")

var _offers: Array = []
var _context: Dictionary = {}

func _ready() -> void:
    title = tr("Coalition Talks")
    size = Vector2i(420, 360)

func load_context(context: Dictionary, offers: Array) -> void:
    _context = context
    _offers = offers
    _render_offers()

func _render_offers() -> void:
    var container := get_node_or_null(offer_container_path)
    if container == null:
        return
    for child in container.get_children():
        child.queue_free()
    for offer in _offers:
        var button := Button.new()
        button.text = offer.get("label", "Offer")
        button.connect("pressed", Callable(self, "_on_offer_selected").bind(offer))
        container.add_child(button)
    var summary := get_node_or_null(summary_path)
    if summary:
        summary.text = _context.get("summary", "Select a concession to keep negotiations moving.")

func _on_offer_selected(offer: Dictionary) -> void:
    emit_signal("offer_committed", {
        "offer_id": offer.get("id"),
        "meter_effects": offer.get("meter_effects", {}),
        "tag": offer.get("tag"),
        "toast_template_id": offer.get("toast_template_id")
    })
