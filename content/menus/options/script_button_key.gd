extends Button

const JOYPAD_DEADZONE: float = 0.5

@export var action: String
@export var player: int

var remapping: bool = false

func _ready() -> void:
	displaySetkey()
	MasterTracker.updateKeyMapButton.connect(displaySetkey)

func displaySetkey() -> void:
	var proper_action: String = "p%s_%s" % [player, action]
	var action_events: Array[InputEvent] = InputMap.action_get_events(proper_action)
	var current_key: String = ""
	if action_events.size() > 0:
		current_key = action_events[0].as_text()
	text = current_key

func remapKey(event: InputEvent) -> void:
	var proper_action: String = "p%s_%s" % [player, action]
	InputMap.action_erase_events(proper_action)
	if event is InputEventKey and event.keycode != KEY_ESCAPE:
		InputMap.action_add_event(proper_action, event)
	else:
		InputMap.action_add_event(proper_action, event)
	MasterTracker.saveKeyMap()
	displaySetkey()

func _onToggled(toggled_on: bool) -> void:
	remapping = toggled_on
	if toggled_on:
		text = "..."
		release_focus()
	else:
		displaySetkey()

func _input(event: InputEvent) -> void:
	if remapping:
		if event is InputEventMouseMotion:
			return
		elif event is InputEventJoypadMotion and abs(event.axis_value) < JOYPAD_DEADZONE:
			return
		
		remapKey(event)
		button_pressed = false
