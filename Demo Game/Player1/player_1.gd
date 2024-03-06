extends CharacterBody2D

const SPEED = 400.0
var highest_y = 175

const key_one = KEY_W
const key_two = KEY_S

func _enter_tree():
	print(str(multiplayer.get_unique_id()) + ": Player1: _enter_tree: name: `" + name + "`")
	get_node("%MultiplayerSynchronizer1").set_multiplayer_authority(str(name).to_int())

func _physics_process(_delta):
	if (get_parent().get_node("MultiplayerSynchronizer1").get_multiplayer_authority() == multiplayer.get_unique_id()):
		var direction
		# detect player input
		if Input.is_key_pressed(KEY_W) and position.y >= highest_y:
			direction = -1
		elif Input.is_key_pressed(KEY_S):
			direction = 1
		
		# convert the player input into a velocity
		if direction:
			velocity.y = direction * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.x = 0
		position.x = 30
		move_and_slide()
