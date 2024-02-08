extends CharacterBody2D


var SPEED = 400.0
var highest_y = 175

func _ready():
	print(str(multiplayer.get_unique_id()) + ": Player2: _ready: name: `" + name + "`")
	get_node("%MultiplayerSynchronizer2").set_multiplayer_authority(str(name).to_int())

func _physics_process(_delta):
	if (get_node("%MultiplayerSynchronizer2").get_multiplayer_authority() == multiplayer.get_unique_id()):
		var direction
		if Input.is_key_pressed(KEY_W) and position.y >= highest_y:
			direction = -1
		elif Input.is_key_pressed(KEY_S):
			direction = 1
		if direction:
			velocity.y = direction * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.x = 0
		position.x = 870
		move_and_slide()
