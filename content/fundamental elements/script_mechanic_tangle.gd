extends Node2D

@export var rope_length: int = 64
@export var spring_strength: float = 0.8

@export var scarf_scene: PackedScene

var scarf_instance: Node2D
var players: Array[CharacterBody2D]

func _physics_process(delta: float) -> void:
	players = getLivePlayers()
	
	if players.size() < 2: 
		if scarf_instance and scarf_instance.is_inside_tree():
			scarf_instance.queue_free()
			scarf_instance = null
		return
	
	if not scarf_instance:
		spawnScarf()

func spawnScarf() -> void:
	var player_1: CharacterBody2D
	var player_2: CharacterBody2D
	
	if players[0].getPlayerNumber() == 1:
		player_1 = players[0]
		player_2 = players[1]
	else:
		player_1 = players[1]
		player_2 = players[0]
	
	scarf_instance = scarf_scene.instantiate()
	scarf_instance.setupScarf(player_1, player_2, rope_length, spring_strength)
	add_child(scarf_instance)

func getLivePlayers() -> Array[CharacterBody2D]:
	var live_players: Array[CharacterBody2D] = []
	var siblings: Array[Node] = get_parent().get_children()
	for sibling in siblings:
		if sibling.is_in_group("player"):
			live_players.append(sibling)
	return live_players

func getPlayerPositions(players_to_process: Array[CharacterBody2D]) -> Array[Vector2]:
	var processed_positions: Array[Vector2] = []
	for player in players_to_process:
		processed_positions.append(player.global_position)
	return processed_positions
	
#func _physics_process(delta: float) -> void:
	#players = getLivePlayers()
	#
	#if players.size() < 2: return
	#
	#var positions = getPlayerPositions(players)
#
	#for rep_a in range(players.size()):
		#for rep_b in range(rep_a + 1, players.size()):
			#var delta_distance = positions[rep_a] - positions[rep_b]
			#var distance = delta_distance.length()
			#
			#if distance > rope_length:
				#var stretch = distance - rope_length
				#
				#var dir_a_to_b = -delta_distance.normalized()
				#var dir_b_to_a = -dir_a_to_b
				#
				#var force = stretch * spring_strength
				#
				#players[rep_a].addImpulse(dir_a_to_b * force)
				#players[rep_b].addImpulse(dir_b_to_a * force)
