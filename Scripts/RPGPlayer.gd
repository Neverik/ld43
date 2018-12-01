extends KinematicBody2D

export (int) var speed = 200
export var clicker = false
var target = Vector2()
export var do_shoot = false
export var bullet = ""
onready var muzzle = $Muzzlo/Muzzle
var health = 1
export var shoot_cost = 0.025
var score = 0
export var timer_interval = 5
export var score_mult = 0.03
var timer

var velocity = Vector2()

func _ready():
	if do_shoot:
		bullet = load(bullet)
	timer = Timer.new()
	timer.name = "Timer"
	timer.connect("timeout",self,"tout") 
	timer.set_wait_time(timer_interval)
	add_child(timer)
	timer.start()

func tout():
	health += score * score_mult
	health = min(1, health)
	score = 0

func get_input():
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
	    velocity = velocity.normalized() * speed
	get_node("../CanvasLayer/Fader").set_progress(health)

func _physics_process(delta):
	print(score)
	if clicker:
		velocity = (target - position).normalized() * speed
		if (target - position).length() > 5:
			move_and_slide(velocity)
	else:
	    get_input()
	    move_and_slide(velocity)
	if do_shoot:
		var shooting = true
		if Input.is_action_just_pressed("SLeft"):
			$Muzzlo.look_at(global_position + Vector2(-1, 0))
		elif Input.is_action_just_pressed("SRight"):
			$Muzzlo.look_at(global_position + Vector2(1, 0))
		elif Input.is_action_just_pressed("SUp"):
			$Muzzlo.look_at(global_position + Vector2(0, -1))
		elif Input.is_action_just_pressed("SDown"):
			$Muzzlo.look_at(global_position + Vector2(0, 1))
		else:
			shooting = false
		if shooting:
			shoot()

func _input(event):
	if event.is_action_pressed('Click'):
		if clicker:
			target = get_global_mouse_position()
		if do_shoot:
			$Muzzlo.look_at(get_global_mouse_position())
			shoot()
    

func shoot():
	health -= shoot_cost
	if health <= 0:
		Manager.die()
	var b = bullet.instance()
	b.global_position = muzzle.global_position
	b.rotation = $Muzzlo.rotation
	get_parent().add_child(b)