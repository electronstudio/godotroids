extends RigidBody2D


export var TURN_RATE = 4.0
export var health = 10


export var ACCELERATION=1000.0

var Bullet = preload("res://player_bullet.tscn")
var score = 0

func _physics_process(delta):
	var acceleration = (Input.get_action_strength("accel") - Input.get_action_strength("decel")) 
	var turning = (Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")) 
	
	rotation += turning * TURN_RATE * delta
	
#	if Input.is_action_pressed("turn_left"):
#		#rotation -= turning * delta
#		apply_torque_impulse(STEERING * -400)
#	if Input.is_action_pressed("turn_right"):
#		#rotation += turning * delta
#		apply_torque_impulse(STEERING * 400)
	if Input.is_action_just_pressed("fire"):
		Bullet.instance().init(self, 4000)


	apply_central_impulse((acceleration* Vector2.RIGHT * ACCELERATION * delta).rotated(rotation))
	$engine_particles.emitting = acceleration > 0
	#$engine_particles.amount = 10 #acceleration * 100
	#apply_torque_impulse(STEERING * steering )

	gamepad(delta)
	
func _process(delta):
	pass
	#$engine_particles.amount = 100
	

	#$engine_particles.speed_scale = 0
	

#func _process(delta):
#	if Input.is_action_pressed("turn_left"):
#		rotation -= turning * delta
#	if Input.is_action_pressed("turn_right"):
#		rotation += turning * delta
#	if Input.is_action_just_pressed("fire"):
#		Bullet.instance().init(self, 4000)
#
#	gamepad(delta)
#	position += Vector2.RIGHT.rotated(rotation) * velocity * delta
	
func _on_player_area_entered(area):
	health -= 1
	get_node("../HUD/health").value = health
	if health <= 0:
		get_tree().reload_current_scene()
	hitFX()

func hitFX():
	$crash_sound.play()
	modulate = Color(1000, 0, 0, 255)
	yield(get_tree().create_timer(1.0), "timeout")
	modulate = Color(1, 1, 1, 255)
	
var virtual_stick_direction = Vector2.ZERO

func gamepad(delta):
	var input = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1)) + virtual_stick_direction
	if input.length() > 0.2:
		var direction = input.angle()
		rotation = Util.rotate_toward(rotation, direction, TURN_RATE * delta) 
		
var virtual_stick_origin = Vector2.ZERO

func _input(event):
	if event is InputEventScreenTouch:
		if event.position.x < get_viewport().size.x/2.0:
			if event.pressed:
				virtual_stick_origin = event.position
		else:
			if event.pressed:
				Input.action_press("fire")
			else:
				Input.action_release("fire")
	elif event is InputEventScreenDrag and event.position.x < get_viewport().size.x/2.0:
		virtual_stick_direction =  (event.position - virtual_stick_origin).normalized()


func _on_player_body_entered(body):
	print("_on_player_body_entered", body)
