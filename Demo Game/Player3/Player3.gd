extends CharacterBody2D


const SPEED = 400.0
func _physics_process(_delta):
	var direction
	if Input.is_key_pressed(KEY_X):
		direction = -1
	elif Input.is_key_pressed(KEY_C):
		direction = 1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
