extends Node2D

@onready var spawn_point: Node2D = $node_spawn_point
@onready var animation: AnimationPlayer = $aniplayer

@export var _spawn_thing: PackedScene

var linked_object: Object

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !linked_object:
		animation.play("spawn_item")

func _onAnimationFinished(anim_name: StringName) -> void:
	if !anim_name == "spawn_item": return
	animation.play("idle")
	var spawn_thing = _spawn_thing.instantiate()
	get_parent().get_parent().get_node("node_grabbables").add_child(spawn_thing)
	spawn_thing.global_position = spawn_point.global_position
	spawn_thing.name = "node_projectile_root"
	linked_object = spawn_thing
