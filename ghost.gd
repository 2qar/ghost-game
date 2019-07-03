extends StaticBody2D

export(String, MULTILINE) var dialogue
onready var lines = dialogue.split("\n")
var skip : bool = false
var talking : bool
var in_conversation : bool

onready var dir = $sprite.flip_h

signal next_line

func _ready():
	$text.visible = false

func _process(delta):
	if not in_conversation:
		return

	if not talking and Input.is_action_pressed("talk"):
		emit_signal("next_line")
	if talking and Input.is_action_just_pressed("skip"):
		skip = true

func interact(player : Node2D):
	talk(player, lines)

func talk(player : Node2D, text : PoolStringArray):
	player.busy = true
	
	in_conversation = true
	skip = false
	if player.position.x < position.x:
		$sprite.flip_h = true
	for line in lines:
		$text.text = ""
		talking = true
		for letter in line:
			$talk_sound.pitch_scale = rand_range(0.4, 1.2)
			$talk_sound.play()
			if skip:
				$text.text = line
				skip = false
				break
			$text.text += letter
			if letter != " ":
				$text_timer.start()
				yield($text_timer, "timeout")
		talking = false
		yield(self, "next_line")

	$text.text = "[Z]"
	$sprite.flip_h = dir
	player.busy = false
	in_conversation = false