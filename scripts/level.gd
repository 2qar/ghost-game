extends ViewportContainer

func get_player():
	return get_node("Viewport/" + name + "/player")