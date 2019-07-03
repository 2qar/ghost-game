extends Sprite

func _on_animate_timeout():
	if frame == hframes - 1:
		frame = 0
	else:
		frame += 1