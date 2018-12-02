extends Button

func click():
	Manager.load_game()

func quit():
	get_tree().quit()
