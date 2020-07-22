extends VBoxContainer

func _ready():
    $Score.text = str(GlobalScene.get_param("score"))
    $Button.grab_focus()

func _on_Button_pressed():
    GlobalScene.change_scene("res://scenes/levels.tscn",
        {"level": GlobalScene.get_param("level")})
