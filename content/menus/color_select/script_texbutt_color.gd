extends TextureButton

@export var color: String
@export var index: Vector2

func _ready() -> void:
	material = material.duplicate()
	material.set("shader_parameter/new_color", MasterTracker.COLORS[color])

func _process(delta: float) -> void:
	pass
