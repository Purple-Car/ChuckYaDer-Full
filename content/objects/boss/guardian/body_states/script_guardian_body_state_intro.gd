extends EnemyState
class_name GuardianIntro

@export var guard_body: GuardianBody

var players: Array[CharacterBody2D]

func Enter():
	guard_body.playHandAnimation("intro")

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(_delta: float): pass

func _onAnimationFinished(anim_name: StringName) -> void:
	Transitioned.emit(self, "normal")
