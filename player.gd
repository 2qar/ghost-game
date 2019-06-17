extends KinematicBody2D

export var SPEED := 30

var movement := Vector2()
var last_ghost : Object

func _ready():
	pass # Replace with function body.

func _process(delta):
	if $talk_ray.is_colliding():
		if last_ghost:
			return
		var collider = $talk_ray.get_collider()
		if collider.has_method("toggle_text"):
			last_ghost = collider
			if !collider.text_visible:
				collider.toggle_text()
	elif last_ghost:
		last_ghost.toggle_text()
		last_ghost = null

func _physics_process(delta):
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if Input.is_action_pressed("left"):
			if !$sprite.flip_h:
				$sprite.flip_h = true
				$talk_ray.cast_to.x *= -1
			movement.x = -SPEED
		if Input.is_action_pressed("right"):
			if $sprite.flip_h:
				$sprite.flip_h = false
				$talk_ray.cast_to.x *= -1
			movement.x = SPEED
	else:
		movement.x = 0
	
	if $left_down.is_colliding() or $right_down.is_colliding():
		if Input.is_action_just_pressed("jump") and movement.y == 0:
			movement.y = -100
	else:
		if movement.y < 250:
			movement.y += 3
	
	movement = move_and_slide(movement, Vector2(0, -1))