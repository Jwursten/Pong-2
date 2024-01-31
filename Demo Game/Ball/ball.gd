extends CharacterBody2D

var Speed = 350
var Velocity = Vector2.ZERO

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))

func getDirection():
	randomize()
	var direction = 1
	if randi() % 2 == 0:
		direction = -1
	return direction

func randomNumber():
	var random_number = randf() * 1.6 + 0.2
	var speed = round_place(random_number, 1)
	#if speed % 0.5 == 0.0:
		#speed += 0.2
	return speed

func get_X_velocity():
	var direction = getDirection()
	var speed = randomNumber()
	return speed * direction

func get_Y_velocity(Velocity_X):
	var direction = getDirection()
	var Velocity_Y = 2 - abs(Velocity_X)
	return Velocity_Y * direction

func _ready():
	Velocity.x = get_X_velocity()
	Velocity.y = get_Y_velocity(Velocity.x)
	while Velocity.x == Velocity.y:
		Velocity.x = get_X_velocity()


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
	_ready()
func end_ball():
	stop_ball()
	$ball.visible = false
