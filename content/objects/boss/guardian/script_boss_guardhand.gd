extends CharacterBody2D

@export var guard_body: GuardianBody
@export var left_hand: bool

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite: Sprite2D = $spr2D_sprite

func _ready() -> void:
	if left_hand:
		sprite.flip_h = true

func _physics_process(delta: float) -> void:
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	move_and_slide()

func snapToBody() -> void:
	global_position = guard_body.getHandPosition(int(left_hand))
