extends EnemyState
class_name LordHandAttack

@export var lord_hand: LordHand

var players: Array[Player]

func Enter(): 
	var target = lord_hand.lord_body.getClosestPlayer()
	var dir: Vector2
	if target:
		dir = (target.global_position - lord_hand.global_position).normalized()
	else:
		dir = Vector2(Utils.boolToSign(!lord_hand.left_hand),0)
	lord_hand.velocity = dir * 300 + Vector2(0,-50)

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float): 
	lord_hand.doPhysics(delta)
	
	if lord_hand.is_on_floor():
		lord_hand.velocity = Vector2(lord_hand.velocity.x / 2, -120)
		Transitioned.emit(self, "sitting")
	elif lord_hand.is_on_wall() or lord_hand.is_on_ceiling():
		lord_hand.velocity.x = 0
