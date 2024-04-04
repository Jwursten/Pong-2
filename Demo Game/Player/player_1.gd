extends CharacterBody2D

var SPEED = 400.0
var highest_y = 175

func _ready():
	name = "Player1"

func _physics_process(_delta):
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
