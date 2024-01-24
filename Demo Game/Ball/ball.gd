extends CharacterBody2D

var Speed = 400
var Velocity = Vector2.ZERO

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))

func randomNumber():
	randomize()
	var direction = [1, -1][randi() % 2]
	var random_number = randf() * 1.6 + 0.2
	random_number = round_place(random_number, 1)
	return random_number * direction

func _ready():
	Velocity.x = randomNumber()
	if Velocity.x > 0:
		Velocity.y = 2 - Velocity.x
	else:
		Velocity.y = -2 - Velocity.x

func _physics_process(delta):
	var collision_object = move_and_collide(Velocity * Speed * delta)
	if collision_object:
		$CollisionSound.play()
		Velocity = Velocity.bounce(collision_object.get_normal())
		Speed = Speed + 20
	
func stop_ball():
	Speed = 0

func ball_continue():
	Speed = 400
	Velocity.x = randomNumber()
	if Velocity.x > 0:
		Velocity.y = 2 - Velocity.x
	else:
		Velocity.y = -2 - Velocity.x
