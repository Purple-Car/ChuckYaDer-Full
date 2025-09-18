extends State

func stateProcess(delta):
	_handleGrabbedAnimation()

func _handleGrabbedAnimation() -> void:
	if player.getBodyAnimation() != "struggle":
		player.playBodyAnimation("struggle")
