extends VBoxContainer

var level = BogoSort.new(ArrayModel.new())

func _ready():
    $Buttons/Start.grab_focus()
    randomize()
    level.active = false
    $Display.add_child(ArrayView.new(level))

func _on_Start_pressed():
    GlobalScene.change_scene("res://scenes/levels.tscn")

func _on_Credits_pressed():
    GlobalScene.change_scene("res://scenes/credits.tscn")

func _on_Timer_timeout():
    level.next()
