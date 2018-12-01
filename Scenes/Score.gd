extends Label

func _ready():
	text = "Score: " + str(Manager.total_score)
	Manager.total_score = 0
