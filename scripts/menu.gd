extends VBoxContainer

var level = BogoSort.new(ArrayModel.new(10))

func _ready():
    $StartButton.grab_focus()
    $Display.add_child(ArrayView.new(level))

func _on_StartButton_pressed():
    scene.change_scene("res://scenes/levels.tscn")

func _on_Timer_timeout():
    level.next()
