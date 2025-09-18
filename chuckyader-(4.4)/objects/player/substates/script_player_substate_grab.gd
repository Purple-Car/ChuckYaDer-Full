extends State

@export var none_state: State
@export var carry_state: State

func subStateInput(event: InputEvent) -> void: pass

func onAnimationFinished(finished_animation: String) -> void:
	if finished_animation == "grab":
		next_state = none_state

func onGrabDetectSomething(body: Node2D) -> void:
	var body_name: String = "charbody_player_%s" % player.player_num
	
	if body.is_in_group("grabbable") and body.name != body_name:
		print(body.name)
		next_state = carry_state
