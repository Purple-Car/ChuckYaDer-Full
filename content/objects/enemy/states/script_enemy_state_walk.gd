extends EnemyState
class_name EnemyAlert

const BASE_SPEED: float = 40.0

@export var enemy: CharacterBody2D

var players: Array[CharacterBody2D]

func Enter(): pass

func Exit(): pass

func Update(_delta: float):
	enemy.playAnimation("walk")

func physicsUpdate(_delta: float):
	enemy.velocity.x = BASE_SPEED
	if enemy.is_on_wall():
		enemy.sprite.flip_h = !enemy.sprite.flip_h
	if !enemy.sprite.flip_h:
		enemy.velocity.x = -enemy.velocity.x
