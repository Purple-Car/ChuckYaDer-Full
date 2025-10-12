extends State

@export var none_state: State
@export var carry_state: State

func subStateInput(event: InputEvent) -> void: pass

func onAnimationFinished(finished_animation: String) -> void:
	if finished_animation == "grab":
		next_state = none_state

func onGrabDetectSomething(body: Node2D) -> void:
	var body_name: String = "charbody_player_%s" % player.player_num
	
	if body.is_in_group("grabbable") and body.name != body_name and !player.grabbed_object:
		var reparent_node: Node = self.get_parent().get_parent().get_node("node2D_sprites/area2D_grab")
		
		if reparent_node.is_ancestor_of(body):
			player.ungrabObject()
			return
		if body.getIsGrabbed(): return
		
		player.playHandsAnimation("carry")
		
		player.setGrabbedObject(body)
		body.setGrabbed()
		body.call_deferred("reparent", reparent_node)
		body.global_position = reparent_node.global_position
		next_state = carry_state
