extends EnemyState
class_name LordKnockback

@export var lord_body: LordBody

var countdown: float

func Enter():
	countdown = 1.0
	lord_body.velocity.x = 100 * lord_body.last_hit_direction
	lord_body.playHandAnimation("idle")

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float):
	_moveKnockback(delta)

func _moveKnockback(delta: float) -> void:
	if countdown > 0.5:
		lord_body.velocity.x = move_toward(lord_body.velocity.x, 0, 200 * delta)
	else:
		Transitioned.emit(self, "normal")
	countdown -= delta
