extends Node2D
#"res://Player3/Player3.tscn"
var PlayerName = ""

var JoinNodes = []

var filePath = "user://playerName.json"

var errorMsg = ""


@export var Address = "localHost"
var port = 3944

var Compresstion = ENetConnection.COMPRESS_NONE

var peer

var IpInputNode 
var IpLabelNode 
var ConnectButtonNode

var PlayerNameInputNode

var ConnectedLabelNode
var JoinButtonNode
var HostButtonNode
var StartButtonNode

var PlayersJoined = false

var PlayerListNode


# Called when the node enters the scene tree for the first time.
func _ready():
	# Establish come connections
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(ConnectedToServer)
	multiplayer.connection_failed.connect(ConnectionFailed)

	# define join nodes
	IpInputNode = get_node("%IpInput")
	IpLabelNode = get_node("%IpLabel")
	ConnectButtonNode = get_node("%ConnectButton")

	JoinNodes = [IpInputNode, IpLabelNode, ConnectButtonNode]

	hideJoinNodes()

	PlayerNameInputNode = get_node("%NameInput")

	# get the name 
	

	if (FileAccess.file_exists(filePath)):
		var file = FileAccess.open(filePath, FileAccess.READ)
		PlayerName = file.get_as_text()

		file.close()

		if (PlayerName != null):
			PlayerNameInputNode.text = PlayerName

	ConnectedLabelNode = get_node("ConnectedLabel")
	ConnectedLabelNode.visible = false

	HostButtonNode = get_node("HostButton")
	StartButtonNode = get_node("StartButton")
	JoinButtonNode = get_node("JoinButton")

	StartButtonNode.visible = false

	PlayerListNode = get_node("PlayersLabel")
	




# ==== Connection Listeners ====

# called on client and server
func PlayerConnected(id):
	DebugPrint("PlayerConnected: Player ID " + str(id) + " Connected.")

	print()
	PlayersJoined = true

# callend on client and server
func PlayerDisconnected(id):
	DebugPrint("PlayerDisconnected: Player ID " + str(id) + " Disconnected.")
	UpdatePlayerList()

# called only on client
func ConnectedToServer():
	DebugPrint("ConnectedToServer: Connected to Server")

	HostButtonNode.visible = false
	ConnectedLabelNode.visible = true

	DebugPrint("ConnectedToServer: Id: " + str(multiplayer.get_unique_id()) + " Name: " + PlayerName)

	SendPlayerInfo.rpc_id(1, multiplayer.get_unique_id(), PlayerName)

	DebugPrint("ConnectedToServer: Attempting to update Player List")
	UpdatePlayerList.rpc_id(1)

# called only on client
func ConnectionFailed():
	DebugPrint("ConnectionFailed: Failed Connection")


# ==== RPC functions ====

@rpc("any_peer")
func SendPlayerInfo(id, nameInput):
	id = str(id)
	if !GameManager.Players.has(id):
		DebugPrint("SendPlayerInfo: [Id: " + id + " Name: " + nameInput + "]", 1)
		DebugPrint("SendPlayerInfo: [GameManager.Players Before: " + str(GameManager.Players) + "]", 1)
		GameManager.Players[id] = {
			GameManager.NameKey: nameInput,
			GameManager.IDKey: id,
			GameManager.ScoreKey: 0
		}

		DebugPrint("SendPlayerInfo: [GameManager.Players After: " + str(GameManager.Players) + "]", 1)
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInfo.rpc(GameManager.Players[i][GameManager.NameKey], i)
	
	print("")


@rpc("any_peer", "call_local")
func StartGame():
	var gameScene = load("res://Stage/Stage.tscn").instantiate()

	get_tree().root.add_child(gameScene)

	self.hide()

@rpc("any_peer", "call_local")
func UpdatePlayerList():
	if (multiplayer.is_server() == true):
		var output = "Players:\n"
		
		DebugPrint("UpdatePlayerList:[GameManager.Players: " + str(GameManager.Players) + "]", 1)

		for player in GameManager.Players:
			output = (
				output + str(GameManager.Players[player][GameManager.NameKey]) + " - " 
				+ str(GameManager.Players[player][GameManager.IDKey]) + "\n"
			)
		
		PlayerListNode.text = output
		DebugPrint("UpdatePlayerList: Player List Updated", 1)
		
# ==== Button Listeners ====

func _on_start_button_pressed():
	if (StartButtonNode.visible == true):
		DebugPrint("Starting Game")
		StartGame.rpc()


func _on_join_button_pressed():
	if JoinButtonNode.visible == true:
		showJoinNodes()
		HostButtonNode.visible = false
		StartButtonNode.visible = false


func _on_host_button_pressed():
	if HostButtonNode.visible == true:

		JoinButtonNode.visible = false

		hideJoinNodes()
		peer = ENetMultiplayerPeer.new()
		var error = peer.create_server(port, 4)

		if (error != OK):
			PrintToUser("Cannot Host: `" + error + "`")
			return
		
		peer.get_host().compress(Compresstion)

		multiplayer.set_multiplayer_peer(peer)
		SendPlayerInfo(multiplayer.get_unique_id(), PlayerName)
		UpdatePlayerList()
		
		DebugPrint("Server Started.")
		DebugPrint("Waiting for Players...")

		StartButtonNode.visible = true

func _on_connect_pressed():

	Address = IpInputNode.text

	if (Address == ""):
		Address = "localhost"

	if(ValidateIp(Address) == true):
		peer = ENetMultiplayerPeer.new()
		peer.create_client(Address, port)
		peer.get_host().compress(Compresstion)
		multiplayer.set_multiplayer_peer(peer)



# ==== Utilities ====

func DebugPrint(msg:String, tabLayer:int = 0):

	var tabStr = ""
	for i in range(tabLayer):
		tabStr = tabStr + ">  "

	print(tabStr + str(multiplayer.get_unique_id()) + ": " + msg)

func hideJoinNodes():
	for node in JoinNodes:
		node.visible = false

func showJoinNodes():
	for node in JoinNodes:
		node.visible = true

func saveName(nameInput:String) -> void:

	PlayerName = nameInput

	var file = FileAccess.open(filePath, FileAccess.WRITE)

	file.store_string(PlayerName)

	file.close()


func ValidateIp(ipAddress:String) -> bool:

	if (ipAddress == "localhost"):
		return true

	var splitAddress = ipAddress.split(".")

	var counter = 1;

	for octet in splitAddress:
		if (octet.length() == 0 or octet.length() > 3):
			PrintToUser("Each octet of the Ip address must be between 1 and 3 digits." +
			" (see octet " + str(counter) + ")")
			return false
		
		elif (int(octet) < 0):
			PrintToUser("each octet of the Ip Address must be greater than 0" +
			" (see octet " + str(counter) + ")")
			return false
		
		elif (int(octet) > 255):
			PrintToUser("each octet of the Ip Address must be less than 254" +
			" (see octet " + counter + ")")
			return false
		
		elif(counter > 4):
			PrintToUser("There may only be 4 octets in the Ip Address")
			return false
	
	return true



func PrintToUser(msg:String) -> void:
	print(msg)

func _on_name_input_text_changed(new_text:String):
	saveName(new_text)


func _on_name_input_focus_exited():
	saveName(PlayerNameInputNode.text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
