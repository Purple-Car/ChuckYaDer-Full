extends CharacterBody2D
class_name GuardianBody

const MAX_FALL_SPEED: float = 200.0

@export var animation_p: AnimationPlayer

const SPEED: float = 50.0
const JUMP_VELOCITY: float = -400.0

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
