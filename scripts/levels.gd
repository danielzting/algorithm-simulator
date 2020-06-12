extends HBoxContainer

var levels = [
    BubbleSort,
    InsertionSort,
    SelectionSort,
]
var level: ComparisonSort

func _ready():
    """Dynamically load level data."""
    for level in levels:
        var button = Button.new()
        button.text = level.NAME
        button.align = Button.ALIGN_LEFT
        button.connect("focus_entered", self, "_on_Button_focus_changed")
        button.connect("pressed", self, "_on_Button_pressed", [level.NAME])
        $LevelsBorder/Levels.add_child(button)
        # Autofocus last played level
        if GlobalScene.get_param("level") == level:
            button.grab_focus()
    # If no last played level, autofocus first
    if GlobalScene.get_param("level") == null:
        $LevelsBorder/Levels.get_child(0).grab_focus()

func _on_Button_focus_changed():
    """Initialize the preview section."""
    level = get_level(get_focus_owner().text).new(ArrayModel.new())
    level.active = false
    $Preview/InfoBorder/Info/About.text = _cleanup(level.ABOUT)
    $Preview/InfoBorder/Info/Controls.text = _cleanup(level.CONTROLS)
    # Start over when simulation is finished
    level.connect("done", self, "_on_Button_focus_changed")
    # Replace old display with new
    for child in $Preview/Display.get_children():
        child.queue_free()
    $Preview/Display.add_child(ArrayView.new(level))

func _on_Button_pressed(name):
    GlobalScene.change_scene("res://scenes/play.tscn", {"level": get_level(name)})

func get_level(name):
    for level in levels:
        if level.NAME == name:
            return level

func _on_Timer_timeout():
    level.next()

func _cleanup(string):
    return string.strip_edges().replace("\n", " ")
