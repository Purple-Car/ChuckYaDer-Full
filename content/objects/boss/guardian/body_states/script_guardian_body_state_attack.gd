extends EnemyState
class_name GuardianAttack

@export var guard_body: GuardianBody

var players: Array[CharacterBody2D]

func Enter():
	var closest_player: Player = guard_body.getClosestPlayer()
	var closest_player_dir: int = sign(closest_player.global_position.x - guard_body.global_position.x)
	var closest_player_dis: float = abs(closest_player.global_position.x - guard_body.global_position.x)
	
	if closest_player_dir == 1 and guard_body.guardhands[1].getHandStateName() == "idle":
		guard_body.playHandAnimation("attack_l")
		guard_body.launchHand(closest_player_dis, true)
	elif closest_player_dir == -1 and guard_body.guardhands[0].getHandStateName() == "idle": 
		guard_body.playHandAnimation("attack_r")
		guard_body.launchHand(closest_player_dis, false)
	else:
		Transitioned.emit(self, "normal")
func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(_delta: float): pass

func _onAnimationFinished(anim_name: StringName) -> void:
	#if anim_name == "intro":
		Transitioned.emit(self, "normal")
