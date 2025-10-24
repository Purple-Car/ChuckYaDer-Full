extends Node

func _process(delta: float) -> void:
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera == null:
		return

	var viewport_size = get_viewport().get_visible_rect().size
	var zoom = camera.zoom
	var world_size = viewport_size / zoom

	for body in get_tree().get_nodes_in_group("wrappable"):
		var pos = body.global_position

		var extent := Vector2.ZERO
		var shape_node := body.get_node_or_null("colshape_wrapbounds")
		if shape_node and shape_node.shape is RectangleShape2D:
			extent = shape_node.shape.extents

		if pos.x + extent.x < 0:
			pos.x += world_size.x + extent.x * 2
		elif pos.x - extent.x > world_size.x:
			pos.x -= world_size.x + extent.x * 2

		if pos.y + extent.y < 0:
			pos.y += world_size.y + extent.y * 2
		elif pos.y - extent.y > world_size.y:
			pos.y -= world_size.y + extent.y * 2

		body.global_position = pos
