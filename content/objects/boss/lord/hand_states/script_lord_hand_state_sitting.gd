extends EnemyState
class_name LordHandSitting

@export var lord_hand: LordHand

var players: Array[Player]
var countdown: float

func Enter(): 
	countdown = 2.0
	Utils.spawnSmokePuff(lord_hand.global_position, 6, 0)
	lord_hand.setGrabbableByPlayer(true)

func Exit(): 
	lord_hand.setGrabbableByPlayer(false)

func Update(delta: float):
	if countdown > 0:
		countdown -= delta
	else:
		Transitioned.emit(self, "returning")

func physicsUpdate(delta: float): 
	lord_hand.doPhysics(delta)
