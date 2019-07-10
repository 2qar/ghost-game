extends Control

var worlds = []

func _ready():
	for node in get_children():
		if node.has_method("is_stretch_enabled"):
			node.get_player().connect("swap_world", self, "_on_swap_world")
			worlds.append(node)

	get_tree().call_group("portal", "connect", "swap_world", self, "_on_swap_world")

func _on_swap_world(world_name: String, pos: Vector2, sprite_flipped: bool):
	# ugly but it works
	# 0 hide, 1 show
	var curr_worlds = [ViewportContainer, ViewportContainer]
	for world in worlds:
		if world.name == world_name:
			curr_worlds[0] = world
		else:
			curr_worlds[1] = world
		var player : KinematicBody2D = world.get_player()
		player.CURRENT = false
		player.position = pos
		var sprite = player.get_node("sprite")
		if sprite.flip_h != sprite_flipped:
			player.get_node("talk_ray").cast_to.x *= -1
			sprite.flip_h = sprite_flipped
		player.get_node("sprite").flip_h = sprite_flipped
		player.get_node("Camera2D").smoothing_enabled = false

	print("hide ", curr_worlds[0].name)
	get_tree().call_group("player", "set_position", pos)
	$Tween.interpolate_property(curr_worlds[0].material, "shader_param/percent", 0.0, 1.0, 1.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
	print("show ", curr_worlds[1].name)
	curr_worlds[1].visible = true
	curr_worlds[1].material.set_shader_param("percent", 0.0)
	
	yield($Tween, "tween_all_completed")
	
	curr_worlds[0].visible = false
	move_child(curr_worlds[0], 1)
	var curr_player = curr_worlds[1].get_player()
	curr_player.CURRENT = true
	curr_player.get_node("Camera2D").smoothing_enabled = true