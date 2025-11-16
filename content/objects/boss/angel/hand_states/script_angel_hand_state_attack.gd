extends EnemyState
class_name AngelHandAttack

const SLOWDOWN: float = 0.95

@export var angel_hand: AngelHand

var players: Array[Player]
var bonks: int

func Enter():
	bonks = 6

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float):
	if bonks <= 0:
		Transitioned.emit(self, "returning")
	
	var collision = angel_hand.move_and_collide(angel_hand.velocity * delta)

	if collision:
		angel_hand.velocity = angel_hand.velocity.bounce(collision.get_normal()) * SLOWDOWN
		bonks -= 1
