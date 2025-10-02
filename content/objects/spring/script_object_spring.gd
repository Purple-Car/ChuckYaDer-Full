extends Node2D

@export var strength: int

var is_horizontal: bool = false

@onready var sprite: AnimatedSprite2D = $sprite_spring

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if rotation_degrees == 90:
		is_horizontal = true
	elif rotation_degrees == 270:
		strength = -strength
		is_horizontal = true
	elif rotation_degrees == 180:
		strength = -strength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _onAreaEntered(area: Area2D) -> void:
	area.get_parent().giveImpulse(strength, is_horizontal)
	sprite.frame = 0
	sprite.play("boing")
