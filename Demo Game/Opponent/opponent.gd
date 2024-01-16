extends CharacterBody2D


var Speed = 250
var ball


func _ready():
	ball = get_parent().get_node("ball")
	
func _physics_process(_delta):
	var direction = _get_opponent_direction()
	if direction:
		velocity.y = direction * Speed
	else:
		velocity.y = move_toward(velocity.y, 0, Speed)
	#move_and_collide(velocity)
	move_and_collide(Vector2(0, _get_opponent_direction()) * Speed)

func _get_opponent_direction():
	if abs(ball.position.y - position.y) > 25:
		if ball.position.y > position.y:
			return 1
		else:
			return -1
	else:
		return 0

