extends StaticBody2D

export var to_spawn = "res://Scenes/Entities/Guy.tscn"
export var timeout = 4.0
export var offset = 3.0
onready var spawn_scene = load(to_spawn)
export var variance = 400
var timer

func _ready():
	randomize()
	timer = Timer.new()
	timer.name = "Timer"
	timer.connect("timeout",self,"tout") 
	timer.set_wait_time(rand_range(offset, timeout))
	add_child(timer)
	timer.start()

func tout():
	print("spawn")
	var scene = spawn_scene.instance()
	scene.global_position = $SpawnPoint.global_position 
	scene.global_position = scene.global_position + Vector2(0, rand_range(-variance, variance))
	scene.global_rotation = global_rotation
	scene.spawner = self
	get_parent().add_child(scene)
