extends Node2D

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
var HostButtonNode
var StartButtonNode


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

	# get the name 
	var file = FileAccess.open(filePath, FileAccess.READ)

	PlayerName = file.get_as_text()

	file.close()

	PlayerNameInputNode = get_node("%NameInput")

	PlayerNameInputNode.text = PlayerName

	ConnectedLabelNode = get_node("ConnectedLabel")
	ConnectedLabelNode.visible = false

	HostButtonNode = get_node("HostButton")
	StartButtonNode = get_node("StartButton")
	




# ==== Connection Listeners ====

# called on client and server
func PlayerConnected(id):
	PrintToUser("Player #" + str(id) + " Connected.")

# callend on client and server
func PlayerDisconnected(id):
	PrintToUser("Player #" + str(id) + " Disconnected.")

# called only on client
func ConnectedToServer():
	PrintToUser("Connected to Server")

	HostButtonNode.visible = false
	ConnectedLabelNode.visible = true

	SendPlayerInfo.rpc_id(1, name, multiplayer.get_unique_id())

# called only on client
func ConnectionFailed():
	PrintToUser("Failed Connection")


# ==== RPC functions ====

@rpc("any_peer")
func SendPlayerInfo(id, nameInput):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": nameInput,
			"id": id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInfo.rpc(GameManager.Players[i].name, i)


@rpc("any_peer", "call_local")
func StartGame():
	var gameScene = load("res://Stage/Stage.tscn").instantiate()

	get_tree().root.add_child(gameScene)

	self.hide()
		
# ==== Button Listeners ====

func _on_start_button_pressed():
	StartGame.rpc()


func _on_join_button_pressed():
	showJoinNodes()


func _on_host_button_pressed():

	if HostButtonNode.visible == true:

		hideJoinNodes()
		peer = ENetMultiplayerPeer.new()
		var error = peer.create_server(port, 4)

		if (error != OK):
			PrintToUser("Cannot Host: `" + error + "`")
			return
		
		peer.get_host().compress(Compresstion)

		multiplayer.set_multiplayer_peer(peer)
		SendPlayerInfo(name, multiplayer.get_unique_id())
		PrintToUser("Waiting for Players")

func _on_connect_pressed():

	Address = IpInputNode.text

	if(ValidateIp(Address) == true):
		peer = ENetConnection.new()
		peer.create_cliant(Address, port)
		peer.get_host().compress(Compresstion)
		multiplayer.set_multyplay_peer(peer)



# ==== Utilities ====

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
			" (see octet " + counter + ")")
			return false
		
		elif (int(octet) < 0):
			PrintToUser("each octet of the Ip Address must be greater than 0" +
			" (see octet " + counter + ")")
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
func _process(delta):
	var output = "[b]Players:[\b]\n"

	for player in GameManager.Players:
		output = output + player["name"] + " - " + player["id"] + "\n"
	
