extends Node2D

const IMAGE_WIDTH: int = 10
const OFFSET: Vector2 = Vector2(0, 2)

var players: Array[CharacterBody2D] = []
var rope_length: int = 64
var spring_strength: float = 0.8

@onready var scarf_p1: Sprite2D = $spr_player1
@onready var scarf_p2: Sprite2D = $spr_player2
@onready var knot: Sprite2D = $spr_knot

func _ready() -> void:
	show()
	material.set("shader_parameter/new_color_1", MasterTracker.player_colors[0])
	material.set("shader_parameter/new_color_2", MasterTracker.player_colors[1])

func _process(delta: float) -> void:
	_handleVisuals()
	_handlePhysics()

func setupScarf(player01: CharacterBody2D, player02: CharacterBody2D, length: int, strength: float) -> void:
	players = [player01, player02]
	for player in players:
		player.onPlayerDestroyed.connect(_onPlayerDestroyed)
	rope_length = length
	spring_strength = strength

func _onPlayerDestroyed() -> void:
	queue_free()

func _handleVisuals() -> void:
	if players.size() < 2: return
	if !is_instance_valid(players[0]) or !is_instance_valid(players[1]): return
	
	var pos1 = players[0].global_position + OFFSET
	var pos2 = players[1].global_position + OFFSET
	var mid = (pos1 + pos2) / 2.0
	
	position = Vector2.ZERO
	var delta_pos = pos2 - pos1
	var distance = delta_pos.length()
	var angle = delta_pos.angle()
	
	scarf_p1.global_position = pos1.lerp(mid, 0.5)
	scarf_p2.global_position = pos2.lerp(mid, 0.5)
	
	knot.global_position = mid
	knot.rotation = angle

	scarf_p1.rotation = angle
	scarf_p2.rotation = angle + PI

	scarf_p1.scale.x = distance / IMAGE_WIDTH / 2
	scarf_p2.scale.x = distance / IMAGE_WIDTH / 2

func _handlePhysics() -> void:
	if players.size() < 2: return
	if !is_instance_valid(players[0]) or !is_instance_valid(players[1]): return
	
	var delta_distance = players[0].position - players[1].position
	var distance = delta_distance.length()
	
	if distance > rope_length:
		if players[0].getIsGrabbed() or players[1].getIsGrabbed(): return
		var stretch = distance - rope_length
		
		var dir_0_to_1 = -delta_distance.normalized()
		var dir_1_to_0 = -dir_0_to_1
		
		var force = stretch * spring_strength
		
		players[0].addImpulse(dir_0_to_1 * force)
		players[1].addImpulse(dir_1_to_0 * force)
