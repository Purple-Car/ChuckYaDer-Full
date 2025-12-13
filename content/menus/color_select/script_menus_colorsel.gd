extends Node2D

const GRID_DIMENSIONS: Array[Array] = [
	[0, 2],
	[0, 3],
	[1, 3]
]

var grid_pos: Array[Vector2] = [
	Vector2(0,0),
	Vector2(2,0)
]

var player_ready: Array[bool] = [
	false, false
]

@onready var ready_button: Button = $control_interactable/button_ready
@onready var cursors: Array[TextureRect] = [
	$control_interactable/control_cursors/txtrect_cursor_p1,
	$control_interactable/control_cursors/txtrect_cursor_p2
]
@onready var player_sprites: Array[AnimatedSprite2D] = [
	$control_interactable/container_p1/anisprite_player,
	$control_interactable/container_p2/anisprite_player
]
@onready var player_ready_sprites: Array[AnimatedSprite2D] = [
	$control_interactable/container_p1/anisprite_ready,
	$control_interactable/container_p2/anisprite_ready
]

var grid_buttons := {}

func _ready() -> void:
	for button in get_node("control_interactable/control_colors").get_children():
		if button is TextureButton:
			grid_buttons[button.index] = button

	for player_number in [0, 1]:
		var saved_color: Color = MasterTracker.player_colors[player_number]
		var found_index: Vector2 = Vector2(0 + player_number * 2, 0)
		for index in grid_buttons.keys():
			if MasterTracker.COLORS[grid_buttons[index].color] == saved_color:
				found_index = index
				break

		if found_index != null:
			grid_pos[player_number] = found_index
		moveCursorToIndex(player_number)

func moveCursorToIndex(player: int) -> void:
	var index = grid_pos[player]
	if not grid_buttons.has(index):
		return

	var target_button: TextureButton = grid_buttons[index]
	MasterTracker.setPlayerColor(player + 1, target_button.color)
	
	cursors[player].position = target_button.position - Vector2(1,1)
	player_sprites[player].material = player_sprites[player].material.duplicate()
	player_sprites[player].material.set("shader_parameter/new_color", MasterTracker.player_colors[player])

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: return
	
	for player_number in [1, 2]:
		if Input.is_action_just_pressed("p%s_grab" % player_number):
			toggleReady(player_number - 1)
			player_ready_sprites[player_number - 1].play(str(player_ready[player_number - 1]))
		
		if !player_ready[player_number - 1]:
			var to_move: Vector2 = Vector2( 0, 0)
			
			if Input.is_action_just_pressed("p%s_left" % player_number):
				to_move.x -= 1
			
			if Input.is_action_just_pressed("p%s_right" % player_number):
				to_move.x += 1
			
			if Input.is_action_just_pressed("p%s_up" % player_number):
				to_move.y -= 1
				if player_number == 1:
					to_move.x -= 1
			
			if Input.is_action_just_pressed("p%s_down" % player_number):
				to_move.y += 1
				if player_number == 1:
					to_move.x += 1
			
			var next_y: int = clamp(grid_pos[player_number - 1].y + to_move.y, 0, 2)
			var next_x: int = clamp(grid_pos[player_number - 1].x + to_move.x, GRID_DIMENSIONS[next_y][0], GRID_DIMENSIONS[next_y][1])
			
			if grid_pos[1 - (player_number - 1 )] != Vector2(next_x, next_y):
				grid_pos[player_number - 1] = Vector2(next_x, next_y)
				moveCursorToIndex(player_number - 1)

func toggleReady(player_num: int) -> void:
	player_ready[player_num] = !player_ready[player_num]
	
	ready_button.disabled = false
	for player in [0, 1]:
		if player_ready[player] == false:
			ready_button.disabled = true

func _onButtonReadyPressed() -> void:
	MasterTracker.saveData()
	Gamestate.setNextScene("res://menus/level_title/scene_level_title.tscn")
	Gamestate.changeState(Gamestate.States.fadeout)
