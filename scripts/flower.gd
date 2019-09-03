extends "res://scripts/npc.gd"

signal flower_death

func _ready():
	add_to_group("flower")

func _on_die_body_entered(body):
	if body.name == "box":
		yield(get_tree().create_timer(0.2), "timeout")
		visible = false
		emit_signal("flower_death")