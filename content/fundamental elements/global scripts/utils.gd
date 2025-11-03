extends Node

func boolToSign(to_transform: bool) -> int:
	return 1 - 2 * int(to_transform)

func check() -> void:
	if true: return

func getLivePlayers() -> Array[CharacterBody2D]:
	var live_players: Array[CharacterBody2D] = []
	var siblings: Array[Node] = get_tree().current_scene.find_child("node_grabbables", true, false).get_children()
	for sibling in siblings:
		if sibling.is_in_group("player"):
			live_players.append(sibling)
	return live_players

func spawnSmokePuff(on_position: Vector2, offset_x: int = 2, offset_y: int = 0) -> void:
	var puff_effect: PackedScene = preload("res://effects/smoke_puff/scene_effect_smoke_puff.tscn")
	var smoke_puffs = [puff_effect.instantiate(), puff_effect.instantiate()]
	for number in range(2):
		get_parent().add_child(smoke_puffs[number])
		var dir: int = Utils.boolToSign(number)
		smoke_puffs[number].position = on_position + Vector2( offset_x * dir, offset_y)
		smoke_puffs[number].flip = !bool(number)

func explode_texture(texture: Texture2D, position: Vector2, chunks: int = 2, speed: float = 200.0, lifetime: float = 2.0, gravity_scale: float = 1.0):
	var size: Vector2 = texture.get_size()
	var chunk_size: Vector2 = size / chunks
	
	for x in range(chunks):
		for y in range(chunks):
			var region: Rect2 = Rect2(x * chunk_size.x, y * chunk_size.y, chunk_size.x, chunk_size.y)
			var chunk_tex: AtlasTexture = AtlasTexture.new()
			chunk_tex.atlas = texture
			chunk_tex.region = region
			
			var body: RigidBody2D = RigidBody2D.new()
			body.position = position + Vector2(x * chunk_size.x, y * chunk_size.y) - size / 2
			body.gravity_scale = gravity_scale
			body.linear_damp = 0.1
			body.angular_damp = 0.1
			body.mass = 1.0
			get_tree().current_scene.add_child(body)
			
			var sprite: Sprite2D = Sprite2D.new()
			sprite.texture = chunk_tex
			sprite.centered = true
			sprite.z_index = 50
			body.add_child(sprite)
			
			var chunk_center = Vector2(x * chunk_size.x + chunk_size.x / 2, y * chunk_size.y + chunk_size.y / 2)
			var dir_from_center = (chunk_center - size / 2).normalized()
			var angle_offset = deg_to_rad(randf_range(-10, 10)) # Add randomness
			var direction = dir_from_center.rotated(angle_offset)
			body.linear_velocity = direction * speed
			body.angular_velocity = 0
			
			var timer: Timer = Timer.new()
			timer.wait_time = lifetime
			timer.one_shot = true
			timer.autostart = true
			timer.timeout.connect(body.queue_free)
			body.add_child(timer)
