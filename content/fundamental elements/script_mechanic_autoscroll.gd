extends Node2D

const ACCELERATION: float = 10.0

@export var bounds: StaticBody2D
@export var camera: Camera2D
@export var max_speed: float = 25.0

var current_point: int = 0
var points: Array[Node2D] = []
var speed: float = 0

var RATIOS: Dictionary = {
	1.0: 1.0,
	2.0: 1.2,
	3.0: 1.5,
	4.0: 2.0,
	5.0: 3.0,
	6.0: 6.0
}

func _ready() -> void:
	for child in get_children():
		if child is Node2D:
			points.append(child)
	var to_scale = RATIOS[camera.scale_multiplier + 1]
	bounds.scale = Vector2(to_scale, to_scale) 

func _process(delta: float) -> void:
	_cameraMove(delta)
	
func _cameraMove(delta: float) -> void:
	speed = move_toward(speed, max_speed, ACCELERATION * delta)
	
	if current_point == points.size(): return
	
	var destination: Vector2 = points[current_point].global_position
	
	if camera.global_position != destination:
		var step: float = speed * delta
		if camera.global_position.distance_to(destination) <= step:
			camera.global_position = destination
		else:
			camera.global_position = camera.global_position.move_toward(destination, step)
	else:
		current_point += 1
