extends Control

export(String, "human", "ghost") var start_world
var worlds = []
var curr_world : int

func _ready():
	worlds = get_children()
	var bottom_start = worlds[1].name == start_world
	worlds[1].show_behind_parent = !bottom_start
	worlds[int(!bottom_start)].get_player().busy = true
	curr_world = bottom_start

	get_tree().call_group("portal", "connect", "swap_world", self, "_on_swap_world")

func _on_swap_world():
	# camera / position junk
	get_tree().call_group("player", "set_position", worlds[int(curr_world)].get_player().position)
	for world in worlds:
		var camera : Camera2D = world.get_player().get_node("Camera2D")
		camera.smoothing_enabled = false
		camera.align()
		camera.smoothing_enabled = true
	
	# set following player
	var follower : KinematicBody2D = worlds[curr_world].get_player()
	var player : KinematicBody2D = worlds[int(!curr_world)].get_player()
	player.mirror_player(follower)
	player.busy = false
	follower.other_player = player
	
	# swap world
	worlds[1].show_behind_parent = !worlds[1].show_behind_parent
	curr_world = !curr_world
	
	yield(get_tree().create_timer(1), "timeout")
	
	follower.other_player = null
	follower.busy = true