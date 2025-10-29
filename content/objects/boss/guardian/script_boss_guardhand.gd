extends CharacterBody2D
class_name GuardianHand

const SPEED: float = 100.0
const JUMP_VELOCITY: float = -400.0
const DECELERATION: float = 2.0
const MAX_FALL_SPEED: float = 300.0

@export var guard_body: GuardianBody
@export var left_hand: bool

var weight: float = 1.5

@onready var sprite: Sprite2D = $spr2D_sprite
@onready var state_machine: Node = $node_hand_states
@onready var collision: CollisionShape2D = $colshape_collision
@onready var overlap_area: Area2D = $area2D_overlap

func _ready() -> void:
	if left_hand:
		sprite.flip_h = true

func _physics_process(delta: float) -> void: pass

func updateScaleDirection() -> void:
	rotation = 0
	scale = Vector2(1.0, 1.0)
	if left_hand: sprite.flip_h = true

func snapToBody(delta: float) -> void:
	global_position = guard_body.getHandPosition(int(left_hand))

func moveToBody(delta:float) -> bool:
	var destination: Vector2 = guard_body.getHandPosition(int(left_hand))
	if global_position != destination:
		var step: float = SPEED * delta
		if global_position.distance_to(destination) <= step:
			global_position = destination
			return true
		else:
			global_position = global_position.move_toward(destination, step)
	return false

func getHandStateName() -> String:
	return state_machine.current_state.name

func tryAttack() -> void:
	if state_machine.current_state.name == "idle":
		state_machine.current_state.Transitioned.emit(state_machine.current_state, "attack")

func doPhysics(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, DECELERATION * weight)
	velocity += get_gravity() * weight * delta
	
	if velocity.y > MAX_FALL_SPEED * weight:
		velocity.y = MAX_FALL_SPEED * weight
	
	move_and_slide()

func setGrabbableByPlayer(to_set: bool):
	if get_collision_layer_value(2) == to_set: return
	set_collision_layer_value(2, to_set)

func setHurtingPlayer(to_set: bool):
	if overlap_area.get_collision_layer_value(8) == to_set: return
	overlap_area.set_collision_layer_value(8, to_set)

func setHurtingBoss(to_set: bool):
	if get_collision_layer_value(7) == to_set: return
	set_collision_layer_value(7, to_set)

func setGrabbed() -> void:
	velocity = Vector2.ZERO
	collision.call_deferred("set_disabled", true)
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "grabbed")

func setUngrabbed() -> void:
	collision.call_deferred("set_disabled", false)
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "thrown")

func setImpulse(impulse: Vector2, override: bool = false) -> void:
	if getIsGrabbed() and override == false: return
	velocity = impulse

func getIsGrabbed() -> bool:
	if state_machine.current_state.name == "grabbed": return true
	return false
