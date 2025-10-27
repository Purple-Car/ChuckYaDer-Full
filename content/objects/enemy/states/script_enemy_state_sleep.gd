extends EnemyState
class_name EnemySleep

@export var enemy: CharacterBody2D

var players: Array[CharacterBody2D]

func Enter(): pass

func Exit(): pass

func Update(_delta: float):
	enemy.playAnimation("sleep")

func physicsUpdate(_delta: float):
	for player in get_tree().get_nodes_in_group("player"):
		var direction: Vector2 = player.global_position - enemy.global_position
	
		if direction.length() < 48:
			Transitioned.emit(self, "alert")
