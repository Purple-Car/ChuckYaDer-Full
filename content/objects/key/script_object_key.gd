extends CharacterBody2D

const DECELERATION: float = 4
const MAX_FALL_SPEED: float = 186.0

var weight: float = 1.2
var is_grabbed: bool = false

@onready var collision: CollisionShape2D = $colshape_collision
@onready var sprite : Sprite2D = $spr2D_sprite
@onready var overlap_area: Area2D = $area2D_overlap

func _physics_process(delta: float) -> void:
	if !is_grabbed:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * weight)
		_applyGravity(delta)
		if !is_on_floor():
			_checkBonking()
	move_and_slide()

func _applyGravity(delta: float) -> void:
	velocity += get_gravity() * weight * delta
		
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

func _checkBonking() -> void:
	if overlap_area.has_overlapping_bodies() == true:
		setImpulse( Vector2( velocity.x, -50 ))

func setGrabbed() -> void:
	setImpulse(Vector2.ZERO)
	collision.call_deferred("set_disabled", true)
	is_grabbed = true

func setUngrabbed() -> void:
	collision.call_deferred("set_disabled", false)
	is_grabbed = false

func setImpulse(impulse: Vector2, override: bool = false) -> void:
	if is_grabbed and override == false: return
	velocity = impulse

func getIsGrabbed() -> bool:
	if is_grabbed: return true
	return false

func beConsumed() -> void:
	Utils.spawnSparkle(global_position, get_tree().current_scene.find_child("node_statics", true, false),Vector2(0, -20))
	queue_free()

func _onBodyEntered(body: Node2D) -> void:
	if is_grabbed or is_on_floor(): return 
	var direction_x: float = (global_position - body.global_position).normalized().x
	setImpulse( Vector2( direction_x * velocity.x, -60 ))
