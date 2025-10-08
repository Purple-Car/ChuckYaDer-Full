extends RigidBody2D

@export var info: GrabbableContainer

var weight: int
var resistance: int

@onready var sprite : Sprite2D = $spr2D_sprite
@onready var collision: CollisionShape2D = $colshape_collision

func _ready() -> void:
	sprite.texture = info.texture
	weight = info.weight
	resistance = info.resistance
	collision.shape.extents = info.hitbox_size
	
	mass = weight

func setGrabbed() -> void:
	set_axis_velocity(Vector2(0, 0))
	call_deferred("set_freeze_enabled", true)
	collision.call_deferred("set_disabled", true)

func setUngrabbed() -> void:
	if scale.y == -1.0:
		scale.y = 1.0
		rotation = 0
	call_deferred("set_freeze_enabled", false)
	collision.call_deferred("set_disabled", false)

func setImpulse(impulse: Vector2, override: bool = false) -> void:
	call_deferred("apply_central_impulse", impulse)
