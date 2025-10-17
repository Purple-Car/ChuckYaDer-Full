extends State

@export var air_state: State

func onEnter(): 
	if player.velocity.x != 0:
		player.playBodyAnimation("run")
	else:
		player.playBodyAnimation("uncrouch")

func stateProcess(delta):
	if !player.is_on_floor():
		next_state = air_state
	
	can_move = _checkIfCanMove()
	if can_move: _handleRunAnimation()

#region Privates
func _checkIfCanMove() -> bool:
	if player.getBodyAnimation() != "idle" and player.getBodyAnimation() != "run":
		return false
	else:
		return true

func _handleRunAnimation() -> void:
	if player.velocity.x != 0:
		player.playBodyAnimation("run")
		player.updateSpriteSpeedScale()
	else:
		player.playBodyAnimation("idle")
#endregion

#region Publics
func stateInput(event: InputEvent) -> void:
	if event is InputEventMouseMotion: return
	
	if event.is_pressed():
		if event.is_action_pressed("p%s_down" % player.getPlayerNumber()):
			player.playBodyAnimation("crouch")
		elif event.is_action_pressed("p%s_up" % player.getPlayerNumber()):
			player.playBodyAnimation("look")

	elif event.is_released():
		if event.is_action_released("p%s_down" % player.getPlayerNumber()):
			player.playBodyAnimation("uncrouch")
		elif event.is_action_released("p%s_up" % player.getPlayerNumber()):
			player.playBodyAnimation("unlook")

func onAnimationFinished(finished_animation: String) -> void:
	if finished_animation == "uncrouch" or finished_animation == "unlook" :
		player.playBodyAnimation("idle")
#endregion
