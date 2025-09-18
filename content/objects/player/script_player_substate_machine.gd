extends Node

class_name PlayerSubstateMachine

var sub_states: Array[State]

@export var current_state: State
@export var player: CharacterBody2D

func _ready() -> void:
	for child in get_children():
		if child is State:
			sub_states.append(child)
			
			# Set up states
			child.player = player
		else:
			push_warning("Child %s is not a State" % child)

func _physics_process(delta: float) -> void:
	if current_state.next_state != null:
		switchState(current_state.next_state)
		
	current_state.stateProcess(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switchState(next_state: State):
	if current_state != null:
		current_state.onExit()
		current_state.next_state = null
	
	current_state = next_state
	current_state.onEnter()

func _input(event: InputEvent) -> void:
	current_state.subStateInput(event)

func _onHandAnimationFinished(anim_name: StringName) -> void:
	current_state.onAnimationFinished(player.getHandsAnimation())

func _onGrabBodyEntered(body: Node2D) -> void:
	current_state.onGrabDetectSomething(body)
