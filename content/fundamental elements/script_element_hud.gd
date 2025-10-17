extends Control

@onready var menu_player: AnimationPlayer = $anipl_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	get_tree().reload_current_scene()

func _onBackPressed() -> void:
	pass # Replace with function body.

func _onQuitPressed() -> void:
	get_tree().quit()

func _onPauseIconPressed() -> void:
	toggleMenu()
