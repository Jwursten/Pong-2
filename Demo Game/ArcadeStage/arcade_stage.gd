extends Node

const ballSpeed = 225

@export var PowerBallScene: PackedScene

var TimeToSpawnPower = 10;

func goal_scored():
	$Ball.position = Vector2(450, 450)
	get_tree().call_group('BallGroup', 'stop_ball')
	$CountDownTimer.start()
	$BallTimer.visible = true
	$PointLoss.play()

func _ready():
	$GameTime.start(Global.GameTimer)
	get_tree().call_group('BallGroup', 'stop_ball')
	$CountDownTimer.start()
	$BallTimer.visible = true

	resetPowerTimer()

	

func resetPowerTimer():
	$PowerTimer.start(TimeToSpawnPower);


func _on_left_goal_body_entered(_body):
	if (_body.name == "Ball"):
		Global.PlayerOneScore += 1
	else:
		Global.PlayerOneScore += 2
	goal_scored()

func _on_right_goal_body_entered(_body):
	if (_body.name == "Ball"):
		Global.PlayerTwoScore += 1
	else:
		Global.PlayerTwoScore += 2
	goal_scored()

func _on_top_goal_body_entered(_body):
	if (_body.name == "Ball"):
		Global.PlayerFourScore += 1
	else:
		Global.PlayerFourScore += 2
	goal_scored()

func _on_bottom_goal_body_entered(_body):
	if (_body.name == "Ball"):
		Global.PlayerThreeScore += 1
	else:
		Global.PlayerThreeScore += 2
	goal_scored()

func _process(_delta):
	$PlayerOneScore.text = str(Global.PlayerOneScore)
	$PlayerTwoScore.text = str(Global.PlayerTwoScore)
	$PlayerThreeScore.text = str(Global.PlayerThreeScore)
	$PlayerFourScore.text = str(Global.PlayerFourScore)
	$BallTimer.text = str(int($CountDownTimer.time_left))
	$GameTimeLabel.text = str(int($GameTime.time_left))
	
	
func _on_count_down_timer_timeout():
	var balls = get_tree().get_nodes_in_group("BallGroup")

	# this warning is going to be triped by the split power.
	if(balls.size() != 1):
		print("WARNING: ball group dosnt have 1 object, it has " + str(balls.size()))

	var ball = balls[0]

	ball.StartSpeed = ballSpeed

	

	if (Global.delayedChaous == true):
		Global.delayedChaous = false
		Global.chaous()
		
	else:
		ball.ball_continue()

	$BallTimer.visible = false


func _game_ends():
	if  int(Global.PlayerOneScore) < int(Global.PlayerTwoScore) and int(Global.PlayerOneScore) < int(Global.PlayerFourScore) and int(Global.PlayerOneScore) < int(Global.PlayerThreeScore):
		get_tree().change_scene_to_file("res://player1win.tscn")
	elif int(Global.PlayerTwoScore) < int(Global.PlayerOneScore) and int(Global.PlayerTwoScore) < int(Global.PlayerFourScore) and int(Global.PlayerTwoScore) < int(Global.PlayerThreeScore):
		get_tree().change_scene_to_file("res://player2win.tscn")
	elif int(Global.PlayerThreeScore) < int(Global.PlayerOneScore) and int(Global.PlayerThreeScore) < int(Global.PlayerFourScore) and int(Global.PlayerThreeScore) < int(Global.PlayerTwoScore):
		get_tree().change_scene_to_file("res://player3win.tscn")
	elif int(Global.PlayerFourScore) < int(Global.PlayerOneScore) and int(Global.PlayerFourScore) < int(Global.PlayerThreeScore) and int(Global.PlayerFourScore) < int(Global.PlayerTwoScore):
		get_tree().change_scene_to_file("res://player4win.tscn")
	else:
		pass


func _on_game_time_timeout():
	_game_ends()

func _spawn_ball():
	$CountDownTimer.start()

func _on_power_timer_timeout():
	var PowerSpawns = get_tree().get_nodes_in_group("PowerSpawns");

	var TargetPowerSpawn = PowerSpawns.pick_random();

	var PowerBallInstance = PowerBallScene.instantiate()

	get_parent().add_child(PowerBallInstance)

	PowerBallInstance.position = TargetPowerSpawn.position

	resetPowerTimer()


