extends EnemyState
class_name LordHandReturning

@export var lord_hand: LordHand

var players: Array[Player]

func Enter(): pass

func Exit(): pass

func Update(_delta: float):
	lord_hand.updateScaleDirection()

func physicsUpdate(delta: float): 
	if lord_hand.moveToBody(delta): Transitioned.emit(self, "idle")
