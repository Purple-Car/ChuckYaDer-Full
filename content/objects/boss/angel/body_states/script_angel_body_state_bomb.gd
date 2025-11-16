extends EnemyState
class_name AngelBomb

@export var angel_body: AngelBody

var attack_succesfull: bool

func Enter(): 
	attack_succesfull = false

func Exit(): pass

func Update(_delta: float):
	angel_body.doAnimations()

func physicsUpdate(delta: float):
	var target = Vector2(240,132)
	var direction = (target - angel_body.global_position).normalized()
	
	if angel_body.isOnWall():
		angel_body.velocity = angel_body.velocity.move_toward(direction * 150, angel_body.STOP_DECELERATION * delta)
	else:
		angel_body.velocity = angel_body.velocity.move_toward(direction * 10, angel_body.STOP_DECELERATION * delta)
		if !attack_succesfull:
			_attemptAttack()

func _attemptAttack() -> void:
	var closest_player = angel_body.getClosestPlayer()
	var closest_player_dir: int
	
	if closest_player:
		closest_player_dir = sign(closest_player.global_position.x - angel_body.global_position.x)
	else:
		closest_player_dir = [-1, 1].pick_random()
	
	if closest_player_dir == 1 and angel_body.angelhands[1].getHandStateName() == "idle":
		angel_body.playHandAnimation("bomb_l")
		attack_succesfull = true
	elif closest_player_dir == -1 and angel_body.angelhands[0].getHandStateName() == "idle": 
		angel_body.playHandAnimation("bomb_r")
		attack_succesfull = true
	else:
		Transitioned.emit(self, "normal") 

func _onAnimationFinished(anim_name: StringName) -> void:
	Transitioned.emit(self, "normal")
