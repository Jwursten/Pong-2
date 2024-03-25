extends Node

var PlayerOneScore = 0
var PlayerTwoScore = 0
var PlayerThreeScore = 0
var PlayerFourScore = 0

var gameOver = false

func goal_scored():
	$Ball.position = Vector2(450, 450)
	get_tree().call_group('BallGroup', 'stop_ball')
	$CountDownTimer.start()
	$BallTimer.visible = true
	$PointLoss.play()

func _ready():
	Global.start()
	#var stage_script_instance = load("res://Stage/Stage.gd").new()
	#var callable = Callable(stage_script_instance, "_on_game_time_timeout")
	#Global.connect("timeout", callable)
	
	$GameTime.start(GLobal.GameTimeer)
	
func _on_left_goal_body_entered(_body):
	PlayerOneScore += 1
	goal_scored()

func _on_right_goal_body_entered(_body):
	PlayerTwoScore += 1
	goal_scored()

func _on_top_goal_body_entered(_body):
	PlayerFourScore += 1
	goal_scored()

func _on_bottom_goal_body_entered(_body):
	PlayerThreeScore += 1
	goal_scored()

func _process(_delta):
	$PlayerOneScore.text = str(PlayerOneScore)
	$PlayerTwoScore.text = str(PlayerTwoScore)
	$PlayerThreeScore.text = str(PlayerThreeScore)
	$PlayerFourScore.text = str(PlayerFourScore)
	$BallTimer.text = str(int($CountDownTimer.time_left))
	$GameTimeLabel.text = str(int(Global.time_left))
	
	if(Global.GameOver == true):
		var tree = get_tree();
		if(!tree):
			print("treeNull")
		
		_game_ends(tree)
	
	
func _on_count_down_timer_timeout():
	get_tree().call_group('BallGroup', 'ball_continue')
	$BallTimer.visible = false


func _game_ends(tree):
	var min_score = min(PlayerOneScore, PlayerTwoScore, PlayerThreeScore, PlayerFourScore)
	
	#var tree = get_tree()
	
	if !tree:
		print("null")
		
	if PlayerOneScore == min_score:
		tree.change_scene_to_file("res://player1win.tscn")
	elif PlayerTwoScore == min_score:
		tree.change_scene_to_file("res://player2win.tscn")
	elif PlayerThreeScore == min_score:
		tree.change_scene_to_file("res://player3win.tscn")
	elif PlayerFourScore == min_score:
		tree.change_scene_to_file("res://player4win.tscn")
	else:
		print("It's a tie or an error occurred.")


func changeGameOver():
	gameOver = false


func _on_game_time_timeout():
	call_deferred("changeGameOver")
	print("changed game over "+str(gameOver))
