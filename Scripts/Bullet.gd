extends KinematicBody2D

export var speed = 900
var vel

func _ready():
	vel = Vector2(speed, 0).rotated(rotation)

func _process(delta):
	var collision = move_and_collide(vel * delta)
	if collision:
		if collision.collider.has_method("ht"):
			collision.collider.ht()
		explode()

func explode():
	queue_free()
