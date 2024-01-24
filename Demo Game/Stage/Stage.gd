extends Node

var PlayerOneScore = 0
var PlayerTwoScore = 0
var PlayerThreeScore = 0
var PlayerFourScore = 0

func goal_scored():
	$Ball.position = Vector2(450, 450)
	get_tree().call_group('BallGroup', 'stop_ball')
	$CountDownTimer.start()
	$Timer.visible = true
	$PointLoss.play()

func _on_left_goal_body_entered(body):
	PlayerOneScore += 1
	goal_scored()

func _on_right_goal_body_entered(body):
	PlayerTwoScore += 1
	goal_scored()

func _on_top_goal_body_entered(body):
	PlayerFourScore += 1
	goal_scored()

func _on_bottom_goal_body_entered(body):
	PlayerThreeScore += 1
	goal_scored()

func _process(delta):
	
	#get_tree().call_group('BallGroup', 'stop_ball')
	#$CountDownTimer.start()
	#$Timer.visible = true
	
	$PlayerOneScore.text = str(PlayerOneScore)
	$PlayerTwoScore.text = str(PlayerTwoScore)
	$PlayerThreeScore.text = str(PlayerThreeScore)
	$PlayerFourScore.text = str(PlayerFourScore)
	$Timer.text = str(int($CountDownTimer.time_left))
	

func _on_count_down_timer_timeout():
	get_tree().call_group('BallGroup', 'ball_continue')
	$Timer.visible = false





















