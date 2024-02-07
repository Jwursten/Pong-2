extends CharacterBody2D


var SPEED = 400.0
var highest_y = 175

func _physics_process(_delta):
	if (get_parent().get_node("MultiplayerSynchronizer").get_multiplayer_authority() == multiplayer.get_unique_id()):
		var direction
		if Input.is_key_pressed(KEY_UP) and position.y >= highest_y:
			direction = -1
		elif Input.is_key_pressed(KEY_DOWN):
			direction = 1
		if direction:
			velocity.y = direction * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.x = 0
		position.x = 870
		move_and_slide()
