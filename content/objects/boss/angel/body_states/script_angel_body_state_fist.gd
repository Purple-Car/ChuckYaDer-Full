extends EnemyState
class_name AngelFist

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
			if angel_body.boss_hp < angel_body.MAX_HP / 2:
				_attemptMultiAttack()
			else:
				_attemptAttack()

func _attemptMultiAttack() -> void:
	if angel_body.angelhands[1].getHandStateName() == "idle" and angel_body.angelhands[0].getHandStateName() == "idle": 
		angel_body.playHandAnimation("fist_b")
		attack_succesfull = true
	else:
		if angel_body.angelhands[1].getHandStateName() == "idle":
			angel_body.playHandAnimation("fist_l")
			attack_succesfull = true
		if angel_body.angelhands[0].getHandStateName() == "idle": 
			angel_body.playHandAnimation("fist_r")
			attack_succesfull = true
	
	if attack_succesfull == false:
		Transitioned.emit(self, "normal")

func _attemptAttack() -> void:
	var closest_player = angel_body.getClosestPlayer()
	var closest_player_dir: int
	
	if closest_player:
		closest_player_dir = sign(closest_player.global_position.x - angel_body.global_position.x)
	else:
		closest_player_dir = [-1, 1].pick_random()
	
	if closest_player_dir == 1 and angel_body.angelhands[1].getHandStateName() == "idle":
		angel_body.playHandAnimation("fist_l")
		attack_succesfull = true
	elif closest_player_dir == -1 and angel_body.angelhands[0].getHandStateName() == "idle": 
		angel_body.playHandAnimation("fist_r")
		attack_succesfull = true
	else:
		Transitioned.emit(self, "normal") 

func _onAnimationFinished(anim_name: StringName) -> void:
	if angel_body.isOnWall():
		Transitioned.emit(self, "normal")
		return
	
	var closest_player = angel_body.getClosestPlayer()
	var closest_player_dir: Vector2
	
	if closest_player:
		closest_player_dir = (closest_player.global_position - angel_body.global_position).normalized()
	else:
		closest_player_dir = [Vector2(-1, 0), Vector2(1, 0)].pick_random()
	var attack_velocity: Vector2 = 400 * closest_player_dir
	
	if anim_name == "fist_l":
		angel_body.launchHand(true, attack_velocity)
	elif anim_name == "fist_r":
		angel_body.launchHand(false, attack_velocity)
	elif anim_name == "fist_b":
		angel_body.launchHand(true, attack_velocity)
		angel_body.launchHand(false, -attack_velocity)
	
	Transitioned.emit(self, "normal")
