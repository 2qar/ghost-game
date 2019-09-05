extends "res://scripts/npc.gd"

signal swap_world
var switch_time : bool

func _ready():
	add_to_group("portal")
	$text.visible = false

func interact(player : Node2D):
	if not switch_time:
		talk(player, lines)
		switch_time = true
	else:
		switch_time = false
		emit_signal("swap_world")