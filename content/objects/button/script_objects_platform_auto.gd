extends AnimatableBody2D

@export var platform_id: int
@export var collision: CollisionShape2D
@export var speed: float
@export var target_position: Vector2
@export var nine_patch: NinePatchRect
@export_enum("red", "orange", "yellow", "green", "cyan", "blue", "purple", "violet", "pink", "magenta") var color_name: String = "red"

var initial_position: Vector2

@onready var texture: Control = $"control_texture"

func _ready() -> void:
	initial_position = global_position
	
	var to_color: Color = MasterTracker.COLORS[color_name]
	setColor(to_color)
	
	var rect_shape: RectangleShape2D = collision.shape as RectangleShape2D
	texture.custom_minimum_size = rect_shape.extents * 2

func _physics_process(delta: float) -> void:
	var destination = target_position
	
	if global_position != destination:
		var step: float = speed * delta
		if global_position.distance_to(destination) <= step:
			global_position = destination
		else:
			global_position = global_position.move_toward(destination, step)

func getPlatformId() -> int:
	return platform_id

func setColor(to_color: Color) -> void:
	nine_patch.material = nine_patch.material.duplicate()
	nine_patch.material.set("shader_parameter/new_color", to_color)
