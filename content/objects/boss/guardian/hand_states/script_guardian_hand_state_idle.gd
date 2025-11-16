extends EnemyState
class_name GuardHandIdle

@export var guard_hand: GuardianHand

var players: Array[Player]

func Enter(): pass

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float): 
	guard_hand.snapToBody(delta)
