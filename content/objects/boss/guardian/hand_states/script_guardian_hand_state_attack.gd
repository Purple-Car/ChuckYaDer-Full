extends EnemyState
class_name GuardHandAttack

@export var guard_hand: CharacterBody2D

var players: Array[CharacterBody2D]

func Enter(): 
	guard_hand.velocity = Vector2(Utils.boolToSign(guard_hand.left_hand) * -180, -90)

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float): 
	guard_hand.doPhysics(delta)
	
	if guard_hand.is_on_floor():
		Transitioned.emit(self, "sitting")
