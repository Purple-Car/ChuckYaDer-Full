extends CharacterBody2D
class_name AngelBody

const MAX_SPEED: float = 180.0
const SPEED: float = 20.0
const JUMP_VELOCITY: float = -120.0
const MAX_HP: int = 24
const ACCELERATION: float = 50.0
const DECELERATION: float = 100.0
const RAM_ACCELERATION: float = 125.0
const STOP_DECELERATION: float = 200.0

@export var animation_p: AnimationPlayer
@export var angelhands: Array[AngelHand]
@export var texture_head: Texture2D
@export var texture_hand: Texture2D
@export var texture_body: Texture2D
@export var texture_wing: Texture2D
@export var texture_hit: Texture2D
@export var contains: PackedScene

var boss_hp: int = MAX_HP
var was_on_floor: bool = false
var last_hit_direction: int
var bomb_object: PackedScene = preload("res://objects/bomb/scene_object_bomb.tscn")

@onready var head_sprite: Sprite2D = $node_sprites/node_head/spr2D_head
@onready var body_sprite: AnimatedSprite2D = $node_sprites/anisprite_body
@onready var hands: Array[Node2D] = [$node_sprites/node_rhand, $node_sprites/node_lhand]
@onready var flicker: AnimationPlayer = $aniplr_flicker
@onready var state_machine: Node = $node_body_states
@onready var hurtbox_area: Area2D = $node_sprites/node_head/area2D_hurtbox
@onready var overlap_area: Area2D = $area2D_overlap

signal updateHealth(damage: float)

func _physics_process(delta: float) -> void:
	move_and_slide()

func doAnimations() -> void:
	body_sprite.speed_scale = velocity.length() / SPEED / 2

func playHandAnimation(to_anim: String = body_sprite.animation) -> void:
	animation_p.play(to_anim)

func playHandSpriteAnimation(left_hand: int, to_animation: String) -> void:
	angelhands[left_hand].playAnimation(to_animation)

func getHandPosition(left_hand: int) -> Vector2:
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

func launchHand(is_left_hand: bool, to_velocity: Vector2):
	angelhands[int(is_left_hand)].tryAttack(to_velocity)

func throwBombs(is_left_hand: bool):
	var player_target: Player = getClosestPlayer()
	var target_dir: Vector2
	if !player_target:
		target_dir = [Vector2(-1, 0), Vector2(1, 0)].pick_random()
	else:
		target_dir = (player_target.global_position - global_position).normalized()
	var bomb_count: int = 1 if boss_hp > MAX_HP / 2 else 2
	var spread_angle: int = 15
	var base_speed: float = 150.0
	var upward_push: Vector2 = Vector2(0, -75)

	for rep in range(bomb_count):
		var bomb = bomb_object.instantiate()
		get_parent().add_child(bomb)
		bomb.originator = self
		bomb.global_position = angelhands[int(is_left_hand)].global_position

		var angle_offset: float = deg_to_rad((rep - (bomb_count - 1) / 2.0) * spread_angle)
		var throw_dir: Vector2 = target_dir.rotated(angle_offset).normalized()
		
		if player_target:
			bomb.velocity = throw_dir * (base_speed + (player_target.global_position - global_position).length()) + upward_push
		else:
			bomb.velocity = throw_dir * (base_speed) + upward_push
		bomb.velocity.x = abs(bomb.velocity.x) * -Utils.boolToSign(is_left_hand)
		bomb.is_ignited = true
		bomb.sprite.play("activated")

func doDeath():
	for angelhand in angelhands:
		Utils.explode_texture(texture_hand, angelhand.global_position + Vector2(6, 10))
		angelhand.queue_free()

	Utils.explode_texture(texture_body, global_position + Vector2(14, 20))
	Utils.explode_texture(texture_head, global_position - Vector2(-10, 38))

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
	return "LORD OF LORDS"

func healSelf() -> void:
	boss_hp = min(boss_hp + 1, MAX_HP)
	updateHealth.emit(boss_hp)

func isOnWall() -> bool:
	return overlap_area.has_overlapping_bodies()

func _spawnAfterImage() -> void:
	var head_tex: Texture2D = head_sprite.texture
	var body_tex: Texture2D = body_sprite.sprite_frames.get_frame_texture(body_sprite.animation, body_sprite.frame)
	
	Utils.spawnAfterImage(head_tex, head_sprite.global_position, get_parent(), false, z_index)
	Utils.spawnAfterImage(body_tex, body_sprite.global_position, get_parent(), false, z_index)
	Utils.spawnAfterImage(texture_wing, body_sprite.global_position - Vector2(0, 28), get_parent(), false, z_index)

func _onTimeout() -> void:
	_spawnAfterImage()

func _onAreaEntered(area: Area2D) -> void:
	Utils.explode_texture(texture_hit, area.global_position, 4)
	last_hit_direction = sign(global_position.x - area.global_position.x)
	boss_hp -= 4
	updateHealth.emit(boss_hp)
	if boss_hp <= 0:
		doDeath()
	flicker.seek(0)
	flicker.play("flicker")
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "knockback")
