extends Node2D

@export var player_num: int
@export var facing_right: bool

@onready var debug_polygon: Polygon2D = $polygon_object_view
@onready var animated_sprite: AnimatedSprite2D = $anisprite_respawn_point

var _player_scene: PackedScene = preload("res://objects/player/scene_player_body.tscn")
var player_node_name: String
var assigned_player: CharacterBody2D = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player_num == 0:
		push_warning("player not set in a player spawner")
		
	if facing_right:
		animated_sprite.scale.x = -1
	
	player_node_name = "charbody_player_" + str(player_num)
	debug_polygon.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _onAnimationFinished() -> void:
	var player = _player_scene.instantiate()
	get_parent().get_parent().get_node("node_grabbables").add_child(player)
	player.position = position
	player.player_num = player_num
	player.name = player_node_name
	
	if facing_right:
		player.is_flipped = true
		player._updateScaleDirection()
	
	assigned_player = player
	player.onPlayerDestroyed.connect(_onPlayerDestroyed)
	
	await get_tree().create_timer(0.02).timeout
	animated_sprite.frame = 0

func _onPlayerDestroyed() -> void:
	# Disconnect the signal to avoid multiple connections
	if assigned_player and assigned_player.tree_exited.is_connected(_onPlayerDestroyed):
		assigned_player.tree_exited.disconnect(_onPlayerDestroyed)
	
	assigned_player = null
	
	animated_sprite.play("respawn")
