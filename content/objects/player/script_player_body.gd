extends CharacterBody2D

const SPEED: float = 84.0
const JUMP_VELOCITY: float = -60.0
const MAX_FALL_SPEED: float = 192.0
const DECELERATION: float = 4
enum States { idle, walk, crouch, jump, fall, grabbed }
enum Sub_States { grab, carry, throw }

var _death_effect: PackedScene = preload("res://effects/player_death/scene_player_death.tscn")
var is_flipped: bool = false
var direction_y: float
var direction_x: float
var player_num: int = 1
var grabbed_object: Object

@onready var states_machine: PlayerStateMachine = $node_state_machine
@onready var sub_states_machine: PlayerSubstateMachine = $node_substate_machine
@onready var sprites_node: Node2D = $node2D_sprites
@onready var hands_player: AnimationPlayer = $anipl_hands
@onready var body_player: AnimatedSprite2D = $node2D_sprites/anisprite_body
@onready var overlap_col: Area2D = $area2D_overlap

signal onPlayerDestroyed

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_directionalMovement()
	_changeFacingDirection()
	move_and_slide()

#region privates
func _changeFacingDirection() -> void:
	if velocity.x > 0:
		is_flipped = true
	elif velocity.x < 0:
		is_flipped = false
	else:
		return
	_updateScaleDirection()

func _updateScaleDirection() -> void:
	scale.y = 1.0
	rotation = 0
	sprites_node.scale = Vector2(Utils.boolToSign(is_flipped), 1.0)

func _directionalMovement() -> void:
	var toward_speed: float
	var air_state: State = $"node_state_machine/air"
	
	if abs(velocity.x) > SPEED:
		toward_speed = DECELERATION
	else:
		toward_speed = SPEED
	
	direction_x = Input.get_axis("p%s_left" % getPlayerNumber(), "p%s_right" % getPlayerNumber())
	if direction_x and states_machine.getCanMove():
		velocity.x = move_toward(velocity.x, direction_x * SPEED, toward_speed)
	else:
		if states_machine.current_state == air_state:
			velocity.x = move_toward(velocity.x, 0, DECELERATION)
		else:
			velocity.x = move_toward(velocity.x, 0, toward_speed)
#endregion

#region publics
func playBodyAnimation(next_animation: String = "") -> void:
	# If function called with no parameters it resumes the animation
	if next_animation == "": 
		body_player.play()
		return
	
	# Play animation if it's a different animation
	if getBodyAnimation() != next_animation:
		body_player.play(next_animation)

func playHandsAnimation(next_animation: String = "") -> void:
	# If function called with no parameters it resumes the animation
	if next_animation == "": 
		hands_player.play()
		return
	
	# Play animation if it's a different animation
	if getHandsAnimation() != next_animation:
		hands_player.play(next_animation)

func doDeath() -> void:
	onPlayerDestroyed.emit()
	var death_effect = _death_effect.instantiate()
	get_parent().add_child(death_effect)
	death_effect.position = position
	death_effect.scale = Vector2( Utils.boolToSign(is_flipped), 1)
	
	if grabbed_object:
		ungrabObject()
	
	queue_free()

func getBodyAnimation() -> String:
	return body_player.animation

func getHandsAnimation() -> String:
	return hands_player.assigned_animation 

func getPlayerNumber() -> int:
	return player_num

func setGrabbedObject(to_object: Object) -> void:
	grabbed_object = to_object

func ungrabObject() ->void:
	var reparent_node: Node = get_tree().root.get_node("node_stage/node_grabbables")
	grabbed_object.call_deferred("reparent", reparent_node)
	#grabbed_object.setUngrabbed()
	setGrabbedObject(null)

func throwObject() -> void:
	grabbed_object.setUngrabbed()
	if body_player.animation == "crouch":
		var impulse_x: float = -72 * sign(Utils.boolToSign(is_flipped))
		grabbed_object.setImpulse( Vector2( impulse_x, 0 ), true )
		playHandsAnimation("drop")
	else:
		var impulse_x: float = -192 * sign(Utils.boolToSign(is_flipped))
		var impulse_y: float = -96.0
		grabbed_object.setImpulse( Vector2( impulse_x, impulse_y ), true )
		playHandsAnimation("throw")
	ungrabObject()

func setGrabbed() -> void:
	var to_state: State = $"node_state_machine/grabbed"
	var to_substate: State = $"node_substate_machine/none"
	states_machine.current_state.next_state = to_state
	sub_states_machine.current_state.next_state = to_substate
	velocity = Vector2.ZERO
	
func setUngrabbed() -> void:
	var to_state: State = $"node_state_machine/air"
	states_machine.current_state.next_state = to_state
	_updateScaleDirection()

func applyGravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func setImpulse(impulse: Vector2, override: bool = false) -> void:
	if states_machine.current_state == $"node_state_machine/grabbed" and override == false: return
	velocity = impulse
#endregion

func _onOverlapBodyEntered(body: Node2D) -> void:
	if states_machine.current_state != $"node_state_machine/grabbed":
		doDeath()
