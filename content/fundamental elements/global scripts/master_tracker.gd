extends Node

#region constants
const COLORS := {
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

const DEFAULT_KEY_MAP_P1 := {
	"p1_grab": [KEY_SHIFT],
	"p1_up": [KEY_W],
	"p1_down": [KEY_A],
	"p1_left": [KEY_S],
	"p1_right": [KEY_D]
}

const DEFAULT_KEY_MAP_P2 := {
	"p2_grab": [KEY_CTRL],
	"p2_up": [KEY_UP],
	"p2_down": [KEY_DOWN],
	"p2_left": [KEY_LEFT],
	"p2_right": [KEY_RIGHT]
}
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
#endregion

signal updateDeathTracker

#region publics
func setPlayerColor(player: int, color: String) -> void:
	player_colors[player - 1] = COLORS[color]

func incrementDeath(player_num: int) -> void:
	player_deaths[player_num - 1] += 1
	updateDeathTracker.emit()
#endregion
