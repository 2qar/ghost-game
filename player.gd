extends KinematicBody2D

export var SPEED := 30

var movement := Vector2()
var last_ghost : Object
var talking : bool

signal next_line

func _ready():
	pass # Replace with function body.

func test_transition():
	var tween : Tween = get_node("../../Tween")
	var screen : ViewportContainer = get_node("../../../ghost")
	tween.interpolate_property(screen.material, "shader_param/percent", 0.0, 1.0, 1.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	screen.visible = false
	print("hide")

func _process(delta):
	if Input.is_action_just_pressed("ui_page_up"):
		test_transition()

	if $talk_ray.is_colliding():
		if last_ghost:
			if Input.is_action_just_pressed("talk"):
				if not talking:
					talking = true
					last_ghost.talk()
				elif not last_ghost.talking:
					emit_signal("next_line")
			elif last_ghost.talking and Input.is_action_just_pressed("skip"):
				last_ghost.skip = true
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
	if (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and not talking:
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
	
	if ($left_down.is_colliding() or $right_down.is_colliding()) and not talking:
		if Input.is_action_just_pressed("jump") and movement.y == 0:
			movement.y = -100
	if not is_on_floor():
		if movement.y < 250:
			movement.y += 3
	
	movement = move_and_slide(movement, Vector2(0, -1))