extends EnemyState
class_name AngelNormal

@export var angel_body: AngelBody
@export var attacks: Array[EnemyState]

var attack_chances: Array[int] = [1,2]
var countdown: float
var players: Array[Player]
var closest_player_dir: int
var rand_offset: Vector2

func Enter():
	rand_offset = Vector2(randi_range(-32, 32), randi_range(-16, 16))
	countdown = randi_range(1.5, 3.5)

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float):
	_updateAnimations()
	_moveAboutX(delta)
	_moveAboutY(delta)
	_handleAttack(delta)

func _updateAnimations() -> void:
	angel_body.doAnimations()
	angel_body.playHandAnimation()

func _moveAboutY(delta: float) -> void:
	var players = Utils.getLivePlayers()
	var target_y = 116
	if players.size() == 2:
		target_y = (players[0].global_position.y + players[1].global_position.y) / 2.0
	elif players.size() == 1:
		target_y = players[0].global_position.y

	var direction: int = sign(target_y + rand_offset.y - angel_body.global_position.y)
	
	if sign(angel_body.velocity.y) != 0 and sign(angel_body.velocity.y) != direction:
		angel_body.velocity.y += direction * angel_body.DECELERATION * delta
	else:
		angel_body.velocity.y += direction * angel_body.ACCELERATION * delta
	
	angel_body.velocity.y = clamp(angel_body.velocity.y, -angel_body.MAX_SPEED, angel_body.MAX_SPEED)

func _moveAboutX(delta: float) -> void:
	var players = Utils.getLivePlayers()
	var target_x = 240
	if players.size() == 2:
		target_x = (players[0].global_position.x + players[1].global_position.x) / 2.0
	elif players.size() == 1:
		target_x = players[0].global_position.x

	var direction: int = sign(target_x + rand_offset.x - angel_body.global_position.x)
	
	angel_body.velocity.x += direction * angel_body.DECELERATION * delta
	
	angel_body.velocity.x = clamp(angel_body.velocity.x, -angel_body.MAX_SPEED, angel_body.MAX_SPEED)

func _handleAttack(delta: float) -> void:
	if countdown < 0:
		if angel_body.isOnWall(): return
		
		var selected_atk: float = 0
		for number in attack_chances:
			selected_atk += number
		selected_atk = randi_range(0, selected_atk - 1)
		
		if selected_atk < attack_chances[0]:
			Transitioned.emit(self, "fist")
			attack_chances = [1, attack_chances[1] * 2]
		else:
			Transitioned.emit(self, "bomb")
			attack_chances = [attack_chances[0] * 2, 2]
	else:
		countdown -= delta
