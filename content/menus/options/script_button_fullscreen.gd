extends CheckBox

func _process(_delta: float) -> void:
	var window = get_tree().root
	set_pressed_no_signal(window.mode == Window.MODE_FULLSCREEN)

func _onToggled(_toggled_on: bool) -> void:
	Utils.toggleFullscreen()
