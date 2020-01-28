extends RigidBody2D

export var VELOCITY = 1000.0
export var TURNING = 0.7
export var FIRE_RATE = 0.01

var Bullet = preload("res://enemy_bullet.tscn")
onready var player = get_node("/root/main/player")

export var health = 3

func _ready():
	position = player.position + Vector2.RIGHT.rotated(rand_range(0, PI*2)) * 5000
	rotation = player.position.angle_to_point(position) 

func _physics_process(delta):
	var d = player.position.angle_to_point(position) 
	#rotation = Util.rotate_toward(rotation, d, TURNING*delta*10)
	var r = Util.short_angle_dist(rotation, d)
	if r>0.1:
		apply_torque_impulse(TURNING*1000)
	elif r<-0.1:
		apply_torque_impulse(-TURNING*1000)
	#position += Vector2.RIGHT.rotated(rotation) * VELOCITY * delta
	apply_central_impulse((Vector2.RIGHT * VELOCITY * delta).rotated(rotation))

func _process(delta):
	
	
	if position.distance_to(player.position) > 7000:
		queue_free()
	
	if randf()<FIRE_RATE:
		Bullet.instance().init(self, 3000)
	
func die():
	$explosion.play()
	$AnimationPlayer.play("fade")
	$CollisionPolygon2D.queue_free()
	$CPUParticles2D.emitting = true
	$CPUParticles2D.show()
	player.score += 1
	get_node("/root/main/HUD/score").text = str(player.score)
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
	

func _on_enemy_body_entered(body):
	print("enemy body entered ", body)
	hit()
		

func hit():
	health -= 1
	if health <= 0:
		die()

func _on_enemy_body_shape_entered(body_id, body, body_shape, local_shape):
	print("enemy body shape entered ", body)
