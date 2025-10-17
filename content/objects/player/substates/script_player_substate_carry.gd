extends State

@export var throw_state: State

func subStateInput(event: InputEvent) -> void:
	if event is InputEventMouseMotion or player.getBodyAnimation() == "struggle" or player.grab_area.position.y < 14: return
	
	if event.is_action_pressed("p%s_grab" % player.getPlayerNumber()):
		next_state = throw_state
		player.throwObject()

func onGrabDetectSomething(body: Node2D): pass

func onAnimationFinished(finished_animation: String) -> void:
	if finished_animation == "carry":
		player.grabbed_object.position = Vector2(0, -4)
