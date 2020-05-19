extends VBoxContainer

func _ready():
	$StartButton.grab_focus()

func _on_StartButton_pressed():
	SceneSwitcher.change_scene("res://LevelSelect.tscn")
