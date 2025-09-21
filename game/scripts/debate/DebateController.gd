extends Node3D

signal answer_committed(payload: Dictionary)
signal debate_timeout(question_id: String)

@export var prompt_label_path: NodePath = NodePath("UI/Prompt")
@export var timer_label_path: NodePath = NodePath("UI/TimerLabel")
@export var answer_container_path: NodePath = NodePath("UI/Answers")
@export var timer_node_path: NodePath = NodePath("Timer")
@export var base_theme_path: Resource = preload("res://ui/themes/DemoDesktopTheme.tres")
@export var debate_theme_path: Resource = preload("res://ui/themes/DebateTheme.tres")

var _question: Dictionary = {}
var _remaining := 0.0

func _ready() -> void:
    var timer := get_node_or_null(timer_node_path)
    if timer:
        timer.timeout.connect(Callable(self, "_on_timer_timeout"))
    _apply_theme()

func load_question(question: Dictionary) -> void:
    _question = question
    _remaining = question.get("timer_seconds", 25)
    _update_prompt()
    _populate_answers()
    _update_timer_label()

func start_timer() -> void:
    var timer := get_node_or_null(timer_node_path)
    if timer == null:
        return
    timer.stop()
    timer.wait_time = float(_question.get("timer_seconds", 25))
    timer.start()

func _process(delta: float) -> void:
    if _remaining <= 0:
        return
    _remaining = max(_remaining - delta, 0)
    _update_timer_label()

func _update_prompt() -> void:
    var label := get_node_or_null(prompt_label_path)
    if label:
        label.text = _question.get("prompt", "")

func _populate_answers() -> void:
    var container := get_node_or_null(answer_container_path)
    if container == null:
        return
    for child in container.get_children():
        child.queue_free()
    for option in _question.get("answers", []):
        var button := Button.new()
        button.text = option.get("label", option.get("tone", "Answer"))
        button.connect("pressed", Callable(self, "_on_answer_pressed").bind(option))
        container.add_child(button)

func _update_timer_label() -> void:
    var label := get_node_or_null(timer_label_path)
    if label:
        label.text = "%02d" % int(ceil(_remaining))

func _on_answer_pressed(option: Dictionary) -> void:
    emit_signal("answer_committed", {
        "tone": option.get("tone"),
        "meter_effects": option.get("meter_effects", {}),
        "headline_id": _question.get("follow_up_headline_id"),
        "tag": _question.get("social_tag"),
        "toast_template_id": option.get("toast_template_id")
    })
    _remaining = 0
    _update_timer_label()
    var timer := get_node_or_null(timer_node_path)
    if timer:
        timer.stop()

func _on_timer_timeout() -> void:
    _remaining = 0
    _update_timer_label()
    emit_signal("debate_timeout", _question.get("id", ""))

func _apply_theme() -> void:
    var base_theme: Theme = base_theme_path
    var variant: Theme = debate_theme_path
    if base_theme == null:
        return
    var merged := base_theme.duplicate()
    if variant:
        merged.merge_with(variant)
    var panel := get_node_or_null(NodePath("UI/Panel"))
    if panel:
        panel.theme = merged
