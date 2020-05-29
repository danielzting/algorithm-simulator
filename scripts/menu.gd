extends VBoxContainer

var level = BogoSort.new(ArrayModel.new(10))

func _ready():
    $Buttons/Start.grab_focus()
    $Display.add_child(ArrayView.new(level))
    randomize()

func _on_Start_pressed():
    scene.change_scene("res://scenes/levels.tscn")

func _on_Credits_pressed():
    scene.change_scene("res://scenes/credits.tscn")

func _on_Timer_timeout():
    level.next()
