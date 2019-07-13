extends "res://scripts/player/player.gd"

func _physics_process(delta):
	pass

func _on_damage_body_entered(body):
	if body.name == "spike":
		busy = true
		# TODO: make the player bounce away from the spike when dying
		#var angle = body.position.angle_to(position)
		print("ouch!")
