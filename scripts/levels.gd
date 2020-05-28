extends HBoxContainer

var levels: Dictionary
var level

func _ready():
    # Load level data
    var descriptions = File.new()
    descriptions.open("res://assets/levels.json", descriptions.READ)
    levels = parse_json(descriptions.get_as_text())
    # Dynamically add buttons
    for level in levels:
        var button = Button.new()
        button.text = level
        button.align = Button.ALIGN_LEFT
        button.connect("focus_entered", self, "_on_Button_focus_changed")
        button.connect("pressed", self, "_on_Button_pressed", [level])
        $LevelsBorder/Levels.add_child(button)
    # Automatically focus on first button
    $LevelsBorder/Levels.get_child(0).grab_focus()

func _on_Button_focus_changed():
    var name = get_focus_owner().text
    $Preview/InfoBorder/Info.text = levels[name]["about"]
    level = get_level(name).new(ArrayModel.new(10))
    level.active = false
    # Start over when simulation is finished
    level.connect("done", self, "_on_Button_focus_changed")
    # Replace old display with new
    for child in $Preview/Display.get_children():
        child.queue_free()
    $Preview/Display.add_child(ArrayView.new(level))

func _on_Button_pressed(level):
    scene.change_scene("res://scenes/play.tscn",
                      {"name": level, "level": get_level(level)})

func get_level(level):
    match level:
        "BUBBLE SORT":
            return BubbleSort

func _on_Timer_timeout():
    level.next()
