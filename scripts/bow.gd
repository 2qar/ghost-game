extends Sprite

func _process(delta):
	if Input.is_action_just_pressed("left"):
		if not flip_h:
			flip_h = true
			offset.x *= -1
	elif Input.is_action_just_pressed("right"):
		if flip_h:
			flip_h = false
			offset.x *= -1