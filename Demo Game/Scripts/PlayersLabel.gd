extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_node("MultiplayerSynchronizer").set_multiplayer_authority(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
