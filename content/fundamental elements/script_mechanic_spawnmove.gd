extends Node

var active: bool = false
var players: Array[CharacterBody2D]

@export var spawners: Array[Node2D]

func _process(delta: float) -> void:
	_playerSpawnMove(delta)

func _playerSpawnMove(delta: float) -> void:
	players = Utils.getLivePlayers()
	
	if players.size() <= 0 and active == true:
		Gamestate.setNextScene(get_tree().current_scene.scene_file_path)
		Gamestate.changeState(Gamestate.States.fadeout)
	elif players.size() > 0 and active == false:
		active = true
	
	for player in players:
		var number: int = player.getPlayerNumber() % 2
		spawners[number].global_position = player.global_position
