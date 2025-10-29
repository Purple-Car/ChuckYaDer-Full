extends EnemyState
class_name GuardHandIdle

@export var guard_hand: CharacterBody2D

var players: Array[CharacterBody2D]

func Enter(): pass

func Exit(): pass

func Update(_delta: float):
	guard_hand.updateScaleDirection()

func physicsUpdate(delta: float): 
	if guard_hand.moveToBody(delta): Transitioned.emit(self, "idle")
