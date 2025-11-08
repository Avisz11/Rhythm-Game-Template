extends Sprite2D

@export var speed = 350.0

func _physics_process(delta: float) -> void:
	position.y += speed * delta
