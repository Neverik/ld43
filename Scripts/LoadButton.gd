extends Button

func sclick():
	Manager.goto_scene("res://Scenes/Game.tscn")

func click():
	Manager.load_game()

func quit():
	get_tree().quit()
