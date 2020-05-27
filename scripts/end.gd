extends VBoxContainer

func _ready():
	$Score.text = str(scene.get_param("score"))
	$Button.grab_focus()

func _on_Button_pressed():
	scene.change_scene("res://scenes/levels.tscn")
