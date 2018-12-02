extends Control

var lines = [
	"Hello there!\n (Space to continue)",
	"I am Gosha the farmer!\nI would like to introduce you to my farm...",
	"Oh no! The baby chicks ran away!\nI need to feed them! But I don't have the food.",
	"I will sacrifice my own food to feed them! Sacrifices must be made!",
	"But the chicks might not want to take it...\nCan you help me? They will give even more food back if they like it - that means that we won't starve!",
	"Control me using WASD, give food with the arrow keys!"
]
var lind = 0
var ind = 0
var waiting = false

func ready():
	Manager.goto_scene("res://Scenes/Game.tscn")

func _ready():
	$Label.text = ""

func _process(delta):
	if waiting:
		if Input.is_action_just_pressed("Pause"):
			$Timer.start()
			$Label.text = ""
			waiting = false
			lind += 1
			ind = 0
			if lind == len(lines):
				$Timer.stop()
				ready()
	elif Input.is_action_just_pressed("Pause"):
		if lind >= len(lines):
			$Timer.stop()
			ready()
			return
		$Label.text = ""
		for i in range(len(lines[lind]) - 1):
			$Label.text += lines[lind][i]
		ind = len(lines[lind]) - 1

func tout():
	if lind >= len(lines):
		$Timer.stop()
		ready()
		return
	if ind >= len(lines[lind]):
		$Timer.stop()
		waiting = true
		return
	$Label.text += lines[lind][ind]
	ind += 1
