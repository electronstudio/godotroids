extends RigidBody2D

#var velocity 
onready var player = get_node("/root/main/player")

func _ready():
	$sound.play()
	position += Vector2.RIGHT.rotated(rotation) * 150

func _process(delta):
	#position += Vector2.RIGHT.rotated(rotation) * velocity * delta
	if position.distance_to(player.position) > 5000:
		queue_free()

func _on_bullet_area_entered(area):
	queue_free()

func init(parent, vel):
		position = parent.position
		rotation = parent.rotation
		linear_velocity = parent.linear_velocity
		angular_velocity = parent.angular_velocity
		var a = Vector2.RIGHT * vel
		apply_central_impulse(a.rotated(rotation))
		
		parent.get_node("/root/main/bullets").add_child(self)

func _on_bullet_body_entered(body):
	print(body)
