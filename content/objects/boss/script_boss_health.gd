extends Control

@export var boss: CharacterBody2D
@export var intro_time: float

@onready var appear_player: AnimationPlayer = $aniplr
@onready var appear_timer: Timer = $timer_introtime
@onready var health_bar: TextureProgressBar = $texprogbar_health
@onready var boss_name: Label = $texprogbar_name

func _ready() -> void:
	appear_timer.start(intro_time)
	boss.updateHealth.connect(_onBossGotHit)
	boss_name.text = boss.getName()

func _onTimeout() -> void:
	appear_player.play("appear")

func _onBossGotHit(health: int) -> void:
	health_bar.value = health
	if health <= 0:
		appear_player.play("disappear")
