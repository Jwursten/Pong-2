extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	add_item("60 secs")
	add_item("90 secs")
	add_item("120 secs")
	add_item("150 secs")
	add_item("240 secs")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_item_selected(index):
	pass # Replace with function body.
