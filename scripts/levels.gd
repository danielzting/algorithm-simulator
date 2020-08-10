extends HBoxContainer

const LEVELS = [
    BubbleSort,
    InsertionSort,
    SelectionSort,
    MergeSort,
    QuickSort,
]
const MIN_WAIT = 1.0 / 32 # Should be greater than maximum frame time
const MAX_WAIT = 4
const MIN_SIZE = 8
const MAX_SIZE = 128

var _level = LEVELS[0].new(ArrayModel.new(
    GlobalScene.get_param("size", ArrayModel.DEFAULT_SIZE)))

func _ready():
    for level in LEVELS:
        var button = Button.new()
        button.text = level.NAME
        button.align = Button.ALIGN_LEFT
        button.connect("focus_entered", self, "_on_Button_focus_entered")
        button.connect("pressed", self, "_on_Button_pressed", [level])
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

func _on_Button_focus_entered(size=_level.array.size):
    # Pause a bit to show completely sorted array
    if _level.array.is_sorted():
        $Timer.stop()
        yield(get_tree().create_timer(1), "timeout")
        $Timer.start()
        # Prevent race condition caused by switching levels during pause
        if not _level.array.is_sorted():
            return
    _level = _get_level(get_focus_owner().text).new(ArrayModel.new(size))
    _level.active = false
    $Preview/InfoBorder/Info/About.text = _cleanup(_level.ABOUT)
    $Preview/InfoBorder/Info/Controls.text = _cleanup(_level.CONTROLS)
    # Start over when simulation is finished
    _level.connect("done", self, "_on_Button_focus_entered")
    # Replace old display with new
    for child in $Preview/Display.get_children():
        child.queue_free()
    $Preview/Display.add_child(ArrayView.new(_level))

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        GlobalScene.change_scene("res://scenes/menu.tscn")
    elif event.is_action_pressed("faster"):
        $Timer.wait_time = max(MIN_WAIT, $Timer.wait_time / 2)
    elif event.is_action_pressed("slower"):
        $Timer.wait_time = min(MAX_WAIT, $Timer.wait_time * 2)
    elif event.is_action_pressed("bigger"):
        _on_Button_focus_entered(min(MAX_SIZE, _level.array.size * 2))
    elif event.is_action_pressed("smaller"):
        _on_Button_focus_entered(max(MIN_SIZE, _level.array.size / 2))

func _on_Button_pressed(level):
    GlobalScene.change_scene("res://scenes/play.tscn",
        {"level": level, "size": _level.array.size})

func _get_level(name):
    for level in LEVELS:
        if level.NAME == name:
            return level

func _on_Timer_timeout():
    _level.next(null)

func _cleanup(string):
    return string.strip_edges().replace("\n", " ")
