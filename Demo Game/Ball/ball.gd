extends CharacterBody2D

var Speed = 350
var Velocity = Vector2.ZERO

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))

func randomNumber():
	randomize()
	var direction = [1, -1][randi() % 2]
	var random_number = randf() * 1.6 + 0.2
	random_number = round_place(random_number, 1)
	#if random_number % .5 == 0:
		#random_number += 0.1
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
	Speed = 350
	Velocity.x = randomNumber()
	if Velocity.x > 0:
		Velocity.y = 2 - Velocity.x
	else:
		Velocity.y = -2 - Velocity.x
