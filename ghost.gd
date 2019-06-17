extends StaticBody2D

var text_visible = false

func _ready():
	$text.visible = false
	pass # Replace with function body.

func toggle_text():
	text_visible = !text_visible
	$text.visible = text_visible