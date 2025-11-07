extends CharacterBody2D
class_name LordBody

const MAX_FALL_SPEED: float = 200.0
const SPEED: float = 20.0
const JUMP_VELOCITY: float = -120.0
const MAX_HP: int = 5

@export var animation_p: AnimationPlayer
@export var guardhands: Array[GuardianHand]
@export var texture_head: Texture2D
@export var texture_hand: Texture2D
@export var texture_body: Texture2D
@export var texture_hit: Texture2D
@export var contains: PackedScene

var boss_hp: int = MAX_HP
var was_on_floor: bool = false
var last_hit_direction: int

@onready var body_sprite: AnimatedSprite2D = $node_sprites/anisprite_body
@onready var hands: Array[Node2D] = [$node_sprites/node_rhand, $node_sprites/node_lhand]
@onready var flicker: AnimationPlayer = $aniplr_flicker
@onready var state_machine: Node = $node_body_states
@onready var hurtbox_area: Area2D = $node_sprites/node_head/area2D_hurtbox

signal updateHealth(damage: float)

func _physics_process(delta: float) -> void:
	_applyGravity(delta)
	move_and_slide()

func _applyGravity(delta: float) -> void:
	velocity += get_gravity() * delta
		
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

func _checkIfLanded() -> void:
	if not was_on_floor and is_on_floor():
		Utils.spawnSmokePuff(global_position, 18, 14)
	was_on_floor = is_on_floor()

func doAnimations() -> void:
	if is_on_floor():
		if velocity.x < 0:
			body_sprite.play("walk")
			body_sprite.speed_scale = -velocity.x / SPEED
		elif velocity.x > 0:
			body_sprite.play("walk", -1.0, true)
			body_sprite.speed_scale =  velocity.x / SPEED
		else:
			body_sprite.play("idle")
			body_sprite.speed_scale = 1
	else:
		body_sprite.play("fall")
		body_sprite.speed_scale = 1

func playHandAnimation(to_anim: String = body_sprite.animation) -> void:
	animation_p.play(to_anim)

func getHandPosition(left_hand: int):
	return hands[left_hand].global_position

func getClosestPlayer() -> Player:
	var players = Utils.getLivePlayers()
	var closest_player: Player
	var closest_proximity: float = 320

	for player in players:
		var proximity: float = abs(player.global_position.x - global_position.x)
		
		if closest_proximity > proximity:
			closest_player = player
			closest_proximity = proximity
	
	return closest_player

func launchHand(is_left_hand: bool):
	guardhands[int(is_left_hand)].tryAttack()
	pass
	
func doDeath():
	for guardhand in guardhands:
		Utils.explode_texture(texture_hand, guardhand.global_position)
		guardhand.queue_free()

	Utils.explode_texture(texture_body, global_position + Vector2(16, 11))
	Utils.explode_texture(texture_head, global_position - Vector2(-6, 16))

	if contains:
		var spawn_thing = contains.instantiate()
		var grab_node = get_parent().get_parent().get_node("node_grabbables")
		grab_node.call_deferred("add_child", spawn_thing)
		spawn_thing.global_position = global_position
		spawn_thing.name = "node_projectile_root"
		spawn_thing.set_deferred("position", global_position)
		spawn_thing.set_deferred("name", "node_boss_key_root")
		spawn_thing.set_deferred("impulse", Vector2(velocity.x, -50))

	call_deferred("queue_free")

func getName() -> String:
	return "THE LORD"

func _onAnimationChanged() -> void:
	_checkIfLanded()

func _onBodyEntered(body: Node2D) -> void:
	if body.velocity.y <= 0 or body.global_position.y + 6 >= hurtbox_area.global_position.y : return
	Utils.explode_texture(texture_hit, body.global_position, 4)
	last_hit_direction = sign(global_position.x - body.global_position.x)
	if body is Player:
		body.setImpulse(Vector2(200 - last_hit_direction,-50))
	boss_hp -= 1
	updateHealth.emit(boss_hp)
	if boss_hp <= 0:
		doDeath()
	flicker.seek(0)
	flicker.play("flicker")
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "knockback")
