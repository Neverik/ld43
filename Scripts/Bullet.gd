extends KinematicBody2D

export var speed = 900
var vel
onready var cam = get_node("../Camera2D")
var app

func _ready():
	vel = Vector2(speed, 0).rotated(rotation)
	var objs = [$Worm, $Leaf, $Worm2]
	for i in objs:
		i.hide()
	var r = randi() % len(objs)
	objs[r].show()
	objs[r].rotation = rand_range(0, 132)
	app = objs[r]

func _process(delta):
	var collision = move_and_collide(vel * delta)
	if collision:
		if collision.collider.has_method("ht"):
			collision.collider.ht()
		explode()
	if not $VisibilityNotifier2D.is_on_screen():
		explode()
	if "Worm" in app.name:
		app.rotation += delta * 10

func explode():
	queue_free()
