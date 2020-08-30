extends VBoxContainer

var _level = BogoSort.new(ArrayModel.new())

func _ready():
    $Buttons/Start.grab_focus()
    randomize()
    $Display.add_child(ArrayView.new(_level), true)

func _on_Start_pressed():
    GlobalScene.change_scene("res://scenes/levels.tscn")

func _on_Credits_pressed():
    GlobalScene.change_scene("res://scenes/credits.tscn")

func _on_Help_pressed():
    $Display/InstructionsContainer.show()
    $Display/HBoxContainer.hide()
    $Display/InstructionsContainer/Instructions/Button.grab_focus()

func _on_Timer_timeout():
    _level.next(null)

func _input(event):
    # If not in a browser, close the app
    if event.is_action_pressed("ui_cancel") and OS.get_name() != "HTML5":
        get_tree().quit()

func _on_Button_pressed():
    $Display/InstructionsContainer.hide()
    $Display/HBoxContainer.show()
    $Buttons/Start.grab_focus()
