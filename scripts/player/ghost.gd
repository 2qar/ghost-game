extends "res://scripts/player/player.gd"

onready var bow_start_offset : int = $bow.offset.x

func set_flipped(flipped : bool):
	if flipped:
		$bow.offset.x = -bow_start_offset
	else:
		$bow.offset.x = bow_start_offset
	$bow.flip_h = flipped
	$sprite.flip_h = flipped

func _process(delta):
	if not busy:
		if Input.is_action_pressed("left"):
			$bow.flip_h = true
			$bow.offset.x = -bow_start_offset
		if Input.is_action_pressed("right"):
			$bow.flip_h = false
			$bow.offset.x = bow_start_offset
