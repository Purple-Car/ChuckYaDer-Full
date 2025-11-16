extends EnemyState
class_name GuardianIntro

@export var guard_body: GuardianBody

var players: Array[Player]

func Enter():
	guard_body.playHandAnimation("intro")

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(_delta: float): pass

func _onAnimationFinished(anim_name: StringName) -> void:
	if anim_name == "intro":
		Transitioned.emit(self, "normal")
