extends State

@export var none_state: State

func subStateInput(event: InputEvent) -> void: pass

func onGrabDetectSomething(body: Node2D): pass

func onAnimationFinished(finished_animation: String) -> void:
	if finished_animation == "throw":
		next_state = none_state
