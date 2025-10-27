extends EnemyState
class_name GuardianAttack

@export var guard_body: GuardianBody

var players: Array[CharacterBody2D]

func Enter(): pass

func Exit(): pass

func Update(_delta: float): pass

func physicsUpdate(_delta: float): pass
