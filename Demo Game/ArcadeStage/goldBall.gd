extends CharacterBody2D

var Speed = 120
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
		var targetPower = rng.randi_range(0,5);
		#var targetPower = 0; #for testing

		var ballSpeedModifyer = 75
		var paddleSpeedModifyer = 225

		match targetPower:
			0:
				print("ballSpeed")
				var balls = get_tree().get_nodes_in_group("BallGroup")

				if(balls.size() != 1):
					print("WARNING: ball group dosnt have 1 object, it has " + str(balls.size()))

		
				#loop though all the balls.
				for ball in balls:
					
					print("\tballName: " + ball.name);

					if (ball.Speed == 0):
						print("\tBall Immobale, modifying start speed.")
						print("\tinital speed modifyer: " + str(Global.initalBallBoost))
						Global.initalBallBoost = Global.initalBallBoost + ballSpeedModifyer
						print("\tinital speed modifyer: " + str(Global.initalBallBoost))
					else:
						print("\tball old Speed: "+str(ball.Speed))
						ball.Speed = ball.Speed + ballSpeedModifyer
						print("\tball new Speed: "+str(ball.Speed))
				
			1:
				print("CatcherSpeed")

				print("\tcatcher old speed: " + str(body.SPEED))

				body.SPEED = body.SPEED + paddleSpeedModifyer

				print("\tcatcher new speed: " + str(body.SPEED))
			2:
				print("ballSlow")
				var balls = get_tree().get_nodes_in_group("BallGroup")

				if(balls.size() != 1):
					print("WARNING: ball group dosnt have 1 object, it has " + str(balls.size()))

		
				#loop though all the balls.
				for ball in balls:
					
					print("\tballName: " + ball.name);

					if (ball.Speed == 0):
						print("\tBall Immobale, modifying start speed.")
						print("\tinital speed modifyer: " + str(Global.initalBallBoost))
						Global.initalBallBoost = Global.initalBallBoost - ballSpeedModifyer
						print("\tinital speed modifyer: " + str(Global.initalBallBoost))
					else:
						print("\tball old Speed: "+str(ball.Speed))
						ball.Speed = ball.Speed - ballSpeedModifyer
						print("\tball new Speed: "+str(ball.Speed))
				
			3:
				print("CatcherSlow")

				print("\tcatcher old speed: " + str(body.SPEED))

				body.SPEED = body.SPEED - paddleSpeedModifyer

				print("\tcatcher new speed: " + str(body.SPEED))
			4:
				var balls = get_tree().get_nodes_in_group("BallGroup")

				if(balls.size() != 1):
					print("WARNING: ball group dosnt have 1 object, it has " + str(balls.size()))
				
				var ball = balls[0]

				if (ball.Speed == 0):
					Global.delayedChaous = true;
					print("Chaous has been delayed.")
				else:
					Global.chaous()
			5:
				print("skrewYourNeighbors")
				#  This Power causes everyone else to gain 2 points
				
				if body.name == "Player1":
					Global.PlayerTwoScore += 2
					Global.PlayerThreeScore += 2
					Global.PlayerFourScore += 2
				if body.name == "Player2":
					Global.PlayerOneScore += 2
					Global.PlayerThreeScore += 2
					Global.PlayerFourScore += 2
				if body.name == "Player3":
					Global.PlayerOneScore += 2
					Global.PlayerTwoScore += 2
					Global.PlayerFourScore += 2
				if body.name == "Player4":
					Global.PlayerOneScore += 2
					Global.PlayerTwoScore += 2
					Global.PlayerThreeScore += 2
				
				var soundOfSuccess = get_tree().get_nodes_in_group("PointLoss_SkrewYourNeighbors")
				
				if(soundOfSuccess.size() != 1):
					print("\tWARNING: PointLoss_SkrewYourNeighbors group dosnt have 1 object, it has " + str(soundOfSuccess.size()))
				
				soundOfSuccess[0].play()
	
	pass 



