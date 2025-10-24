extends Node2D

@export var strength: int

@onready var sprite: AnimatedSprite2D = $sprite_spring

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _onAreaEntered(area: Area2D) -> void:
	#var impulse_vector: Vector2 = Vector2.RIGHT.rotated(rotation) * strength
	if area.get_parent().is_ancestor_of(self): return
	area.get_parent().setImpulse(Vector2.UP.rotated(rotation) * strength)
	sprite.frame = 0
	sprite.play("boing")
