extends Node

var PlayerList = []

@export var Player1Scene : PackedScene
@export var Player2Scene : PackedScene
@export var Player3Scene : PackedScene
@export var Player4Scene : PackedScene

var PlayerScenes = [
	Player1Scene,
	Player2Scene,
	Player3Scene,
	Player4Scene
]

func _ready():

	Player1Scene = get_scen

	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScenes[index].instantiate()
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoints"):
			if spawn.name == index:
				currentPlayer.global_position = spawn.global_position


		index += 1;

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

func _ready():

	# we need to spawn in players instead of useing object existing in the scene.

	$GameTime.start()
	
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
