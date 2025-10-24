extends Control

@onready var menu_player: AnimationPlayer = $anipl_menu

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		toggleMenu()

func toggleMenu() -> void:
	if Gamestate.game_state == Gamestate.States.pause:
		menu_player.play("out")
		Gamestate.changeState(Gamestate.States.gameplay)
	elif Gamestate.game_state == Gamestate.States.gameplay:
		menu_player.play("in")
		Gamestate.changeState(Gamestate.States.pause)

func _onResumePressed() -> void:
	toggleMenu()

func _onResetPressed() -> void:
	MasterTracker.incrementDeath(1)
	MasterTracker.incrementDeath(2)
	get_tree().reload_current_scene()

func _onBackPressed() -> void:
	Gamestate.setNextScene("res://menus/title/scene_menus_title.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)

func _onQuitPressed() -> void:
	get_tree().quit()

func _onPauseIconPressed() -> void:
	toggleMenu()
