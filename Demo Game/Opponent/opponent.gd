extends CharacterBody2D


const SPEED = 400.0
func _physics_process(_delta):
	var direction
	if Input.is_key_pressed(KEY_W):
		direction = -1
	elif Input.is_key_pressed(KEY_S):
		direction = 1
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
