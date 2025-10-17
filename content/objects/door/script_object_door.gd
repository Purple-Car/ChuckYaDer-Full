extends Node2D

@export var to_scene: PackedScene
@export var locked: bool

@onready var sprite: AnimatedSprite2D = $sprite_door

func _ready() -> void:
	if to_scene:
		Gamestate.setNextScene(to_scene.resource_path)
	else:
		assert(true, "No scene set to door")
	if locked:
		sprite.play("closed")

func _process(delta: float) -> void:
	pass

func _onAreaEntered(area: Area2D) -> void:
	if locked:
		var area_root := area.get_parent()
		if area_root.is_in_group("key") and !area_root.getIsGrabbed():
			area_root.beConsumed()
			unlockDoor()
		return
	
	Gamestate.changeState(Gamestate.States.fadeout)

func unlockDoor() -> void:
	locked = false
	sprite.play("unlocking")
