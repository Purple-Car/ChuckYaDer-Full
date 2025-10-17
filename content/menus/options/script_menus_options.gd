extends Node2D

func _ready() -> void:
	pass

func _onButtonResetPressed() -> void:
	pass

func _onButtonBackPressed() -> void:
	Gamestate.setNextScene("res://menus/title/scene_menus_title.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)
