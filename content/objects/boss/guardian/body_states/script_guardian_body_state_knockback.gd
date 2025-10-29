extends EnemyState
class_name GuardianKnockback

@export var guard_body: GuardianBody

var countdown: float

func Enter():
	countdown = 1.0
	guard_body.velocity.x = 100 * guard_body.last_hit_direction
	print(countdown)
	print(guard_body.velocity.x)

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float):
	_moveKnockback(delta)

func _moveKnockback(delta: float) -> void:
	if countdown > 0.5:
		guard_body.velocity.x = move_toward(guard_body.velocity.x, 0, 200 * delta)
	else:
		Transitioned.emit(self, "normal")
	countdown -= delta
