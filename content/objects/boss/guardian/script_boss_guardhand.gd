extends CharacterBody2D
class_name GuardianHand

@export var guard_body: GuardianBody
@export var left_hand: bool

const SPEED = 25.0
const JUMP_VELOCITY = -400.0

@onready var sprite: Sprite2D = $spr2D_sprite
@onready var state_machine: Node = $node_hand_states

func _ready() -> void:
	if left_hand:
		sprite.flip_h = true

func _physics_process(delta: float) -> void:
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	move_and_slide()

func snapToBody(delta: float) -> void:
	#global_position = guard_body.getHandPosition(int(left_hand))
	var destination: Vector2 = guard_body.getHandPosition(int(left_hand))
	if global_position != destination:
		var step: float = SPEED * delta
		if global_position.distance_to(destination) <= step:
			global_position = destination
		else:
			global_position = global_position.move_toward(destination, step)

func getHandStateName() -> String:
	return state_machine.current_state.name

func tryAttack() -> void:
	if state_machine.current_state.name == "idle":
		pass
