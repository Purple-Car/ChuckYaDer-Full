extends CharacterBody2D

const SPEED: float = 84.0
const JUMP_VELOCITY: float = -60.0
const MAX_FALL_SPEED: float = 192.0

enum States { idle, walk, crouch, jump, fall, grabbed }
enum Sub_States { grab, carry, throw }

var _death_effect: PackedScene = preload("res://effects/player_death/scene_player_death.tscn")
var is_flipped: bool = false
var direction_y: float
var direction_x: float
var player_num: int = 1

@onready var states_mahcine: PlayerStateMachine = $node_state_machine
@onready var sprites_node: Node2D = $node2D_sprites
@onready var hands_player: AnimationPlayer = $anipl_hands
@onready var body_player: AnimatedSprite2D = $node2D_sprites/anisprite_body
@onready var overlap_col: Area2D = $area2D_overlap

signal onPlayerDestroyed

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_handleGravity(delta)
	_directionalMovement()
	_changeFacingDirection()
	move_and_slide()

#region privates
func _handleGravity(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():	
		velocity += get_gravity() * delta

func _changeFacingDirection() -> void:
	
	if velocity.x > 0 and is_flipped == false:
		is_flipped = true
	elif velocity.x < 0 and is_flipped == true:
		is_flipped = false
	else:
		return
	sprites_node.scale = Vector2(1 + (-2.0 * int(is_flipped)), 1.0)

func _directionalMovement() -> void:
	# Checks if player is holding left or right
	direction_x = Input.get_axis("p%s_left" % getPlayerNumber(), "p%s_right" % getPlayerNumber())
	if direction_x and states_mahcine.getCanMove():
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
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
	queue_free()

func getBodyAnimation() -> String:
	return body_player.animation

func getHandsAnimation() -> String:
	return hands_player.assigned_animation 

func getPlayerNumber() -> int:
	return player_num
#endregion

func _onOverlapBodyEntered(body: Node2D) -> void:
	doDeath()
