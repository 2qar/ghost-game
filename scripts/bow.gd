extends Sprite

onready var start_offset : int = offset.x

func _process(delta):
	if Input.is_action_pressed("left"):
		if not flip_h:
			flip_h = true
			offset.x = -start_offset
	if Input.is_action_pressed("right"):
		if flip_h:
			flip_h = false
			offset.x = start_offset