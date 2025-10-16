extends CanvasLayer
@onready var label: Label = $CenterContainer/Panel/Label
@onready var panel: Panel = $CenterContainer/Panel

func show_text(msg: String, duration := 1.2) -> void:
	label.text = msg
	visible = true
	panel.modulate.a = 1.0
	var tw := create_tween()
	tw.tween_interval(duration)
	tw.tween_property(panel, "modulate:a", 0.0, 0.5)
	tw.tween_callback(Callable(self, "_on_hide"))

func _on_hide() -> void:
	visible = false
