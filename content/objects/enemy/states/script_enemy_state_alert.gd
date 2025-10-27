extends EnemyState
class_name EnemyWalk

@export var enemy: CharacterBody2D

var players: Array[CharacterBody2D]

func Enter():
	enemy.playAnimation("alert")

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(_delta: float): pass

func _onAnimationFinished() -> void:
	if enemy.getAnimation() != "alert": return
	
	Transitioned.emit(self, "walk")
