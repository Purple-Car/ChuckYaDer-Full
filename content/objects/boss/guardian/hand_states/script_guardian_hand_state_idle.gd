extends EnemyState
class_name GuardHandIdle

@export var guard_hand: CharacterBody2D

var players: Array[CharacterBody2D]

func Enter(): pass

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(_delta: float): 
	guard_hand.snapToBody()
