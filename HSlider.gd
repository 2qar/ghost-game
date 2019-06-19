extends HSlider

func _ready():
	pass # Replace with function body.

func _process(delta):
	get_node("../../screen").material.set_shader_param("percent", value)