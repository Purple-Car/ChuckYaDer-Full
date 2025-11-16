extends Node2D

const LEVEL_TITLE: Array[String] = [
	"Small steps",
	"Death do you apart",
	"Hall of the Knight",
	"Around the World",
	"On the line of fire",
	"Stage 6",
	"Stage 7",
	"Stage 8",
	"Stage 9",
]

@onready var level_label: Label = $control/label_level_title
@onready var level_number: Label = $control/label_level_number

func _ready() -> void:
	level_label.text = LEVEL_TITLE[MasterTracker.current_stage]
	level_number.text = str(MasterTracker.current_stage + 1)

func _process(delta: float) -> void:
	pass

func _onTimeout() -> void:
	var current_stage: String = str(MasterTracker.current_stage + 1)
	var resume_stage_path: String = "res://stages/stage_%s/scene_stage_%s_area_1.tscn" % [current_stage, current_stage]
	Gamestate.setNextScene(resume_stage_path)
	Gamestate.changeState(Gamestate.States.fadeout)
