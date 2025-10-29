extends EnemyState
class_name GuardHandSitting

@export var guard_hand: CharacterBody2D

var players: Array[CharacterBody2D]
var countdown: float

func Enter(): 
	countdown = 2.0
	Utils.spawnSmokePuff(guard_hand.global_position, 6, 0)
	guard_hand.setGrabbableByPlayer(true)

func Exit(): 
	guard_hand.setGrabbableByPlayer(false)

func Update(delta: float):
	if countdown > 0:
		countdown -= delta
	else:
		Transitioned.emit(self, "returning")

func physicsUpdate(delta: float): 
	guard_hand.doPhysics(delta)
