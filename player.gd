extends KinematicBody2D

export var SPEED := 30

var movement := Vector2()

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if Input.is_action_pressed("left"):
			if !$sprite.flip_h:
				$sprite.flip_h = true
			movement.x = -SPEED
		if Input.is_action_pressed("right"):
			if $sprite.flip_h:
				$sprite.flip_h = false
			movement.x = SPEED
	else:
		movement.x = 0
	
	if $left_down.is_colliding() or $right_down.is_colliding():
		if Input.is_action_just_pressed("jump"):
			movement.y = -100
	else:
		if movement.y < 250:
			movement.y += 3
	
	movement = move_and_slide(movement, Vector2(0, -1))