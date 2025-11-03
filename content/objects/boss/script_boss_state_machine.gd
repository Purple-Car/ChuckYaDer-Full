extends Node

@export var initial_state: EnemyState

var current_state: EnemyState
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is EnemyState:
			states[child.name] = child
			child.Transitioned.connect(onChildTransition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
	
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
