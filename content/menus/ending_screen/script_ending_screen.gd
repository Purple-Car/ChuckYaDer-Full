extends Node2D

var advance: int = 0

@onready var player_sprites: Array[AnimatedSprite2D] = [$node_sprites/anispr_player_1,$node_sprites/anispr_player_2]
@onready var animation_sprites: AnimationPlayer = $control_labels/aniplr_labels
@onready var animation_deaths: AnimationPlayer = $control_deaths/aniplr_deaths

func _ready() -> void:
	Gamestate.setNextScene("res://menus/title/scene_menus_title.tscn")
	for index in range(0,2):
		player_sprites[index].frame = 5 + ( 9 * index )
		player_sprites[index].material.set("shader_parameter/new_color", MasterTracker.player_colors[index])

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey or event is InputEventMouseButton:
		if !event.pressed: return
		if advance == 0:
			advance += 1
			animation_deaths.play("appear")
			animation_sprites.seek(10.0, true)
		elif advance == 1:
			Gamestate.changeState(Gamestate.States.fadeout)
