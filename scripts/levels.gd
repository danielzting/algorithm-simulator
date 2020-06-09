extends HBoxContainer

var levels = [
    BubbleSort,
    InsertionSort,
    SelectionSort,
]
var level: ComparisonSort

func _ready():
    # Dynamically load level data
    for level in levels:
        var button = Button.new()
        button.text = level.TITLE
        button.align = Button.ALIGN_LEFT
        button.connect("focus_entered", self, "_on_Button_focus_changed")
        button.connect("pressed", self, "_on_Button_pressed", [level.TITLE])
        $LevelsBorder/Levels.add_child(button)
        if scene.get_param("level") == level:
            button.grab_focus()
    if scene.get_param("level") == null:
        $LevelsBorder/Levels.get_child(0).grab_focus()

func _on_Button_focus_changed():
    level = get_level(get_focus_owner().text).new(ArrayModel.new(10))
    level.active = false
    $Preview/InfoBorder/Info/Description.text = level.ABOUT.replace("\n", " ")
    # Start over when simulation is finished
    level.connect("done", self, "_on_Button_focus_changed")
    # Replace old display with new
    for child in $Preview/Display.get_children():
        child.queue_free()
    $Preview/Display.add_child(ArrayView.new(level))

func _on_Button_pressed(title):
    scene.change_scene("res://scenes/play.tscn", {"level": get_level(title)})

func get_level(title):
    for level in levels:
        if level.TITLE == title:
            return level

func _on_Timer_timeout():
    level.next()
