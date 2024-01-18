extends Node



func _on_left_goal_body_entered(body):
	randomize()
	$Ball.Velocity.x = [-1, 1][randi() % 2]
	$Ball.Velocity.y = [-0.8, 0.8][randi() % 2]
	$Ball.position = Vector2(450, 450)

func _on_right_goal_body_entered(body):
	randomize()
	$Ball.Velocity.x = [-1, 1][randi() % 2]
	$Ball.Velocity.y = [-0.8, 0.8][randi() % 2]
	$Ball.position = Vector2(450, 450)

func _on_top_goal_body_entered(body):
	randomize()
	$Ball.Velocity.x = [-1, 1][randi() % 2]
	$Ball.Velocity.y = [-0.8, 0.8][randi() % 2]
	$Ball.position = Vector2(450, 450)

func _on_bottom_goal_body_entered(body):
	randomize()
	$Ball.Velocity.x = [-1, 1][randi() % 2]
	$Ball.Velocity.y = [-0.8, 0.8][randi() % 2]
	$Ball.position = Vector2(450, 450)
