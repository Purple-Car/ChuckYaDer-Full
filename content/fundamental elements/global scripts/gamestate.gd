extends Node

enum States { fadein, fadeout, gameplay, pause, wait }

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		get_tree().paused = !get_tree().paused
		print("PAUSE")

func changeState(to_state: int) -> void:
	
	pass
