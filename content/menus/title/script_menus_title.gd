extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _onButtonQuitPressed() -> void:
	get_tree().quit()


func _onButtonNewgamePressed() -> void:
	Gamestate.setNextScene("res://stages/stage_1/scene_stage_1_area_1.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)
	
