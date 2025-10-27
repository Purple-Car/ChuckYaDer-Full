extends EnemyState
class_name GuardianNormal

@export var guard_body: GuardianBody

var countdown: float
var players: Array[CharacterBody2D]
var closest_player_dir: int

func Enter(): pass

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float):
	_updateAnimations()
	_goTowardPlayer(delta)

func _updateAnimations() -> void:
	guard_body.doAnimations()
	guard_body.playHandAnimation()

func _goTowardPlayer(delta: float) -> void:
	var closest_player: Player = guard_body.getClosestPlayer()
	var future_velocity: float = 0.0
	
	if closest_player == null: 
		closest_player_dir = 0
	else:
		if countdown > 0:
			countdown -= delta
			future_velocity = guard_body.SPEED
		else:
			countdown = randf_range(0.4, 2)
			closest_player_dir = sign(closest_player.global_position.x - guard_body.global_position.x)
		if guard_body.is_on_floor():
			if abs(closest_player.global_position.x - guard_body.global_position.x) < 42:
				future_velocity = 0
				Transitioned.emit(self, "attack")
			elif abs(closest_player.global_position.x - guard_body.global_position.x) < 64:
				future_velocity /= 2
			if randi_range(0, 255) == 255:
				guard_body.velocity.y = guard_body.JUMP_VELOCITY
	
	future_velocity = future_velocity * closest_player_dir
	
	guard_body.velocity.x = future_velocity
