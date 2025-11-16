extends CharacterBody2D

const DECELERATION: float = 4
const MAX_FALL_SPEED: float = 186.0

var _explosion_effect: PackedScene = preload("res://effects/explosion/scene_bomb_explosion.tscn")
var weight: float = 1
var is_grabbed: bool = false
var is_ignited: bool = false

@onready var collision: CollisionShape2D = $colshape_collision
@onready var sprite : AnimatedSprite2D = $anisprite_sprite
@onready var overlap_area: Area2D = $area2D_overlap

func _physics_process(delta: float) -> void:
	if !is_grabbed:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * weight)
		_applyGravity(delta)
	move_and_slide()
	if is_ignited and !is_grabbed:
		_checkBlowUp()

func _applyGravity(delta: float) -> void:
	velocity += get_gravity() * weight * delta
		
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

func _checkBlowUp() -> void:
	if is_on_ceiling() or is_on_floor() or is_on_wall():
		blowUp()

func setGrabbed() -> void:
	setImpulse(Vector2.ZERO)
	collision.call_deferred("set_disabled", true)
	is_grabbed = true
	sprite.play("activated")
	is_ignited = true

func setUngrabbed() -> void:
	collision.call_deferred("set_disabled", false)
	is_grabbed = false

func setImpulse(impulse: Vector2, override: bool = false) -> void:
	if is_grabbed and override == false: return
	velocity = impulse

func getIsGrabbed() -> bool:
	if is_grabbed: return true
	return false

func blowUp() -> void:
	var explosion_effect = _explosion_effect.instantiate()
	get_parent().add_child(explosion_effect)
	explosion_effect.position = position
	explosion_effect.name = "node_explosion_root"
	queue_free()

func _onBodyEntered(body: Node2D) -> void:
	if is_ignited and !is_grabbed:
		call_deferred("blowUp")
