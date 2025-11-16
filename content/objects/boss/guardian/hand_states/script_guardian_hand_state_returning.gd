extends EnemyState
class_name GuardHandReturning

@export var guard_hand: GuardianHand

var players: Array[Player]

func Enter(): pass

func Exit(): pass

func Update(_delta: float):
	guard_hand.updateScaleDirection()

func physicsUpdate(delta: float): 
	if guard_hand.moveToBody(delta): Transitioned.emit(self, "idle")
