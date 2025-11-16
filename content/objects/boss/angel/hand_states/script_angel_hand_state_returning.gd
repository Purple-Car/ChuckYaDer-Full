extends EnemyState
class_name AngelHandReturning

@export var angel_hand: AngelHand

var players: Array[Player]

func Enter(): pass

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float): 
	if angel_hand.moveToBody(delta): Transitioned.emit(self, "idle")
