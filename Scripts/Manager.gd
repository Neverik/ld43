extends Node

# Scene loading
onready var root = get_tree().get_root()
onready var current_scene = root.get_child(root.get_child_count() -1)
var total_score = 0
var fading_in = false
var fading_out = false
var fade
var going_to = ""

func _ready():
	_on_scene_loaded(current_scene)

func _on_scene_loaded(scn):
	fade = scn.get_node("CanvasLayer/Fade")
	fade.color.a = 1
	fading_in = true

func _process(delta):
	if fading_in:
		fade.color.r = 0
		fade.color.g = 0
		fade.color.b = 0
		fade.color.a -= delta 
		if fade.color.a <= 0:
			fade.color.a = 0
			fading_in = false
	elif fading_out:
		fade.color.r = 0
		fade.color.g = 0
		fade.color.b = 0
		fade.color.a += delta 
		if fade.color.a >= 1:
			fade.color.a = 1
			call_deferred("_deferred_goto_scene", going_to)
			fading_out = false

func load_game():
	goto_scene("res://Scenes/Game.tscn")
	randomize()

func goto_scene(path):
	going_to = path
	fading_out = true

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	_on_scene_loaded(current_scene)

func die():
	goto_scene("res://Scenes/GameOver.tscn")
	
