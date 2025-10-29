extends EnemyState
class_name GuardHandThrown

@export var guard_hand: CharacterBody2D

var players: Array[CharacterBody2D]

func Enter():
	guard_hand.setHurtingBoss(true)

func Exit():
	guard_hand.setHurtingBoss(false)

func Update(_delta: float): pass

func physicsUpdate(delta: float): 
	guard_hand.doPhysics(delta)
	
	if guard_hand.is_on_floor():
		Transitioned.emit(self, "returning")
