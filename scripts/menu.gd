extends VBoxContainer

func _ready():
	$StartButton.grab_focus()

func _on_StartButton_pressed():
	scene.change_scene("res://scenes/levels.tscn")
