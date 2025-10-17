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
	Gamestate.setNextScene("E:/Godot/ChuckYaDer-Full/content/menus/color_select/scene_menus_colorsel.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)

func _onButtonOptionsPressed() -> void:
	Gamestate.setNextScene("res://menus/options/scene_menus_options.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)
