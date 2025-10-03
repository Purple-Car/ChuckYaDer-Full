extends Node

enum States { fadein, fadeout, gameplay, pause, wait }

var game_state: States = States.fadein
var next_scene: String

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("menu"):
		#get_tree().paused = !get_tree().paused
		#print("PAUSE")

signal call_fade

func changeState(to_state: States) -> void:
	game_state = to_state
	
	match to_state:
		States.fadein:
			get_tree().paused = true
			call_fade.emit("fade_in")
		States.fadeout:
			get_tree().paused = true
			call_fade.emit("fade_out")
		States.gameplay:
			get_tree().paused = false
		States.pause:
			get_tree().paused = true
		States.wait:
			get_tree().paused = true

func fadeFinished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		changeState(States.gameplay)
	elif anim_name == "fade_out":
		get_tree().change_scene_to_file(next_scene)
		changeState(States.fadein)

func setNextScene(to_scene: String) -> void:
	next_scene = to_scene
