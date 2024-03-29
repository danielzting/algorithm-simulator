extends VBoxContainer

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

const MIN_WAIT = 1.0 / 64
const MAX_WAIT = 1
const MIN_SIZE = 16
const MAX_SIZE = 64

var _index = LEVELS.find(GlobalScene.get_param("level", LEVELS[0]))
var _level: ComparisonSort
var _size = GlobalScene.get_param("size", ArrayModel.DEFAULT_SIZE)
var _data_type = GlobalScene.get_param(
    "data_type", ArrayModel.DATA_TYPES.RANDOM_UNIQUE)
var _restart = false

func _ready():
    _load_types($Level/Right/Display/TypesContainer)
    _load_types($BigDisplay/TypesContainer)
    _reload()
    var scores = $Level/Right/Info/ScoresContainer/Scores
    scores.get_node("Easy/Button").focus_neighbour_top = $NamesContainer/Names/Current.get_path()
    var selectedDifficulty = scores.get_child(log(_size / MIN_SIZE) / log(2)).get_node("Button")
    selectedDifficulty.add_color_override("font_color", GlobalTheme.ORANGE)
    for difficulty in $Level/Right/Info/ScoresContainer/Scores.get_children():
        if difficulty.name != "Controls":
            difficulty.get_child(0).connect("pressed", self, "_on_Difficulty_pressed", [difficulty])

func _load_types(node):
    var types = VBoxContainer.new()
    types.name = "Types"
    node.add_child(types)
    for type in ArrayModel.DATA_TYPES:
        var button = Button.new()
        button.text = type.replace("_", " ")
        button.connect("pressed", self, "_on_Button_pressed", [type])
        types.add_child(button)
    var top = types.get_child(0)
    var bottom = types.get_child(types.get_child_count() - 1)
    top.focus_neighbour_top = bottom.get_path()
    bottom.focus_neighbour_bottom = top.get_path()

func _reload():
    # Load everything from scratch
    _restart()
    _load_scores(_level)
    $NamesContainer/Names/Current.text = _level.NAME
    $Level/Left/Code.text = _format(_level.DESCRIPTION) + "\n\n" + _level.CODE.strip_edges()
    $Level/Right/Info/ControlsContainer/Controls.text = _format(_level.CONTROLS)

func _format(text):
    # Helper method to format text
    return text.strip_edges().replace("\n", " ").replace("  ", "\n\n")

func _restart():
    # Only load in a restarted simulation
    $NamesContainer/Names/Current.grab_focus()
    _level = LEVELS[_index].new(ArrayModel.new(_size, _data_type))
    _level.connect("done", self, "_on_ComparisonSort_done")
    var view = $Level/Right/Display if $Level.visible else $BigDisplay
    var other = $BigDisplay if $Level.visible else $Level/Right/Display
    # Delete both ArrayViews if they exist
    if other.get_node_or_null("HBoxContainer") != null:
        other.get_node("HBoxContainer").queue_free()
    var array_view = view.get_node_or_null("HBoxContainer")
    if array_view != null:
        # XXX: remove_child is needed in order to ensure that the added
        # child will be named "HBoxContainer" and not "HBoxContainer2"
        # because the other ArrayView hasn't been queue_free'd yet
        view.remove_child(array_view)
        array_view.queue_free()
    view.add_child(ArrayView.new(_level), true)
    $Timer.start()

func _load_scores(level):
    var data = $Level/Right/Info/ScoresContainer/Scores
    for i in range(log(MAX_SIZE / MIN_SIZE) / log(2) + 1):
        var time = str(GlobalScore.get_time(level.NAME, MIN_SIZE * pow(2, i)))
        if time == "inf":
            data.get_child(i).get_node("Time").text = "INF"
        else:
            data.get_child(i).get_node("Time").text = "%.3f" % float(time)

func _switch_level(index):
    _restart = false
    if index == -1:
        _index = LEVELS.size() - 1
    elif index == LEVELS.size():
        _index = 0
    else:
        _index = index
    _reload()

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        GlobalScene.change_scene("res://scenes/menu.tscn", {"keep_music_setting": true})
    if event.is_action_pressed("ui_left", true):
        _switch_level(_index - 1)
    if event.is_action_pressed("ui_right", true):
        _switch_level(_index + 1)

func _on_ComparisonSort_done():
    $Timer.stop()
    _restart = true
    yield(get_tree().create_timer(1), "timeout")
    if _restart:
        _restart()

func _on_Timer_timeout():
    _level.next(null)

func _on_Current_pressed():
    GlobalScene.change_scene("res://scenes/play.tscn",
        {"level": LEVELS[_index], "size": _size, "data_type": _data_type})

func _on_Button_pressed(data_type):
    var display = $Level/Right/Display if $Level.visible else $BigDisplay
    display.get_node("TypesContainer").hide()
    display.get_node("HBoxContainer").show()
    $Timer.start()
    _data_type = ArrayModel.DATA_TYPES[data_type]
    _restart()

func _on_Previous_pressed():
    _switch_level(_index - 1)

func _on_Next_pressed():
    _switch_level(_index + 1)

func _on_Difficulty_pressed(difficulty):
    _restart = false
    _size = int(MIN_SIZE * pow(2, difficulty.get_index()))
    for child in difficulty.get_parent().get_children():
        if child.name != "Controls":
            child.get_child(0).add_color_override("font_color", GlobalTheme.GREEN)
    difficulty.get_child(0).add_color_override("font_color", GlobalTheme.ORANGE)
    _restart()

func _on_Custom_pressed():
    _restart = false
    var display = $Level/Right/Display
    display.get_node("HBoxContainer").hide()
    display.get_node("HBoxContainer").sound.set_process(false)
    display.get_node("TypesContainer").show()
    $Timer.stop()
    display.get_node("TypesContainer/Types").get_child(0).grab_focus()

func _on_Slower_pressed():
    $Timer.wait_time = min($Timer.wait_time * 4, MAX_WAIT)

func _on_Faster_pressed():
    $Timer.wait_time = max($Timer.wait_time / 4, MIN_WAIT)

func _on_Back_pressed():
    GlobalScene.change_scene("res://scenes/menu.tscn", {"keep_music_setting": true})

func _on_BigPicture_pressed():
    _restart = false
    $Level/Right/Display/TypesContainer.hide()
    $Level.visible = not $Level.visible
    $BigDisplay.visible = not $BigDisplay.visible
    if $BigDisplay.visible:
        $NamesContainer/Names/BigPicture.add_color_override("font_color", GlobalTheme.ORANGE)
    else:
        $NamesContainer/Names/BigPicture.add_color_override("font_color", GlobalTheme.GREEN)
    _restart()
