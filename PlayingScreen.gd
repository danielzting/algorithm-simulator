extends VBoxContainer

func _ready():
	$HUDBorder/HUD/Level.text = SceneSwitcher.get_param("level")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
