extends Node2D

@export var backgrounds: Array[Node2D] = [null, null, null]

@onready var button_continue: Button = $node_control/container_menu/button_continue
@onready var canmod: CanvasModulate = $canmod

func _ready() -> void:
	if MasterTracker.checkForSave():
		button_continue.disabled = false
	
	if MasterTracker.current_stage > 5:
		backgrounds[2].show()
		canmod. color = "d4c2f6"
	elif MasterTracker.current_stage > 2:
		backgrounds[1].show()
		canmod.color = "f9babb"
	else:
		backgrounds[0].show()

func _onButtonNewgamePressed() -> void:
	MasterTracker.resetData()
	Gamestate.setNextScene("res://menus/color_select/scene_menus_colorsel.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)

func _onButtonContinuePressed() -> void:
	if MasterTracker.current_stage == 9:
		Gamestate.setNextScene("res://stages/stage_misc/scene_stage_select.tscn")
	else:
		Gamestate.setNextScene("res://menus/level_title/scene_level_title.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)

func _onButtonOptionsPressed() -> void:
	Gamestate.setNextScene("res://menus/options/scene_menus_options.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)

func _onButtonQuitPressed() -> void:
	get_tree().quit()
