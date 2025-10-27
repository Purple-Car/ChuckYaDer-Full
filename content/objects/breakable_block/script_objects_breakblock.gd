extends StaticBody2D

@export var texture: Texture2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _onAreaEntered(area: Area2D) -> void:
	Utils.explode_texture(texture, global_position + Vector2(8, 8))
	queue_free()
