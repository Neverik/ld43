extends KinematicBody2D
export var speed = 700
var vel
var is_hit = false
var size = 1
var spawner
export var max_size = 7
export var mult = 1.4
onready var player = spawner.get_node("../../Player")
export var min_wait_time = 2
var initial_x
var scaling = true
onready var notif = $VisibilityNotifier2D
var w = false
export var fade_speed = 20
var d = false
export var die_speed = 10
var dir = Vector2(0, -13)
var m = false

func _ready():
	initial_x = scale.x
	vel = Vector2(speed, 0).rotated(rotation)
	global_rotation = 0
	scale = Vector2(0, 0)
	$AnimationPlayer.current_animation = "walk"
	$Horizontal.show()
	$Vertical.hide()
	Manager.num_chicks += 1
	var col = move_and_collide(Vector2(0, 0))
	if col:
		if col.collider.is_in_group("Lake"):
			Manager.num_chicks -= 1
			queue_free()

func _process(delta):
	if w:
		position.y -= fade_speed
		if not notif.is_on_screen():
			Manager.num_chicks -= 1
			queue_free()
		return
	if d:
		var s = delta * die_speed
		scale -= Vector2(s, s)
		if scale.x <= 0:
			Manager.num_chicks -= 1
			queue_free()
		return
	if m:
		position += dir * delta
		if not notif.is_on_screen():
			Manager.num_chicks -= 1
			queue_free()
			return
		return
	if not notif.is_on_screen() and Manager.num_chicks >= Manager.max_num_chicks:
		Manager.num_chicks -= 1
		queue_free()
		return
	if scaling:
		var s = delta * 6
		scale += Vector2(s, s)
		if scale.x >= initial_x:
			scaling = false
			scale = Vector2(initial_x, initial_x)
		return
	var x = 0.07
	vel = vel.rotated(rand_range(-x, x))
	if position.distance_to(player.position) < 200:
		var dist = (position - player.position).normalized() * speed
		vel = vel.linear_interpolate(dist, 0.5)
	var col = move_and_collide(vel * delta)
	if col:
		if notif.is_on_screen() and col.collider.is_in_group("Bullet"):
			col.collider.explode()
			ht()
		elif col.collider.is_in_group("Lake"):
			Manager.num_chicks -= 1
			queue_free()
		vel = vel.bounce(col.normal)
	if is_hit:
		hit()
	is_hit = false
	if abs(vel.normalized().x) > abs(vel.normalized().y):
		$Vertical.show()
		$Horizontal.hide()
		if vel.x < 0:
			$Vertical.scale.x = -abs($Vertical.scale.x)
		else:
			$Vertical.scale.x = abs($Vertical.scale.x)
	else:
		$Horizontal.show()
		$Vertical.hide()
	

func die():
	d = true

func hit():
	if not player.shaky:
		player.shaky = true
	size += 1
	scale *= mult
	if size >= max_size:
		return win()
	get_node("../../Player").score += 1
	Manager.total_score += 1
	for i in spawner.get_parent().get_children():
		if not i.has_method("die"):
			if i.timer.wait_time > min_wait_time:
				i.timer.set_wait_time(i.timer.wait_time * 0.98)

func win():
	w = true
	show_on_top = true
	$CollisionShape2D.scale = Vector2(0, 0)

func ht():
	is_hit = true

func explode():
	pass

