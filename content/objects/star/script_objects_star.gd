extends Node2D

var to_scene: String = "res://menus/ending_screen/scene_ending_screen.tscn"

@onready var shaker: AnimationPlayer = $aniplr_shake
@onready var overlap: Area2D = $area2D_overlap

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if overlap.has_overlapping_bodies():
		shaker.play("shake")
		if overlap.get_overlapping_bodies().size() == 2:
			Gamestate.setNextScene(to_scene)
			Gamestate.changeState(Gamestate.States.fadeout)
	else:
		shaker.play("RESET")
