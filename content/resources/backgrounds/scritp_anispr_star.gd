extends AnimatedSprite2D

func _ready() -> void:
	set_speed_scale(randf_range(0.6, 1.4))
	frame = randi_range(0, 3)

func _process(delta: float) -> void:
	pass
