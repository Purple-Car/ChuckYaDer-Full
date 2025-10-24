extends Node2D

signal updateKeyMapButton

func _ready() -> void:
	pass

func _onButtonResetPressed() -> void:
	MasterTracker.resetKeyMap()

func _onButtonBackPressed() -> void:
	Gamestate.setNextScene("res://menus/title/scene_menus_title.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)
