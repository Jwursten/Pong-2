extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	add_item("60 secs")
	add_item("90 secs")
	add_item("120 secs")
	add_item("150 secs")
	add_item("240 secs")
	add_item("Insanity")


func _on_item_selected(index):
	print(Global.GameTimer)
	if index == 0:
		Global.GameTimer = 60.0
		print(Global.GameTimer)
		return
	elif index == 1:
		Global.GameTimer = 90.0
		print(Global.GameTimer)
		return
	elif index == 2:
		Global.GameTimer = 120.0
		print(Global.GameTimer)
		return
	elif index == 3:
		Global.GameTimer = 150.0
		print(Global.GameTimer)
		return
	elif index == 4:
		Global.GameTimer = 240.0
		print(Global.GameTimer)
		return
	elif index == 5:
		Global.GameTimer = 4096
		print(Global.GameTimer)
	else:
		pass
