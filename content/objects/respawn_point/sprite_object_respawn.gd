extends Node2D

@export var player_num: int
@export var facing_right: bool
@export var respawn_timer: float = 0.75

@onready var debug_polygon: Polygon2D = $polygon_object_view
@onready var animated_sprite: AnimatedSprite2D = $anisprite_respawn_point
@onready var timer: Timer = $timer_respawn

var _player_scene: PackedScene = preload("res://objects/player/scene_player_body.tscn")
var player_node_name: String
var assigned_player: CharacterBody2D = null
var ghostable: bool = false

signal onRespawnStart

func _ready() -> void:
	if player_num == 0:
		push_warning("player not set in a player spawner")
		
	if facing_right:
		animated_sprite.scale.x = -1

	animated_sprite.material = animated_sprite.material.duplicate()
	animated_sprite.material.set("shader_parameter/new_color", MasterTracker.player_colors[player_num - 1])
	
	player_node_name = "charbody_player_" + str(player_num)
	debug_polygon.hide()

func _process(delta: float) -> void:
	pass

func _onAnimationFinished() -> void:
	var player: Player = _player_scene.instantiate()
	get_parent().get_parent().get_node("node_grabbables").add_child(player)
	player.position = position
	player.player_num = player_num
	player.name = player_node_name
	player.updateColor()
	
	if facing_right:
		player.is_flipped = true
		player._updateScaleDirection()
	
	if ghostable:
		player.ghostable = true
	
	assigned_player = player
	player.onPlayerDestroyed.connect(_onPlayerDestroyed)
	
	animated_sprite.frame = 0

func _onPlayerDestroyed() -> void:
	if assigned_player and assigned_player.tree_exited.is_connected(_onPlayerDestroyed):
		assigned_player.tree_exited.disconnect(_onPlayerDestroyed)
	
	assigned_player = null
	
	if respawn_timer <= 0: return
	timer.start(respawn_timer)

func _onTimerTimeout() -> void:
	onRespawnStart.emit(player_num)
	animated_sprite.play("respawn")
