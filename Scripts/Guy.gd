extends KinematicBody2D
export var speed = 700
var vel
var is_hit = false
var size = 1
var spawner
var max_size = 9
onready var player = spawner.get_node("../../Player")
export var min_wait_time = 2

func _ready():
	vel = Vector2(speed, 0).rotated(rotation)
	rotation = 0

func _process(delta):
	var x = 0.07
	vel = vel.rotated(rand_range(-x, x))
	if position.distance_to(player.position) < 200:
		var dist = (position - player.position).normalized() * speed
		vel = vel.linear_interpolate(dist, 0.5)
	var col = move_and_collide(vel * delta)
	if col:
		if col.collider.is_in_group("Bullet"):
			col.collider.explode()
			ht()
		elif col.collider.is_in_group("Wall"):
			die()
		vel = vel.bounce(col.normal)
	if is_hit:
		hit()
	is_hit = false

func die():
	queue_free()

func hit():
	size += 1
	scale *= 1.4
	if size >= max_size:
		return win()
	get_node("../../Player").score += 1
	Manager.total_score += 1
	for i in spawner.get_parent().get_children():
		if not i.has_method("die"):
			if i.timer.wait_time > min_wait_time:
				i.timer.set_wait_time(i.timer.wait_time * 0.98)

func win():
	queue_free()

func ht():
	is_hit = true

func explode():
	pass

