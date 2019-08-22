extends KinematicBody2D

const MAX_FALL : int = 2

onready var start_pos : Vector2 = position
onready var move_time : float = $sound.stream.get_length() / $sound.pitch_scale
onready var fall_x : int = position.x
var moving : bool
var falling : bool

var down_vel : Vector2

func in_range():
	$text.visible = !moving and !falling

func exit_range():
	$text.visible = false

func interact(player : Node2D):
	if moving or falling:
		return

	var movement = 8
	if player.position.x > position.x:
		movement *= -1

	if test_move(transform, Vector2(movement, 0)):
		position = start_pos
		return

	$text.visible = false
	moving = true
	$sound.play()

	$tween.interpolate_property(self, "position", position, position + Vector2(movement, 0), move_time, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$tween.start()
	yield($tween, "tween_all_completed")
	moving = false
	fall_x = position.x

func _physics_process(delta):
	if not moving and not test_move(transform, Vector2(0, 0.1)):
		falling = true
		if down_vel.y < MAX_FALL:
			down_vel.y += 0.3
		var collision = move_and_collide(down_vel)
		position.x = fall_x
		if collision:
			falling = false
			print(collision.collider.name)
			down_vel.y = 0
			position = position.snapped(Vector2(4, 4))