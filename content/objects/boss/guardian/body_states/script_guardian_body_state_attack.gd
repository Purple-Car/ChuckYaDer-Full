extends EnemyState
class_name GuardianAttack

@export var guard_body: GuardianBody

var players: Array[CharacterBody2D]
var no_attack: bool

func Enter():
	var closest_player: Player = guard_body.getClosestPlayer()
	var closest_player_dir: int = sign(closest_player.global_position.x - guard_body.global_position.x)
	no_attack = false
	
	if closest_player_dir == 1 and guard_body.guardhands[1].getHandStateName() == "idle":
		guard_body.playHandAnimation("attack_l")
	elif closest_player_dir == -1 and guard_body.guardhands[0].getHandStateName() == "idle": 
		guard_body.playHandAnimation("attack_r")
	else:
		no_attack = true
		

func Exit(): pass

func Update(_delta: float):
	if no_attack:
		Transitioned.emit(self, "normal") 

func physicsUpdate(_delta: float): pass

func _onAnimationFinished(anim_name: StringName) -> void:
	if anim_name == "attack_l":
		guard_body.launchHand(true)
	elif anim_name == "attack_r":
		guard_body.launchHand(false)
	
	Transitioned.emit(self, "normal")
