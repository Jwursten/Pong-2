extends CharacterBody2D


const SPEED = 400.0
var maxLeft_x = 175
var maxRight_x = 725

func _ready():
	print(str(multiplayer.get_unique_id()) + ": " + name)
	get_node("%MultiplayerSynchronizer3").set_multiplayer_authority(str(name).to_int())

func _physics_process(_delta):
	if (get_node("%MultiplayerSynchronizer3").get_multiplayer_authority() == multiplayer.get_unique_id()):
		var direction
		if Input.is_key_pressed(KEY_X) and position.x >= maxLeft_x:
			direction = -1
		elif Input.is_key_pressed(KEY_C) and position.x <= maxRight_x:
			direction = 1
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = 0
		position.y = 30
		move_and_slide()
