extends Sprite

onready var ghost : Node2D = get_node("../../../ghost/Viewport/player")

func _process(delta):
	position = ghost.position