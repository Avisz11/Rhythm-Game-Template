extends Control

func _ready() -> void:
	pass

func set_label(_text : String, _color : Color) -> void:
	$Label.text = _text
	$Label.self_modulate = _color

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
