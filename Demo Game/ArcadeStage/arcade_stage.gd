extends Node

var PlayerOneScore = 0
var PlayerTwoScore = 0
var PlayerThreeScore = 0
var PlayerFourScore = 0

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
	$GameTime.start()

	resetPowerTimer()

	

func resetPowerTimer():
	$PowerTimer.start(TimeToSpawnPower);


func _on_left_goal_body_entered(_body):
	if (_body.name == "Ball"):
		PlayerOneScore += 1
	else:
		PlayerOneScore += 2
	goal_scored()

func _on_right_goal_body_entered(_body):
	if (_body.name == "Ball"):
		PlayerTwoScore += 1
	else:
		PlayerTwoScore += 2
	goal_scored()

func _on_top_goal_body_entered(_body):
	if (_body.name == "Ball"):
		PlayerFourScore += 1
	else:
		PlayerFourScore += 2
	goal_scored()

func _on_bottom_goal_body_entered(_body):
	if (_body.name == "Ball"):
		PlayerThreeScore += 1
	else:
		PlayerThreeScore += 2
	goal_scored()

func _process(_delta):
	$PlayerOneScore.text = str(PlayerOneScore)
	$PlayerTwoScore.text = str(PlayerTwoScore)
	$PlayerThreeScore.text = str(PlayerThreeScore)
	$PlayerFourScore.text = str(PlayerFourScore)
	$BallTimer.text = str(int($CountDownTimer.time_left))
	$GameTimeLabel.text = str(int($GameTime.time_left))
	
	
func _on_count_down_timer_timeout():
	var balls = get_tree().get_nodes_in_group("BallGroup")

	if(balls.size() != 1):
		print("WARNING: ball group dosnt have 1 object, it has " + str(balls.size()))

	var ball = balls[0]

	ball.StartSpeed = ballSpeed

	ball.ball_continue()

	$BallTimer.visible = false


func _game_ends():
	if  int(PlayerOneScore) < int(PlayerTwoScore) and int(PlayerOneScore) < int(PlayerFourScore) and int(PlayerOneScore) < int(PlayerThreeScore):
		get_tree().change_scene_to_file("res://player1win.tscn")
	elif int(PlayerTwoScore) < int(PlayerOneScore) and int(PlayerTwoScore) < int(PlayerFourScore) and int(PlayerTwoScore) < int(PlayerThreeScore):
		get_tree().change_scene_to_file("res://player2win.tscn")
	elif int(PlayerThreeScore) < int(PlayerOneScore) and int(PlayerThreeScore) < int(PlayerFourScore) and int(PlayerThreeScore) < int(PlayerTwoScore):
		get_tree().change_scene_to_file("res://player3win.tscn")
	elif int(PlayerFourScore) < int(PlayerOneScore) and int(PlayerFourScore) < int(PlayerThreeScore) and int(PlayerFourScore) < int(PlayerTwoScore):
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


