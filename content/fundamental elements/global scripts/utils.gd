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

#func explode_texture(texture: Texture2D, position: Vector2, chunks: int = 3, speed: float = 80.0) -> void:
	#var size: Vector2 = texture.get_size()
	#var chunk_size: Vector2 = size / chunks
	#
	#for x in range(chunks):
		#for y in range(chunks):
			#var region: Rect2 = Rect2(x * chunk_size.x, y * chunk_size.y, chunk_size.x, chunk_size.y)
			#var chunk_tex: AtlasTexture = AtlasTexture.new()
			#chunk_tex.atlas = texture
			#chunk_tex.region = region
			#
			#var sprite = Sprite2D.new()
			#sprite.texture = chunk_tex
			#sprite.position = position + region.size / 2 - size / 2
			#get_tree().current_scene.add_child(sprite)
			#
			#var angle: float = randf() * PI * 2
			#var direction = Vector2(cos(angle), sin(angle))
			#
			#var tween: Tween = sprite.create_tween()
			#tween.tween_property(sprite, "position", sprite.position + direction * speed, 0.5)
			#tween.tween_property(sprite, "modulate:a", 0.0, 0.1)
			#
			#tween.finished.connect(sprite.queue_free)

func explode_texture(texture: Texture2D, position: Vector2, chunks: int = 3, speed: float = 200.0, lifetime: float = 2.0, gravity_scale: float = 1.0):
	var size: Vector2 = texture.get_size()
	var chunk_size: Vector2 = size / chunks
	
	for x in range(chunks):
		for y in range(chunks):
			var region: Rect2 = Rect2(x * chunk_size.x, y * chunk_size.y, chunk_size.x, chunk_size.y)
			var chunk_tex: AtlasTexture = AtlasTexture.new()
			chunk_tex.atlas = texture
			chunk_tex.region = region
			
			var body: RigidBody2D = RigidBody2D.new()
			body.position = position + region.size / 2 - size / 2
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
			
			var angle: float = randf() * PI * 2
			var direction: Vector2 = Vector2(cos(angle), sin(angle))
			body.linear_velocity = direction * speed
			body.angular_velocity = 0
			
			var timer: Timer = Timer.new()
			timer.wait_time = lifetime
			timer.one_shot = true
			timer.autostart = true
			timer.timeout.connect(body.queue_free)
			body.add_child(timer)
