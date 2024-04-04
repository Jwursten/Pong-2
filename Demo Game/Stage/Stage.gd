extends Node

var PlayerList = []

var Player1Scene 
var Player2Scene 
var Player3Scene 
var Player4Scene 

var PlayerScenes = []
 

func _ready():
	DebugPrint("_ready: Preping", 0, true)

	Player1Scene = load("res://Player1/player_1.tscn")
	Player2Scene = load("res://Player2/opponent.tscn")
	Player3Scene = load("res://Player3/Player3.tscn")
	Player4Scene = load("res://Player4/Player4.tscn")

	PlayerScenes = [
		Player1Scene,
		Player2Scene,
		Player3Scene,
		Player4Scene,
	]

	for key in GameManager.Players:
		PlayerList.append(GameManager.Players[key])

	var index = 0
	
	while (index < 4):
		
		DebugPrint("_ready: [" + str(index) + "]: " + "PlayerScenes: " +str(PlayerScenes))

		var currentPlayerScene = PlayerScenes[index]
		DebugPrint("_ready: [" + str(index) + "]: " + "PlayerScenes[index]: " +str(PlayerScenes[index]))
		var currentPlayerInstance = currentPlayerScene.instantiate()

		DebugPrint("_ready: [" + str(index) + "]:  got current player scene", 0, true)

		if (index >= PlayerList.size()):
			pass # We need to add code here to add walls if not enouph players.
		else:
			DebugPrint("_ready: [" + str(index) + "]: PlayerList" + str(PlayerList), 0, true)

			currentPlayerInstance.name = str(PlayerList[index][GameManager.IDKey])
			add_child(currentPlayerInstance)
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoints"):
				if spawn.name == str(index):
					currentPlayerInstance.global_position = spawn.global_position
		
		DebugPrint("_ready: [" + str(index) + "] Player assigned.", 0, true)


		index += 1;
		DebugPrint("", 0, true)
	# we need to spawn in players instead of useing object existing in the scene.

	$GameTime.start()
	

func AddPlayer(id) -> bool:
	if PlayerList.len < 4:
		PlayerList.append(id)
		return true
	else:
		return false

func GetPlayerList() -> ItemList:
	return PlayerList

func RemovePlayerByIndex(index: int):
	var output = PlayerList[index]
	PlayerList.remove_at(index)
	return output


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
	#var stage_script_instance = load("res://Stage/Stage.gd").new()
	#var callable = Callable(stage_script_instance, "_on_game_time_timeout")
	#Global.connect("timeout", callable)

	get_tree().call_group('BallGroup', 'stop_ball')
	$CountDownTimer.start()
	$BallTimer.visible = true
	
	print("stage:Starting timeer with (s)" + str(Global.GameTimer))
	$GameTime.start(Global.GameTimer)
	
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
	$GameTimeLabel.text = str(int($GameTime.time_left))
		
	
	
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
	var tree = get_tree();
	if(!tree):
		print("treeNull")
	
	_game_ends(tree)
