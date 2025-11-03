extends CharacterBody2D

@export var initial_state: String
@export var start_flipped: bool = false

const DECELERATION: float = 4
const MAX_FALL_SPEED: float = 192.0

var _death_effect: PackedScene = preload("res://effects/enemy_death/scene_enemy_death.tscn")
var weight: float = 1.1
var is_grabbed: bool = false

@onready var collision: CollisionShape2D = $colshape_collision
@onready var sprite: AnimatedSprite2D = $anisprite_sprite
@onready var overlap_area: Area2D = $area2D_overlap

func _ready() -> void:
	if start_flipped:
		sprite.flip_h = true

func _physics_process(delta: float) -> void:
	if !is_grabbed:
		_updateScaleDirection()
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

func _updateScaleDirection() -> void:
	scale = Vector2(1.0, 1.0)
	rotation = 0

func setGrabbed() -> void:
	setImpulse(Vector2.ZERO)
	collision.call_deferred("set_disabled", true)
	is_grabbed = true
	setCollidingWithPlayer(false)

func setUngrabbed() -> void:
	collision.call_deferred("set_disabled", false)
	is_grabbed = false
	setCollidingWithPlayer(true)

func setImpulse(impulse: Vector2, override: bool = false) -> void:
	if is_grabbed and override == false: return
	velocity = impulse

func getIsGrabbed() -> bool:
	if is_grabbed: return true
	return false

func playAnimation(to_animation: String) -> void:
	if sprite:
		sprite.play(to_animation)

func getAnimation() -> String:
	return sprite.animation

func setCollidingWithPlayer(to_set: bool):
	if overlap_area.get_collision_layer_value(8) == to_set: return
	overlap_area.set_collision_layer_value(8, to_set)

func doDeath() -> void:
	var death_effect = _death_effect.instantiate()
	get_parent().add_child(death_effect)
	death_effect.position = position
	death_effect.animated_sprite.flip_h = sprite.flip_h
	queue_free()

func _onAreaEntered(area: Area2D) -> void:
	if is_grabbed: return
	if area.get_parent().is_in_group("enemy"): return
	doDeath()

func _onBodyEntered(body: Node2D) -> void:
	if is_grabbed: return
	doDeath()
