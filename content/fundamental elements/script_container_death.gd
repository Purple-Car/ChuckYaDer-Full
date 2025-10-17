extends HBoxContainer

@export var player_num: int

@onready var icon: TextureRect = $icon_death
@onready var label: Label = $label_death

func _ready() -> void:
	show()
	icon.material = icon.material.duplicate()
	icon.material.set("shader_parameter/new_color", MasterTracker.player_colors[player_num - 1])
	MasterTracker.updateDeathTracker.connect(updateDeathTracker)
	updateDeathTracker()

func _process(delta: float) -> void:
	pass

func updateDeathTracker() -> void:
	label.text = str(MasterTracker.player_deaths[player_num - 1])
