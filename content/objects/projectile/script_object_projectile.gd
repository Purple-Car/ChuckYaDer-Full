extends Node2D

const SPEED: float = 80.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta

func _onAreaEntered(area: Area2D) -> void:
	queue_free()

func _onBodyEntered(body: Node2D) -> void:
	queue_free()
