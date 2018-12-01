extends KinematicBody2D
export var speed = 700
var vel
var is_hit = false
var size = 1
export var max_size = 4
var spawner

func _ready():
	vel = Vector2(speed, 0).rotated(rotation)

func _process(delta):
	var col = move_and_collide(vel * delta)
	if col:
		if col.collider.is_in_group("Bullet"):
			col.collider.explode()
			ht()
		else:
			die()
	if is_hit:
		hit()
	is_hit = false

func die():
	queue_free()

func hit():
	size += 1
	if size >= max_size:
		die()
		return
	scale *= 1.5
	get_node("../../Player").score += 1
	spawner.timer.set_wait_time(spawner.timer.wait_time * 0.95)

func ht():
	is_hit = true

