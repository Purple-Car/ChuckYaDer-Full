extends AnimatableBody2D

@export var platform_ids: Array[int]
@export var collision: CollisionShape2D
@export var speed: float
@export var sprite: Sprite2D

var initial_position: Vector2
var active: bool = false
var color: Array[Color] = [MasterTracker.COLORS["red"], MasterTracker.COLORS["blue"]]
var target_position: Vector2

func _ready() -> void:
	initial_position = global_position

func _physics_process(delta: float) -> void:
	for button in get_tree().get_nodes_in_group("button"):
		if button.platform_id == platform_ids[0]:
			if button.active:
				if !active: active = true
				target_position.y = global_position.y - 16
				changeColor(color[0], 1)
			else:
				target_position.y = global_position.y + 16
				changeColor(color[0] * 0.6, 1)
			
		elif button.platform_id == platform_ids[1]:
			if button.active:
				if !active: active = true
				target_position.x = global_position.x + 16
				changeColor(color[1], 2)
			else:
				target_position.x = max(initial_position.x, global_position.x - 16)
				changeColor(color[1] * 0.6, 2)
	
	var destination: Vector2
	if active:
		destination = target_position
	else:
		destination = initial_position
	
	if global_position != destination:
		var step: float = speed * delta
		if global_position.distance_to(destination) <= step:
			global_position = destination
		else:
			global_position = global_position.move_toward(destination, step)

func getPlatformId() -> int:
	return platform_ids[0]

func setColor(to_color: Color) -> void:
	sprite.material = sprite.material.duplicate()
	changeColor(color[0] * 0.6, 1)
	changeColor(color[1] * 0.6, 2)

func changeColor(to_color: Color, id: int) -> void:
	if sprite.material.get("shader_parameter/new_color_"+str(id)) != to_color:
		sprite.material.set("shader_parameter/new_color_"+str(id), to_color)

func _spawnAfterImage() -> void:
	var sprite_tex: Texture2D = sprite.texture
	
	Utils.spawnAfterImage(sprite_tex, sprite.global_position, get_parent(), false, z_index)

func _onTimeout() -> void:
	_spawnAfterImage()
