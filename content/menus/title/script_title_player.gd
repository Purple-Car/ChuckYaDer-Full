extends AnimatedSprite2D

@export var player: int

func _ready() -> void:
	frame = randi_range(0,5)
	material = material.duplicate()
	material.set("shader_parameter/new_color", MasterTracker.player_colors[player])
