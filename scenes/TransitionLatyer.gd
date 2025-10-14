extends CanvasLayer

@onready var fade_rect = $FadeRect

func _ready():
	# Fade in automatically when scene starts
	fade_in()

func fade_in():
	fade_rect.modulate.a = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.0)  # Fade to transparent over 1 second

func fade_out_and_change_scene(new_scene_path: String):
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)  # Fade to black
	tween.tween_callback(Callable(self, "_on_fade_complete"), new_scene_path)

func _on_fade_complete(new_scene_path: String):
	get_tree().change_scene_to_file(new_scene_path)
