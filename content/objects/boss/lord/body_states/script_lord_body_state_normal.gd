extends EnemyState
class_name LordNormal

@export var lord_body: LordBody

var countdown: float
var players: Array[CharacterBody2D]
var closest_player_dir: int

func Enter():
	countdown = 1

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float):
	_updateAnimations()
	_goTowardPlayer(delta)

func _updateAnimations() -> void:
	lord_body.doAnimations()
	lord_body.playHandAnimation()

func _goTowardPlayer(delta: float) -> void:
	var closest_player: Player = lord_body.getClosestPlayer()
	var future_velocity: float = 0.0
	
	if lord_body.is_on_floor():
		if closest_player == null:
			closest_player_dir = 0
		else:
			if countdown > 0:
				countdown -= delta
				future_velocity = lord_body.SPEED
			else:
				countdown = randf_range(0.4, 2)
			
			closest_player_dir = sign(closest_player.global_position.x - lord_body.global_position.x)
			future_velocity += abs(closest_player.global_position.x - lord_body.global_position.x) * 0.25
			
			if closest_player.global_position.y + 6 >= lord_body.hurtbox_area.global_position.y and abs(closest_player.global_position.x - lord_body.global_position.x) < 32:
				lord_body.velocity.y = lord_body.JUMP_VELOCITY
				closest_player_dir = -closest_player_dir
				future_velocity = 80
	else:
		future_velocity = abs(lord_body.velocity.x)
	
				# Filthy Code
				#if closest_player_dir == 1 and guard_body.guardhands[1].getHandStateName() == "idle":
					#Transitioned.emit(self, "attack")
					#future_velocity = 0
				#elif closest_player_dir == -1 and guard_body.guardhands[0].getHandStateName() == "idle": 
					#Transitioned.emit(self, "attack")
					#future_velocity = 0
				#
			#elif abs(closest_player.global_position.x - guard_body.global_position.x) < 64:
				#future_velocity /= 2
			#if randi_range(0, 383) == 255:
				#guard_body.velocity.y = guard_body.JUMP_VELOCITY
	#
	future_velocity = future_velocity * closest_player_dir

	lord_body.velocity.x = future_velocity
