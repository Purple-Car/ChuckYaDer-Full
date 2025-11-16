extends Node

var active: bool = false
var players: Array[Player]
var points: Array[Node2D] = []

@export var spawners: Array[Node2D]

func _ready() -> void:
	for child in get_children():
		if child is Node2D:
			points.append(child)
	for spawner in spawners:
		spawner.onRespawnStart.connect(_attemptRelocate)
		if points.size() > 0:
			spawner.ghostable = true

func _attemptRelocate(player_num: int) -> void:
	players = Utils.getLivePlayers()
	if players.size() == 1:
		var player = players[0]
		var number = player.getPlayerNumber() % 2
		spawners[number].global_position = player.global_position
	elif points.size() <= 0:
		Gamestate.setNextScene(get_tree().current_scene.scene_file_path)
		Gamestate.changeState(Gamestate.States.fadeout)
	else:
		var selected_spawn: int = randi_range(0, points.size() - 1)
		spawners[player_num - 1].global_position = points[selected_spawn].global_position
