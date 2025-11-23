extends CharacterBody2D
class_name Player

const SPEED: float = 84.0
const JUMP_VELOCITY: float = -60.0
const MAX_FALL_SPEED: float = 192.0
const DECELERATION: float = 4
enum States { idle, walk, crouch, jump, fall, grabbed }
enum Sub_States { grab, carry, throw }

var _death_effect: PackedScene = preload("res://effects/player_death/scene_player_death.tscn")
var _ghost_object: PackedScene = preload("res://effects/ghost/scene_player_ghost.tscn")
var is_flipped: bool = false
var direction_y: float
var direction_x: float
var player_num: int = 1
var grabbed_object: Object
var weight = 1.3
var ghostable: bool = false

var walk_velocity: Vector2
var grav_velocity: Vector2

@onready var states_machine: PlayerStateMachine = $node_state_machine
@onready var sub_states_machine: PlayerSubstateMachine = $node_substate_machine
@onready var sprites_node: Node2D = $node2D_sprites
@onready var hands_player: AnimationPlayer = $anipl_hands
@onready var body_player: AnimatedSprite2D = $node2D_sprites/anisprite_body
@onready var overlap_col: Area2D = $area2D_overlap
@onready var grab_area: Area2D = $node2D_sprites/area2D_grab
@onready var scarf_player: AnimatedSprite2D = $node2D_sprites/anisprite_scarf
@onready var collision: CollisionShape2D = $colshape_collision

signal onPlayerDestroyed

func _ready() -> void: pass

func _process(_delta: float) -> void:
	var carry_state: State = $"node_substate_machine/carry"
	if grabbed_object == null and sub_states_machine.current_state == carry_state:
		var to_substate: State = $"node_substate_machine/none"
		sub_states_machine.current_state.next_state = to_substate

func _physics_process(_delta: float) -> void:
	_directionalMovement()
	_changeFacingDirection()
	_mergeVelocities()
	move_and_slide()
	_hitHeadOrFoot()
	_handleScarfAnimation()

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

func _handleScarfAnimation() -> void:
	var to_play: String
	if velocity.y > 0:
		to_play = "down"
	elif velocity.y < 0:
		to_play = "up"
	elif velocity.x != 0:
		to_play = "side"
	else:
		to_play = "stop"
	if to_play and to_play != scarf_player.animation:
		scarf_player.play(to_play)

func _directionalMovement() -> void:
	var weighted_speed: float = SPEED
	if grabbed_object:
		weighted_speed = SPEED / grabbed_object.weight
	
	direction_x = Input.get_axis("p%s_left" % getPlayerNumber(), "p%s_right" % getPlayerNumber())
	if direction_x and states_machine.getCanMove() and abs(velocity.x) <= weighted_speed+1:
		walk_velocity = Vector2(direction_x * weighted_speed, 0)
	else:
		walk_velocity = Vector2.ZERO

func _mergeVelocities() -> void:
	grav_velocity = Vector2(move_toward(grav_velocity.x, 0, DECELERATION), grav_velocity.y)
	
	if getIsGrabbed(): 
		velocity = Vector2.ZERO
	else:
		velocity = walk_velocity + grav_velocity

func _hitHeadOrFoot() -> void:
	if is_on_ceiling() and grav_velocity.y < 0:
		grav_velocity.y = 0
	if is_on_floor() and grav_velocity.y > 0:
		grav_velocity.y = 0
	if is_on_wall() and abs(grav_velocity.x) > 0:
		grav_velocity.x = 0

func _spawnGhost() -> void:
	var ghost_object = _ghost_object.instantiate()
	get_parent().add_child(ghost_object)
	ghost_object.position = position
	ghost_object.setupColor(player_num)
#endregion

#region publics
func playBodyAnimation(next_animation: String = "") -> void:
	if next_animation == "": 
		body_player.play()
		return

	if getBodyAnimation() != next_animation:
		body_player.play(next_animation)
	updateSpriteSpeedScale()

func playHandsAnimation(next_animation: String = "") -> void:
	if next_animation == "": 
		hands_player.play()
		return

	if getHandsAnimation() != next_animation:
		hands_player.play(next_animation)

func doDeath() -> void:
	onPlayerDestroyed.emit()
	var death_effect = _death_effect.instantiate()
	get_parent().add_child(death_effect)
	death_effect.position = position
	death_effect.setupColor(player_num)
	death_effect.scale = Vector2( Utils.boolToSign(is_flipped), 1)
	
	if grabbed_object:
		grabbed_object.setUngrabbed()
		ungrabObject()
	
	if ghostable:
		call_deferred("_spawnGhost")
	
	MasterTracker.incrementDeath(player_num)
	call_deferred("queue_free")

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
	setGrabbedObject(null)

func throwObject() -> void:
	if grabbed_object.get("originator"):
		grabbed_object.originator = self
	grabbed_object.setUngrabbed()
	var impulse_x: float = -192 * sign(Utils.boolToSign(is_flipped))
	var impulse_y: float = -96.0
	grabbed_object.setImpulse( Vector2( impulse_x, impulse_y ), true )
	playHandsAnimation("throw")
	ungrabObject()

func setGrabbed() -> void:
	if grabbed_object:
		grabbed_object.setUngrabbed()
		ungrabObject()

	var to_state: State = $"node_state_machine/grabbed"
	var to_substate: State = $"node_substate_machine/none"
	#collision.disabled = true
	collision.call_deferred("set_disabled", true)
	states_machine.current_state.next_state = to_state
	sub_states_machine.current_state.next_state = to_substate
	velocity = Vector2.ZERO
	
func setUngrabbed() -> void:
	var to_state: State = $"node_state_machine/air"
	#collision.disabled = false
	collision.call_deferred("set_disabled", false)
	states_machine.current_state.next_state = to_state
	_updateScaleDirection()

func applyGravity(delta: float) -> void:
	if not is_on_floor():
		grav_velocity += get_gravity() * delta
		grav_velocity.y = min(grav_velocity.y, MAX_FALL_SPEED)

func setImpulse(impulse: Vector2, override: bool = false) -> void:
	if states_machine.current_state == $"node_state_machine/grabbed" and override == false: return
	grav_velocity = impulse

func addImpulse(impulse: Vector2, override: bool = false) -> void:
	if states_machine.current_state == $"node_state_machine/grabbed" and override == false: return
	grav_velocity += impulse

func getIsGrabbed() -> bool:
	if states_machine.current_state == $"node_state_machine/grabbed": return true
	return false

func updateSpriteSpeedScale() -> void:
	if grabbed_object:
		body_player.speed_scale = 1 / grabbed_object.weight
	else:
		body_player.speed_scale = 1

func updateColor() -> void:
	material = material.duplicate()
	material.set("shader_parameter/new_color", MasterTracker.player_colors[player_num - 1])
#endregion

func _onOverlapBodyEntered(body: Node2D) -> void:
	if states_machine.current_state != $"node_state_machine/grabbed":
		doDeath()

func _onAreaEntered(area: Area2D) -> void:
	if states_machine.current_state != $"node_state_machine/grabbed":
		doDeath()


func _onExitedScreen() -> void:
	doDeath()
