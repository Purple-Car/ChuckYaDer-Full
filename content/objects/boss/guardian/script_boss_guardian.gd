extends CharacterBody2D
class_name GuardianBody

const MAX_FALL_SPEED: float = 200.0
const SPEED: float = 50.0
const JUMP_VELOCITY: float = -160.0
const MAX_HP: int = 8

@export var animation_p: AnimationPlayer
@export var guardhands: Array[GuardianHand]

var boss_hp: int = MAX_HP

@onready var body_sprite: AnimatedSprite2D = $node_sprites/anisprite_body
@onready var hands: Array[Node2D] = [$node_sprites/node_rhand, $node_sprites/node_lhand]

func _physics_process(delta: float) -> void:
	_applyGravity(delta)
	move_and_slide()

func _applyGravity(delta: float) -> void:
	velocity += get_gravity() * delta
		
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

func doAnimations() -> void:
	if is_on_floor():
		if velocity.x < 0:
			body_sprite.play("walk")
		elif velocity.x > 0:
			body_sprite.play("walk", -1.0, true)
		else:
			body_sprite.play("idle")
	else:
		body_sprite.play("fall")

func playHandAnimation(to_anim: String = body_sprite.animation) -> void:
	animation_p.play(to_anim)

func getHandPosition(left_hand: int):
	return hands[left_hand].global_position

func getClosestPlayer() -> Player:
	var players = Utils.getLivePlayers()
	var closest_player: Player
	var closest_proximity: int = 320

	for player in players:
		var proximity: float = abs(player.global_position.x - global_position.x)
		
		if closest_proximity > proximity:
			closest_player = player
			closest_proximity = proximity
	
	return closest_player

func launchHand(closest_player_dis: float, is_left_hand: bool):
	guardhands[int(is_left_hand)].tryAttack()
	pass
