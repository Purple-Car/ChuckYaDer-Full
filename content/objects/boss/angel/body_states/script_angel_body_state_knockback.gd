extends EnemyState
class_name AngelKnockback

@export var angel_body: AngelBody

var countdown: float

func Enter():
	countdown = 1.0
	angel_body.velocity.x = 200 * angel_body.last_hit_direction
	angel_body.playHandAnimation("strut")

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float):
	_moveKnockback(delta)

func _moveKnockback(delta: float) -> void:
	if countdown > 0.5:
		angel_body.velocity.x = move_toward(angel_body.velocity.x, 0, 200 * delta)
	else:
		Transitioned.emit(self, "normal")
	countdown -= delta
