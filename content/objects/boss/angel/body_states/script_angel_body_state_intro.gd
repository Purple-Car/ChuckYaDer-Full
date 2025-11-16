extends EnemyState
class_name AngelIntro

@export var angel_body: AngelBody

func Enter():
	angel_body.playHandAnimation("intro")

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(_delta: float): pass

func _onAnimationFinished(anim_name: StringName) -> void:
	if anim_name == "intro":
		Transitioned.emit(self, "normal")
