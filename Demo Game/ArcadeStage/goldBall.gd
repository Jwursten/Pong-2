extends CharacterBody2D

var Speed = 120
var Velocity = Vector2.ZERO

var PowerFunction;

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
	var tolerance = 0.0001
	if abs(speed - round(speed / 0.5) * 0.5) < tolerance:
		speed += 0.2
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
	name = "goldBall"
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


func _on_area_2d_body_entered(body:Node2D):
	
	var PlayerList = get_tree().get_nodes_in_group("Players");

	if (PlayerList.has(body)):
		visible = false

		var rng = RandomNumberGenerator.new();
		rng.randomize();
		var targetPower = rng.randi_range(0,1);

		match targetPower:
			0:
				print("ballSpeedPower")
				var balls = get_tree().get_nodes_in_group("BallGroup")

				if(balls.size() != 1):
					print("WARNING: ball group dosnt have 1 object, it has " + str(balls.size()))

				var ball = balls[0]
				print("\tballName: "+ball.name);

				print("\tball Speed: "+str(ball.Speed))
				ball.Speed = ball.Speed + 25
				print("\tball Speed: "+str(ball.Speed))
				
			1:
				print("CatcherSpeed")

				print("\tcatcher speed: " + str(body.SPEED))

				body.SPEED = body.SPEED + 300

				print("\tcatcher speed: " + str(body.SPEED))
	
	pass 
	
