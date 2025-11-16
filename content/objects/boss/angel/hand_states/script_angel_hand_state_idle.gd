extends EnemyState
class_name AngelHandIdle

@export var angel_hand: AngelHand

var players: Array[Player]

func Enter(): pass

func Exit(): pass

func Update(_delta: float): 
	angel_hand.snapToBody()

func physicsUpdate(delta: float): pass
	
