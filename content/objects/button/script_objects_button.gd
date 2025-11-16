extends Node2D

@export var platform_id: int

@onready var overlap: Area2D = $area2D_overlap
@onready var sprite: AnimatedSprite2D = $anispr_sprite
@export_enum("red", "orange", "yellow", "green", "cyan", "blue", "purple", "violet", "pink", "magenta") var color_name: String = "red"

var active: bool = false

func _ready() -> void:
	var to_color: Color = MasterTracker.COLORS[color_name]
	setColor(to_color)
	for platform in get_tree().get_nodes_in_group("platform"):
		if platform.getPlatformId() == platform_id:
			platform.setColor(to_color)

func _process(_delta: float) -> void:
	if overlap.get_overlapping_bodies():
		playAnimation("press")
		active = true
	else:
		playAnimation("unpress")
		active = false

func playAnimation(to_anim: String) -> void:
	if sprite.animation != to_anim:
		sprite.play(to_anim)

func setColor(to_color: Color) -> void:
	sprite.material = sprite.material.duplicate()
	sprite.material.set("shader_parameter/new_color", to_color)
