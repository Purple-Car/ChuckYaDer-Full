extends AnimatableBody2D

@export var platform_id: int
@export var collision: CollisionShape2D
@export var speed: float
@export var target_position: Vector2
@export var nine_patch: NinePatchRect

var initial_position: Vector2
var active: bool = false
var color: Color = MasterTracker.COLORS["red"]

@onready var texture: Control = $"control_texture"

func _ready() -> void:
	initial_position = global_position
	
	var rect_shape: RectangleShape2D = collision.shape as RectangleShape2D
	texture.custom_minimum_size = rect_shape.extents * 2

func _physics_process(delta: float) -> void:
	active = false
	for button in get_tree().get_nodes_in_group("button"):
		if button.platform_id == platform_id and button.active:
			active = true
	
	var destination: Vector2
	if active:
		destination = target_position
		changeColor(color)
	else:
		destination = initial_position
		changeColor(color * 0.6)
	
	if global_position != destination:
		var step: float = speed * delta
		if global_position.distance_to(destination) <= step:
			global_position = destination
		else:
			global_position = global_position.move_toward(destination, step)

func getPlatformId() -> int:
	return platform_id

func setColor(to_color: Color) -> void:
	color = to_color
	nine_patch.material = nine_patch.material.duplicate()
	nine_patch.material.set("shader_parameter/new_color", color * 0.6)

func changeColor(to_color: Color) -> void:
	if nine_patch.material.get("shader_parameter/new_color") != to_color:
		nine_patch.material.set("shader_parameter/new_color", to_color)
