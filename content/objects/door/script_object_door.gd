extends Node2D

@export var to_scene: PackedScene
@export var locked: bool
@export var end_door: bool
@export var stage: int

@onready var sprite: AnimatedSprite2D = $sprite_door
@onready var overlap: Area2D = $area2D_overlap

func _ready() -> void:
	if to_scene:
		Gamestate.setNextScene(to_scene.resource_path)
	else:
		assert(true, "No scene set to door")
	if locked:
		sprite.play(definePrefix()+"closed")
	else:
		sprite.play(definePrefix()+"open")

func _process(delta: float) -> void:
	pass

func _onAreaEntered(area: Area2D) -> void:
	if locked:
		var area_root: Node = area.get_parent()
		if area_root.is_in_group("key") and !area_root.getIsGrabbed():
			area_root.beConsumed()
			unlockDoor()
		return
	
	if end_door: MasterTracker.advanceStage(stage)
	MasterTracker.saveData()
	Gamestate.changeState(Gamestate.States.fadeout)

func unlockDoor() -> void:
	sprite.play(definePrefix()+"unlocking")

func definePrefix() -> String:
	if end_door:
		return "end_"
	return ""

func _onAnimationFinished() -> void:
	if !sprite.animation.ends_with("unlocking"): return
	
	overlap.monitoring = false
	overlap.monitoring = true
	locked = false
	sprite.play(definePrefix()+"open")
