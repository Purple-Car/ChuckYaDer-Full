extends EnemyState
class_name LordAttack

@export var lord_body: LordBody

var players: Array[Player]
var no_attack: bool

func Enter():
	var closest_player: Player = lord_body.getClosestPlayer()
	var closest_player_dir: int = sign(closest_player.global_position.x - lord_body.global_position.x)
	no_attack = false
	
	if closest_player_dir == 1 and lord_body.lordhands[1].getHandStateName() == "idle":
		lord_body.playHandAnimation("attack_l")
	elif closest_player_dir == -1 and lord_body.lordhands[0].getHandStateName() == "idle":
		lord_body.playHandAnimation("attack_r")
	else:
		no_attack = true

func Exit(): pass

func Update(_delta: float):
	if no_attack:
		Transitioned.emit(self, "normal") 
	lord_body.doAnimations()

func physicsUpdate(_delta: float): pass

func _onAnimationFinished(anim_name: StringName) -> void:
	if anim_name == "attack_l":
		lord_body.launchHand(true)
	elif anim_name == "attack_r":
		lord_body.launchHand(false)
	
	Transitioned.emit(self, "normal")
