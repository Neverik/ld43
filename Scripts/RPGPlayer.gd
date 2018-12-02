extends KinematicBody2D

export (int) var speed = 200
export var clicker = false
var target = Vector2()
export var do_shoot = false
export var bullet = ""
onready var muzzle = $Muzzlo/Muzzle
var health = 1
export var shoot_cost = 0.02
var score = 0
export var timer_interval = 15
export var score_mult = 0.05
export var decay = 0.02
var timer
var l = 0
export var tou = 0.25
var initial
var flashing_in = false
var flashing_out = false
onready var fade = get_node("../CanvasLayer/Fade")
var shaky = false
export var shake_amount = 10
var shaking_for = 0
export var shake_length = 0.5
onready var camera = get_node("../Camera2D")

var velocity = Vector2()
onready var pos = velocity.normalized()

func _ready():
	if do_shoot:
		bullet = load(bullet)
	if fade:
		fade.show()
	Manager.num_chicks = 0
	"""initial = scale
	timer = Timer.new()
	timer.name = "Timer"
	timer.connect("timeout",self,"tout") 
	timer.set_wait_time(timer_interval)
	add_child(timer)
	timer.start()"""

func tout():
	health += score * score_mult
	health = min(1, health)
	if score != 0:
		flashing_in = true
	score = 0

func get_input():
	"""if Input.is_action_just_pressed("Reload"):
		tout()"""
	if not clicker:
		velocity = Vector2()
		if Input.is_action_pressed('Right'):
			velocity.x += 1
		if Input.is_action_pressed('Left'):
			velocity.x -= 1
		if Input.is_action_pressed('Down'):
			velocity.y += 1
		if Input.is_action_pressed('Up'):
			velocity.y -= 1
		pos = velocity
		velocity = velocity.normalized() * speed
	get_node("../CanvasLayer/Fader").set_progress(health)

func _physics_process(delta):
	health -= decay * delta
	if clicker:
		velocity = (target - position).normalized() * speed
		if (target - position).length() > 5:
			move_and_slide(velocity)
	else:
	    get_input()
	    move_and_slide(velocity)
	if do_shoot:
		var shooting = false
		var velo = Vector2(0, 0)
		if Input.is_action_pressed("SLeft"):
			shooting = true
			velo += Vector2(-1, 0)
		if Input.is_action_pressed("SRight"):
			shooting = true
			velo += Vector2(1, 0)
		if Input.is_action_pressed("SUp"):
			shooting = true
			velo += Vector2(0, -1)
		if Input.is_action_pressed("SDown"):
			shooting = true
			velo += Vector2(0, 1)
		l += delta
		if shooting and l >= tou:
			l = 0
			$Muzzlo.look_at(global_position + velo)
			shoot()
	if health <= 0 and not (Manager.fading_out):
		Manager.die()
	if health <= 0.2:
		tout()
	if get_node("../CanvasLayer/Hits"):
		get_node("../CanvasLayer/Hits").text = str(Manager.total_score)
	if flashing_in:
		fade.color.r = 1
		fade.color.g = 1
		fade.color.b = 1
		fade.color.a += delta * 6
		if fade.color.a >= 1.0:
			fade.color.a = 1.0
			flashing_in = false
			flashing_out = true
	elif flashing_out:
		fade.color.r = 1
		fade.color.g = 1
		fade.color.b = 1
		fade.color.a -= delta * 6
		if fade.color.a <= 0.0:
			fade.color.a = 0.0
			flashing_out = false
	if shaky:
		camera.set_offset(Vector2( \
	        rand_range(-shake_amount, shake_amount), \
	        rand_range(-shake_amount, shake_amount) \
	    ))
		shaking_for += delta
		if shaking_for >= shake_length:
			shaky = false
			shaking_for = 0
	var shooting = false
	var velo = Vector2(0, 0)
	if Input.is_action_pressed("SLeft"):
		shooting = true
		velo += Vector2(-1, 0)
	if Input.is_action_pressed("SRight"):
		shooting = true
		velo += Vector2(1, 0)
	if Input.is_action_pressed("SUp"):
		shooting = true
		velo += Vector2(0, -1)
	if Input.is_action_pressed("SDown"):
		shooting = true
		velo += Vector2(0, 1)
	if shooting:
		pos = velo
	if abs(pos.y) < abs(pos.x):
		$Side.show()
		$Front.hide()
		$Back.hide()
		if pos.x >= 0:
			$Side.scale.x = abs($Side.scale.x)
		else:
			$Side.scale.x = -abs($Side.scale.x)
	else:
		$Side.hide()
		$Front.hide()
		$Back.hide()
		if pos.y < 0:
			$Back.show()
		else:
			$Front.show()

func _input(event):
	if event.is_action_pressed('Click'):
		if clicker:
			target = get_global_mouse_position()
		if do_shoot:
			$Muzzlo.look_at(get_global_mouse_position())
			shoot()
    

func shoot():
	health -= shoot_cost
	var b = bullet.instance()
	b.global_position = muzzle.global_position
	b.rotation = $Muzzlo.rotation
	get_parent().add_child(b)
	#$Muzzlo.add_child(load("res://Scenes/Entities/Particles2D.tscn").instance())