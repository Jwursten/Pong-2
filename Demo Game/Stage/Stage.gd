extends Node

var PlayerList = []                       
 
# I thought this was unessicary we dont call these variables outside of the function ready
#var Player1Scene 
#var Player2Scene 
#var Player3Scene 
#var Player4Scene 

var PlayerScenes = []
 
func _ready():
	DebugPrint("_ready: Preping", 0, true)

	var Player1Scene = load("res://Player1/player_1.tscn")
	var Player2Scene = load("res://Player2/opponent.tscn")
	var Player3Scene = load("res://Player3/Player3.tscn")
	var Player4Scene = load("res://Player4/Player4.tscn")

	PlayerScenes = [
		Player1Scene,
		Player2Scene,
		Player3Scene,
		Player4Scene,
	]

	# Add players to PlayerList for the game manager.                                       

	for i in GameManager.Players:
		PlayerList.append(GameManager.Players[i])

	var index = 0
	
	while (index < 4):
		
		
		if (index < PlayerList.size()):
			DebugPrint("_ready: [" + str(index) + "]: " + "PlayerScenes: " +str(PlayerScenes), 0, true)

			var currentPlayerScene = PlayerScenes[index]
			DebugPrint("_ready: [" + str(index) + "]: " + "PlayerScenes[index]: " +str(PlayerScenes[index], 0, true))
			var currentPlayerInstance = currentPlayerScene.instantiate()

			DebugPrint("_ready: [" + str(index) + "]: " + "PlayerList: " + str(PlayerList), 0, true)
			currentPlayerInstance.name = PlayerList[index][GameManager.IDKey]

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
		
		else:
			DebugPrint("_ready: [" + str(index) + "]: " + "Insufishent Players.")
			pass # we should put somthing here. spawn a wall?


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

func goal_scored():
	$Ball.position = Vector2(450, 450)
	get_tree().call_group('BallGroup', 'stop_ball')
	$CountDownTimer.start()
	$BallTimer.visible = true
	$PointLoss.play()

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

func DebugPrint(msg:String, tabLayer:int = 0, serverOnly:bool = false):

	if (serverOnly == false or (serverOnly == true and multiplayer.is_server() == true)):
		var tabStr = ""
		for i in range(tabLayer):
			tabStr = tabStr + ">  "

		print(tabStr + str(multiplayer.get_unique_id()) + ": " + msg)
