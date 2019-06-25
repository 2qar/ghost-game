extends StaticBody2D

var text_visible = false
export(String, MULTILINE) var dialogue
onready var lines = dialogue.split("\n")
var skip : bool = false
var talking : bool

onready var dir = $sprite.flip_h

func _ready():
	$text.visible = false
	pass # Replace with function body.

func toggle_text():
	text_visible = !text_visible
	$text.visible = text_visible

func talk():
	skip = false
	var player = get_node("../player")
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
		yield(player, "next_line")

	$text.text = "[Z]"
	$sprite.flip_h = dir
	player.talking = false