extends Node2D

@onready var button_continue: Button = $node_control/container_menu/button_continue

func _ready() -> void:
	if MasterTracker.checkForSave():
		button_continue.disabled = false

func _onButtonNewgamePressed() -> void:
	MasterTracker.resetData()
	Gamestate.setNextScene("res://menus/color_select/scene_menus_colorsel.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)

func _onButtonContinuePressed() -> void:
	Gamestate.setNextScene("res://menus/level_title/scene_level_title.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)
	# PLACEHOLDER
	#var current_stage: String = str(MasterTracker.current_stage + 1)
	#var resume_stage_path: String = "res://stages/stage_%s/scene_stage_%s_area_1.tscn" % [current_stage, current_stage]
	#Gamestate.setNextScene(resume_stage_path)
	#Gamestate.changeState(Gamestate.States.fadeout)

func _onButtonOptionsPressed() -> void:
	Gamestate.setNextScene("res://menus/options/scene_menus_options.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)

func _onButtonQuitPressed() -> void:
	get_tree().quit()
