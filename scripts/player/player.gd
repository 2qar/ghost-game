extends KinematicBody2D

export var SPEED := 30
export var CURRENT : bool = false
export var WORLD_NAME := ""

export (int) var jump_strength = 50

var movement := Vector2()
var jumping : bool
var jump_timeout : bool
var last_interactable : Object
var busy : bool

signal next_line
signal swap_world

func _ready():
	add_to_group("player")

func _process(delta):
	if not CURRENT or busy:
		return

	if Input.is_action_just_pressed("ui_page_up"):
		emit_signal("swap_world", WORLD_NAME, position, $sprite.flip_h)

	var interactable = $talk_ray.get_collider()
	if interactable:
		interactable = interactable.get_parent()
		if last_interactable:
			if interactable.name != last_interactable.name:
				if last_interactable.has_method("exit_range"):
					last_interactable.exit_range()
				if interactable.has_method("interact"):
					if interactable.has_method("enter_range"):
						interactable.enter_range()
					last_interactable = interactable
				else:
					last_interactable = null
					return

			if last_interactable.has_method("in_range"):
				last_interactable.in_range()

			if Input.is_action_just_pressed("talk"):
				last_interactable.interact(self)
		elif interactable.has_method("interact"):
			if interactable.has_method("enter_range"):
				interactable.enter_range()
			last_interactable = interactable
	elif last_interactable:
		if last_interactable.has_method("exit_range"):
			last_interactable.exit_range()
		last_interactable = null

func _physics_process(delta):
	if not CURRENT:
		return

	if movement.y < 250:
		movement.y += 3

	if not busy:
		if (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
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

		if is_on_floor() and Input.is_action_just_pressed("jump"):
			movement.y = -jump_strength
			jumping = true
			jump_timeout = false
			$jump_timer.start()

		if Input.is_action_pressed("jump") and jumping and not jump_timeout:
			movement.y -= jump_strength * ($jump_timer.time_left / $jump_timer.wait_time) * delta + 2
		if Input.is_action_just_released("jump"):
			jumping = false
	else:
		movement.x = 0
	
	movement = move_and_slide(movement, Vector2(0, -1))

func _on_jump_timer_timeout():
	jump_timeout = true