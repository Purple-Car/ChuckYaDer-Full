extends CharacterBody2D

const DECELERATION: float = 4
const MAX_FALL_SPEED: float = 192.0
const BREAK_SPEED: float = 180.0

@export var info: GrabbableContainer
@export var contains: PackedScene

var weight: float
var resistance: int
var is_grabbed: bool = false

@onready var sprite : Sprite2D = $spr2D_sprite
@onready var collision: CollisionShape2D = $colshape_collision
@onready var overlap: CollisionShape2D = $area2D_overlap/colshape_overlap
@onready var overlap_area: Area2D = $area2D_overlap
@onready var wrapbounds: CollisionShape2D = $colshape_wrapbounds

func _ready() -> void:
	sprite.texture = info.texture
	weight = 1 + info.weight/10
	resistance = info.resistance
	
	collision.shape = collision.shape.duplicate()
	overlap.shape = overlap.shape.duplicate()
	wrapbounds.shape = wrapbounds.shape.duplicate()
	
	collision.shape.extents = info.hitbox_size
	overlap.shape.extents = info.hitbox_size
	wrapbounds.shape.extents = info.hitbox_size
	
	sprite.position.y = 8 - info.hitbox_size.y
	collision.position.y = 8 - info.hitbox_size.y
	overlap_area.position.y = 8 - info.hitbox_size.y
	wrapbounds.position.y = 8 - info.hitbox_size.y

func _physics_process(delta: float) -> void:
	if !is_grabbed:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * weight)
		if is_on_floor():
			setCollidingWithPlayer(true)
		else:
			setCollidingWithPlayer(false)
			_applyGravity(delta)
			_checkBonking()
	var heading_velocity: Vector2 = velocity
	move_and_slide()
	if resistance < 1:
		_checkBreak(heading_velocity)

func _applyGravity(delta: float) -> void:
	velocity += get_gravity() * weight * delta
	
	if velocity.y > MAX_FALL_SPEED * weight:
		velocity.y = MAX_FALL_SPEED * weight

func _checkBonking() -> void:
	if overlap_area.has_overlapping_bodies() == true:
		setImpulse( Vector2( velocity.x, -50 ))

func _checkBreak(heading_velocity: Vector2) -> void:
	var heading_speed = abs(heading_velocity.length())
	if heading_speed > BREAK_SPEED:
		if is_on_floor() or is_on_ceiling() or is_on_wall():
			doBreak()

func setGrabbed() -> void:
	setImpulse(Vector2.ZERO)
	setCollidingWithPlayer(false)
	collision.call_deferred("set_disabled", true)
	is_grabbed = true

func setUngrabbed() -> void:
	collision.call_deferred("set_disabled", false)
	is_grabbed = false

func setCollidingWithPlayer(to_set: bool):
	if get_collision_layer_value(5) == to_set: return
	set_collision_layer_value(5, to_set)

func setImpulse(impulse: Vector2, override: bool = false) -> void:
	if is_grabbed and override == false: return
	velocity = impulse

func getIsGrabbed() -> bool:
	if is_grabbed: return true
	return false

func doBreak() -> void:
	if contains:
		var spawn_thing = contains.instantiate()
		get_parent().get_parent().get_node("node_grabbables").add_child(spawn_thing)
		spawn_thing.global_position = global_position
		spawn_thing.name = "node_container_item_root"
		spawn_thing.setImpulse( Vector2( velocity.x, -50 ))
	
	Utils.explode_texture(info.texture, global_position + Vector2(8, 8))
	queue_free()

func _onBodyEntered(body: Node2D) -> void:
	if is_grabbed or is_on_floor(): return 
	
	if body.is_in_group("enemy"):
		body.doDeath()
	
	var direction_x: float = (global_position - body.global_position).normalized().x
	setImpulse( Vector2( direction_x * velocity.x, -60 ))

func _onAreaEntered(area: Area2D) -> void:
	if area.get_parent().is_in_group("explosion") and resistance < 2:
		doBreak()
