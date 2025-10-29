extends EnemyState
class_name GuardHandGrabbed

@export var guard_hand: CharacterBody2D

var players: Array[CharacterBody2D]

func Enter(): 
	guard_hand.setHurtingPlayer(false)

func Exit(): 
	guard_hand.setHurtingPlayer(true)

func Update(_delta: float): pass

func physicsUpdate(delta: float): pass
