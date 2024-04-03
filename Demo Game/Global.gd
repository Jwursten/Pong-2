extends Timer

var GameTimer = 60.0

var TimerOptionIndex = 0

# Powers

var initalBallBoost = 0

var delayedChaous = false;

#var GameOver = false

#func _ready():
	#self.wait_time = GameTimer
	#self.one_shot = true 
	#self.autostart = false
	

#func _on_timeout():
	#print("Timer reached zero!")


func chaous():
	print("Chous")
	#this power will break all other ball based powers as the stand now.
	
	#"var balls = get_tree().get_node("arcade_stage")"
	var rand = RandomNumberGenerator.new()
	var top = rand.randf_range(5, 12)
	#if(balls.size() != 1):
		#print("WARNING: ball group dosnt have 1 object, it has " + str(balls.size()))
	for i in range(1,top):
		#var batt = ball.new()
		#batts.append(batt)
		get_tree().call_group('BallGroup', 'ball_continue')

		await get_tree().create_timer(.2).timeout