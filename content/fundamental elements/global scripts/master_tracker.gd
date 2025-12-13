extends Node

#region constants
const COLORS: Dictionary = {
	"red":		Color(1.0, 0.243, 0.278, 1.0),
	"orange":	Color(1.0, 0.627, 0.227, 1.0),
	"yellow":	Color(1.0, 0.847, 0.169, 1.0),
	"green":	Color(0.184, 0.776, 0.259, 1.0),
	"cyan":		Color(0.0, 0.851, 0.745, 1.0),
	"blue":		Color(0.0, 0.729, 1.0, 1.0),
	"purple":	Color(0.412, 0.29, 1.0, 1.0),
	"violet":	Color(0.737, 0.349, 1.0, 1.0),
	"pink":		Color(1.0, 0.533, 0.867, 1.0),
	"magenta":	Color(1.0, 0.137, 0.431, 1.0)
}

const DEFAULT_KEY_MAP: Dictionary = {
	"p1_grab": [KEY_SHIFT],
	"p1_up": [KEY_W],
	"p1_down": [KEY_S],
	"p1_left": [KEY_A],
	"p1_right": [KEY_D],
	"p2_grab": [KEY_CTRL],
	"p2_up": [KEY_UP],
	"p2_down": [KEY_DOWN],
	"p2_left": [KEY_LEFT],
	"p2_right": [KEY_RIGHT]
}

const KEYMAP_PATH: String = "user://keymap.json"
const SAVE_PATH: String = "user://save.json"
#endregion

#region variables
var player_colors: Array[Color] = [
	COLORS["red"],
	COLORS["purple"]
]

var player_deaths: Array[int] = [
	0,
	0
]

var current_stage: int = 0
#endregion

signal updateDeathTracker
signal updateKeyMapButton

#region autoload
func _ready() -> void:
	loadKeyMap()
	loadData()
#endregion

#region publics
func setPlayerColor(player: int, color: String) -> void:
	player_colors[player - 1] = COLORS[color]

func incrementDeath(player_num: int) -> void:
	player_deaths[player_num - 1] += 1
	updateDeathTracker.emit()

func advanceStage(to_stage: int) -> void:
	if to_stage >= current_stage:
		current_stage = to_stage

func getColorName(color: Color) -> String:
	for key in COLORS.keys():
		if COLORS[key] == color:
			return key
	return ""

func arrayToColorArray(colors: Array) -> Array[Color]:
	var converted_colors: Array[Color]
	for color_name in colors:
		if COLORS.has(color_name):
			converted_colors.append(COLORS[color_name])
	return converted_colors

func arrayToIntArray(numbers: Array) -> Array[int]:
	var converted_deaths: Array[int]
	for number in numbers:
		converted_deaths.append(int(number))
	return converted_deaths
#endregion

#region keymap
func resetKeyMap() -> void:
	for action_name in DEFAULT_KEY_MAP.keys():
		if InputMap.has_action(action_name):
			InputMap.action_erase_events(action_name)
		else:
			InputMap.add_action(action_name)

		for key_code in DEFAULT_KEY_MAP[action_name]:
			var event := InputEventKey.new()
			event.physical_keycode = key_code
			InputMap.action_add_event(action_name, event)

	saveKeyMap()
	updateKeyMapButton.emit()

func saveKeyMap() -> void:
	var save_dict: Dictionary = {}
	for action_name in InputMap.get_actions():
		var keys: Array = []
		for event in InputMap.action_get_events(action_name):
			if event is InputEventKey:
				keys.append({
					"type": "key",
					"code": event.physical_keycode
				})
			elif event is InputEventJoypadButton:
				keys.append({
					"type": "joy_button",
					"button": event.button_index,
					"device": event.device
				})
			elif event is InputEventJoypadMotion:
				keys.append({
					"type": "joy_axis",
					"axis": event.axis,
					"axis_value": event.axis_value,
					"device": event.device
				})
		if keys.size() > 0:
			save_dict[action_name] = keys

	var file: FileAccess = FileAccess.open(KEYMAP_PATH, FileAccess.WRITE)
	if !file: return
	file.store_string(JSON.stringify(save_dict))
	file.close()

func loadKeyMap() -> void:
	if !FileAccess.file_exists(KEYMAP_PATH):
		resetKeyMap()
		return

	var file: FileAccess = FileAccess.open(KEYMAP_PATH, FileAccess.READ)
	if !file: return
	
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(data) != TYPE_DICTIONARY:
		resetKeyMap()
		return

	for action_name in data.keys():
		if !InputMap.has_action(action_name):
			InputMap.add_action(action_name)
		else:
			InputMap.action_erase_events(action_name)

		for key_data in data[action_name]:
			var event: InputEvent
			if key_data.get("type") == "key":
				event = InputEventKey.new()
				event.physical_keycode = key_data.get("code", 0)
			elif key_data.get("type") == "joy_button":
				event = InputEventJoypadButton.new()
				event.button_index = key_data.get("button", 0)
				event.device = key_data.get("device", 0)
			elif key_data.get("type") == "joy_axis":
				event = InputEventJoypadMotion.new()
				event.axis = key_data.get("axis", 0)
				event.axis_value = key_data.get("axis_value", 0.0)
				event.device = key_data.get("device", 0)
			
			if event:
				InputMap.action_add_event(action_name, event)
#endregion

#region saves
func resetData() -> void:
	player_colors = [ COLORS["red"], COLORS["purple"] ]
	player_deaths = [ 0, 0 ]
	current_stage = 0
	saveData()

func saveData() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if !file: return

	var color_names: Array = []
	for color in player_colors:
		color_names.append(getColorName(color))
	
	var data: Dictionary = {
		"player_colors": color_names,
		"player_deaths": player_deaths,
		"current_stage": current_stage
	}
	file.store_string(JSON.stringify(data))
	file.close()

func loadData() -> void:
	if !checkForSave(): 
		return
	
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if !file: 
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
		resetData()
		return
	
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(data) != TYPE_DICTIONARY: return
	
	player_colors = arrayToColorArray(data.get("player_colors", []))
	player_deaths = arrayToIntArray(data.get("player_deaths", []))
	current_stage = data.get("current_stage", current_stage)

func checkForSave() -> bool:
	if FileAccess.file_exists(SAVE_PATH): return true
	return false
#endregion
