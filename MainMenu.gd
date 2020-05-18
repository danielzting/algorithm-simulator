extends VBoxContainer

func _ready():
	$StartButton.grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene("res://LevelSelect.tscn")
