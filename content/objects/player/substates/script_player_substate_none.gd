extends State

@export var grab_state: State

func stateProcess(delta):
	_handleAnimation()

func _handleAnimation() -> void:
	player.playHandsAnimation(player.getBodyAnimation())

func subStateInput(event: InputEvent) -> void:
	if event is InputEventMouseMotion or player.getBodyAnimation() == "struggle": return
	
	if event.is_action_pressed("p%s_grab" % player.getPlayerNumber()):
		next_state = grab_state
		player.grab_area.monitoring = false
		player.grab_area.monitoring = true
		player.playHandsAnimation("grab")

func onGrabDetectSomething(body: Node2D): pass
