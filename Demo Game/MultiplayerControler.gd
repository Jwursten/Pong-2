extends Node2D

@export var Address = "111.111.111.111"

var JoinNodes = []

var errorMsg = ""

var port = 3944

var peer

var IpInputNode 
var IpLabelNode 
var ConnectButtonNode 


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(ConnectedToServer)
	multiplayer.connection_failed.connect(ConnectionFailed)

	IpInputNode = get_node("%IpInput")
	IpLabelNode = get_node("%IpLabel")
	ConnectButtonNode = get_node("%ConnectButton")

	

	JoinNodes = [IpInputNode, IpLabelNode, ConnectButtonNode]

	hideJoinNodes()


func PlayerConnected(id):
	print("Player #" + id + " Connected.")

func PlayerDisconnected(id):
	print("Player #" + id + " Disconnected.")

func ConnectedToServer():
	print("Connected to Server")

func ConnectionFailed():
	print("Failed Connection")

func _on_start_button_pressed():
	pass # Replace with function body.


func _on_join_button_pressed():
	showJoinNodes()

func hideJoinNodes():
	for node in JoinNodes:
		node.visible = false

func showJoinNodes():
	for node in JoinNodes:
		node.visible = true


func _on_host_button_pressed():

	hideJoinNodes()
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)

	if (error != OK):
		print("Cannot Host: `" + error + "`")
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_NONE)

	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for Players")




func _on_name_label_focus_exited():
	pass # Replace with function body.


func _on_connect_pressed():

	Address = IpInputNode.text

	if(ValidateIp(Address) == true):
		pass


	pass # Replace with function body.

func ValidateIp(ipAddress:String) -> bool:
	
	var splitAddress = ipAddress.split(".")

	var counter = 1;

	for octet in splitAddress:
		if (octet.length() == 0 or octet.length() > 3):
			print("Each octet of the Ip address must be between 1 and 3 digits." +
			" (see octet " + counter + ")")
			return false
		
		elif (int(octet) < 0):
			print("each octet of the Ip Address must be greater than 0" +
			" (see octet " + counter + ")")
			return false
		
		elif (int(octet) > 255):
			print("each octet of the Ip Address must be less than 254" +
			" (see octet " + counter + ")")
			return false
		
		elif(counter > 4):
			print("There may only be 4 octets in the Ip Address")
			return false
	
	return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass