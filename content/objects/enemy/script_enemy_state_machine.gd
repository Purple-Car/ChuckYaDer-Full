extends Node

@export var initial_state: EnemyState
@export var enemy: CharacterBody2D
@export var grabbed_state: EnemyState

var current_state: EnemyState
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is EnemyState:
			states[child.name] = child
			child.Transitioned.connect(onChildTransition)
	
	var start_state: EnemyState = states.get(enemy.initial_state.to_lower())
	start_state.Enter()
	current_state = start_state
	#if initial_state:
		#initial_state.Enter()
		#current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
	if enemy.is_grabbed and current_state != grabbed_state:
		onChildTransition(current_state, "grabbed")
	
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physicsUpdate(delta)

func onChildTransition(state: EnemyState, new_state_name: String):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state
