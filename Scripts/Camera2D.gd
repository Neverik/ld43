extends Camera2D

func _process(delta):
	global_position = get_node("../Player").global_position