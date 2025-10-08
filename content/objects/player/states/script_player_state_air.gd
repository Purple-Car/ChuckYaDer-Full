extends State

@export var ground_state: State

func stateProcess(delta):
	if player.is_on_floor():
		next_state = ground_state
	
	player.applyGravity(delta)
	_handleAirAnimation()

func _handleAirAnimation() -> void:
	if player.velocity.y < 0:
		player.playBodyAnimation("jump")
	elif player.getBodyAnimation() != "peak" and player.getBodyAnimation() != "fall":
		player.playBodyAnimation("peak")

func onAnimationFinished(finished_animation: String) -> void:
	if finished_animation == "peak":
		player.playBodyAnimation("fall")
