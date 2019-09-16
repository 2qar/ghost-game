extends "res://scripts/npc.gd"

signal swap_world
signal done_swapping
var switch_time : bool

func _ready():
	$mask.visible = false
	add_to_group("portal")
	$text.visible = false

func interact(player : Node2D):
	if not switch_time:
		talk(player, lines)
		switch_time = true
	else:
		switch_time = false
		emit_signal("swap_world")
		$Tween.interpolate_property($mask, "texture_scale", 0.01, 15, 5.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
		$mask.visible = true
		
		yield($Tween, "tween_all_completed")
		emit_signal("done_swapping")
		$mask.visible = false
		$mask.texture_scale = .01
