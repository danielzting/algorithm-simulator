extends HBoxContainer

const LEVELS = [
    BubbleSort,
    InsertionSort,
    SelectionSort,
    MergeSort,
    QuickSort,
    CocktailSort,
    ShellSort,
    CombSort,
    CycleSort,
    OddEvenSort,
]
const MIN_WAIT = 1.0 / 32 # Should be greater than maximum frame time
const MAX_WAIT = 4
const MIN_SIZE = 8
const MAX_SIZE = 256

var _level = GlobalScene.get_param("level", LEVELS[0]).new(ArrayModel.new(
    GlobalScene.get_param("size", ArrayModel.DEFAULT_SIZE)))

func _ready():
    var buttons = $LevelsBorder/Levels/LevelsContainer/Buttons
    var scores = $LevelsBorder/Levels/LevelsContainer/Scores
    for level in LEVELS:
        var button = Button.new()
        button.text = level.new(ArrayModel.new()).NAME
        button.align = Button.ALIGN_LEFT
        button.connect("focus_entered", self, "_on_Button_focus_entered")
        button.connect("pressed", self, "_on_Button_pressed", [level])
        buttons.add_child(button)
        var score = Label.new()
        score.align = Label.ALIGN_RIGHT
        score.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        scores.add_child(score)
    # Autofocus last played level
    for button in buttons.get_children():
        if button.text == _level.NAME:
            button.grab_focus()
    var top_button = buttons.get_children()[0]
    var bottom_button = buttons.get_children()[-1]
    # Allow looping from ends of list
    top_button.focus_neighbour_top = bottom_button.get_path()
    bottom_button.focus_neighbour_bottom = top_button.get_path()

func _on_Button_focus_entered(size=_level.array.size):
    # Update high scores
    var container = $LevelsBorder/Levels/LevelsContainer
    for i in range(LEVELS.size()):
        var name = container.get_node("Buttons").get_child(i).text
        var time = GlobalScore.get_time(name, size)
        container.get_node("Scores").get_child(i).text = "INF" if time == INF else "%.3f" % time
    # Pause a bit to show completely sorted array
    if _level.array.is_sorted():
        # Prevent race condition caused by keyboard input during pause
        set_process_input(false)
        $Timer.stop()
        yield(get_tree().create_timer(1), "timeout")
        if not _level.array.is_sorted():
            return
        $Timer.start()
        set_process_input(true)
    _level = _get_level(get_focus_owner().text).new(ArrayModel.new(size))
    $Preview/InfoBorder/Info/Description.text = _level.DESCRIPTION
    $Preview/InfoBorder/Info/Controls.text = _level.CONTROLS
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
        if level.new(ArrayModel.new()).NAME == name:
            return level

func _on_Timer_timeout():
    _level.next(null)
