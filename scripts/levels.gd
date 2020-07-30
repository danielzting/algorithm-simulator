extends HBoxContainer

const LEVELS = [
    BubbleSort,
    InsertionSort,
    SelectionSort,
    MergeSort,
]
var _level: ComparisonSort

func _ready():
    for level in LEVELS:
        var button = Button.new()
        button.text = level.NAME
        button.align = Button.ALIGN_LEFT
        button.connect("focus_entered", self, "_on_Button_focus_changed")
        button.connect("pressed", self, "_on_Button_pressed", [level.NAME])
        $LevelsBorder/Levels.add_child(button)
        # Autofocus last played level
        if GlobalScene.get_param("level") == level:
            button.grab_focus()
    var top_button = $LevelsBorder/Levels.get_children()[0]
    var bottom_button = $LevelsBorder/Levels.get_children()[-1]
    # Allow looping from ends of list
    top_button.focus_neighbour_top = bottom_button.get_path()
    bottom_button.focus_neighbour_bottom = top_button.get_path()
    # If no last played level, autofocus first level
    if GlobalScene.get_param("level") == null:
        top_button.grab_focus()

func _on_Button_focus_changed():
    _level = _get_level(get_focus_owner().text).new(ArrayModel.new())
    _level.active = false
    $Preview/InfoBorder/Info/About.text = _cleanup(_level.ABOUT)
    $Preview/InfoBorder/Info/Controls.text = _cleanup(_level.CONTROLS)
    # Start over when simulation is finished
    _level.connect("done", self, "_on_Button_focus_changed")
    # Replace old display with new
    for child in $Preview/Display.get_children():
        child.queue_free()
    $Preview/Display.add_child(ArrayView.new(_level))

func _on_Button_pressed(name):
    GlobalScene.change_scene("res://scenes/play.tscn", {"level": _get_level(name)})

func _get_level(name):
    for level in LEVELS:
        if level.NAME == name:
            return level

func _on_Timer_timeout():
    _level.next(null)

func _cleanup(string):
    return string.strip_edges().replace("\n", " ")
