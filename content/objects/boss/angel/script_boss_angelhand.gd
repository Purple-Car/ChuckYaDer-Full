extends CharacterBody2D
class_name AngelHand

const SPEED: float = 160.0

@export var angel_body: AngelBody
@export var left_hand: bool

var weight: float = 1.5

@onready var sprite: AnimatedSprite2D = $anispr_sprite
@onready var state_machine: Node = $node_hand_states
@onready var collision: CollisionShape2D = $colshape_collision
@onready var overlap_area: Area2D = $area2D_overlap

func _ready() -> void:
	if left_hand:
		sprite.flip_h = true
		sprite.position.x = 4

func _physics_process(delta: float) -> void: pass

func snapToBody() -> void:
	global_position = angel_body.getHandPosition(int(left_hand))
	z_index = angel_body.z_index

func moveToBody(delta:float) -> bool:
	var destination: Vector2 = angel_body.getHandPosition(int(left_hand))
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

func tryAttack(to_velocity: Vector2) -> void:
	if state_machine.current_state.name == "idle":
		state_machine.current_state.Transitioned.emit(state_machine.current_state, "attack")
		velocity = to_velocity

func doPhysics(delta: float) -> int:
	return move_and_slide()

func playAnimation(to_animation: String) -> void:
	sprite.play(to_animation)

func _spawnAfterImage() -> void:
	var hand_tex: Texture2D = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	
	Utils.spawnAfterImage(hand_tex, sprite.global_position, get_parent(), left_hand, z_index)

func _onTimeout() -> void:
	_spawnAfterImage()
