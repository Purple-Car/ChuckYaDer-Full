extends EnemyState
class_name LordIntro

@export var guard_body: LordBody
@export var texture_brick: Texture2D

var players: Array[Player]

func Enter():
	guard_body.playHandAnimation("intro")

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(_delta: float): pass

func _onAnimationFinished(anim_name: StringName) -> void:
	if anim_name == "intro":
		Transitioned.emit(self, "normal")

func doBrickParticle() -> void:
	Utils.explode_texture(texture_brick, guard_body.global_position + Vector2(6, 30), 5)

func doDustParticle(h_offset: int = 16) -> void:
	Utils.spawnSmokePuff(guard_body.global_position, h_offset, 15)
