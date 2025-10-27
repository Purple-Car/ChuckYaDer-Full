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
	
	_goTowardPlayer(delta)
	_updateAnimations()

func _updateAnimations() -> void:
	guard_body.doAnimations()
	guard_body.playHandAnimation()

func getClosestPlayer() -> Player:
	var players = Utils.getLivePlayers()
	var closest_player: Player
	var closest_proximity: int = 0
	
	for player in players:
		var proximity: Vector2 = player.global_position - guard_body.global_position
		
		if closest_proximity < proximity.length():
			closest_player = player
			closest_proximity = proximity.length()
	
	return closest_player

func _goTowardPlayer(delta: float) -> void:
	if !getClosestPlayer(): closest_player_dir = 0
	var future_velocity: float = 0.0
	
	if countdown > 0:
		countdown -= delta
		future_velocity = guard_body.SPEED
	else:
		countdown = randf_range(0.4, 2)
		if getClosestPlayer():
			closest_player_dir = sign(getClosestPlayer().global_position.x - guard_body.global_position.x)
	
	# Se estiver perto demais reduz a velocidade
	# Se estiver quase colado, realiza ataque
	
	future_velocity = future_velocity * closest_player_dir
	
	guard_body.velocity.x = future_velocity
