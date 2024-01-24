extends CharacterBody2D

var Speed = 400
var Velocity = Vector2.ZERO

func _ready():
	randomize()
	Velocity.x = [-1, 1][randi() % 2]
	Velocity.y = [-0.8, 0.8][randi() % 2]

func _physics_process(delta):
	var collision_object = move_and_collide(Velocity * Speed * delta)
	if collision_object:
		$CollisionSound.play()
		Velocity = Velocity.bounce(collision_object.get_normal())
	
func stop_ball():
	Speed = 0

func ball_continue():
	Speed = 600
	Velocity.x = [-1, 1][randi() % 2]
	Velocity.y = [-0.8, 0.8][randi() % 2]
