extends EnemyState

const DEFAULT_TIMER: float = 3.0

@export var enemy: CharacterBody2D

var getup_timer: float

func Enter():
	getup_timer = DEFAULT_TIMER
	enemy.playAnimation("grabbed")
	enemy.velocity.x = 0

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(delta: float):
	if enemy.is_on_floor():
		if getup_timer > 0:
			getup_timer -= delta
		else:
			Transitioned.emit(self, "walk")
	else:
		getup_timer = DEFAULT_TIMER
