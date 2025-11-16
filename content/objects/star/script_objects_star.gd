extends Node2D

var to_scene: String = "res://menus/ending_screen/scene_ending_screen.tscn"

@onready var shaker: AnimationPlayer = $aniplr_shake
@onready var overlap: Area2D = $area2D_overlap
@onready var sprite: AnimatedSprite2D = $node2D_shake/anisprt_sprite

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if overlap.has_overlapping_bodies():
		shaker.play("shake")
		if overlap.get_overlapping_bodies().size() == 2:
			Gamestate.setNextScene(to_scene)
			Gamestate.changeState(Gamestate.States.fadeout)
	else:
		shaker.play("RESET")

func _spawnAfterImage() -> void:
	var sprite_tex: Texture2D = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	Utils.spawnAfterImage(sprite_tex, sprite.global_position + sprite.offset, get_parent(), false, z_index)

func _onTimeout() -> void:
	_spawnAfterImage()
