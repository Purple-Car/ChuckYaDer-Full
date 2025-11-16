extends EnemyState
class_name LordHandGrabbed

@export var lord_hand: LordHand

var players: Array[Player]

func Enter(): pass

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float): pass
