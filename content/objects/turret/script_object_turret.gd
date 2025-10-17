extends Node2D

@export var cooldown: float

var _projectile: PackedScene = preload("res://objects/projectile/scene_object_projectile.tscn")
var _shoot_rotation: float

@onready var sprite: AnimatedSprite2D = $sprite_turret
@onready var timer: Timer = $timer_turret
@onready var shoot_point: Node2D = $node2D_shoot
@onready var back_point: Node2D = $node2D_back

func _ready() -> void:
	if cooldown:
		timer.set_wait_time(cooldown)
	_shoot_rotation = back_point.global_position.angle_to_point(shoot_point.global_position)

func _onAnimationFinished() -> void:
	if sprite.animation == "shoot":
		sprite.play("idle")
		timer.start()

func _onFrameChanged() -> void:
	if not sprite.frame == 3: return
	
	var projectile = _projectile.instantiate()
	get_parent().get_parent().get_node("node_statics").add_child(projectile)
	projectile.global_position = shoot_point.global_position
	projectile.rotation = _shoot_rotation
	projectile.name = "node_projectile_root"

func _onTimeout() -> void:
	sprite.play("shoot")
