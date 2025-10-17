extends Node2D

@export var strength: int

@onready var sprite: AnimatedSprite2D = $sprite_spring

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _onAreaEntered(area: Area2D) -> void:
	#var impulse_vector: Vector2 = Vector2.RIGHT.rotated(rotation) * strength
	area.get_parent().setImpulse(Vector2.UP.rotated(rotation) * strength)
	sprite.frame = 0
	sprite.play("boing")
