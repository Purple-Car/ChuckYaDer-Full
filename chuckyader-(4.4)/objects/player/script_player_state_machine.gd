extends Node

class_name PlayerStateMachine

var states: Array[State]

@export var current_state: State
@export var player: CharacterBody2D

func _ready() -> void:
	for child in get_children():
		if child is State:
			states.append(child)
			
			# Set up states
			child.player = player
		else:
			push_warning("Child %s is not a State" % child)

func _physics_process(delta: float) -> void:
	if current_state.next_state != null:
		switchState(current_state.next_state)
		
	current_state.stateProcess(delta)

func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	current_state.stateInput(event)

func switchState(next_state: State):
	if current_state != null:
		current_state.onExit()
		current_state.next_state = null
	
	current_state = next_state
	current_state.onEnter()

func getCanMove() -> bool:
	return current_state.can_move

func _onBodyAnimationFinished() -> void:
	current_state.onAnimationFinished(player.getBodyAnimation())
