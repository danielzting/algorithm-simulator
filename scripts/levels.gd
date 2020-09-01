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

const MIN_WAIT = 1.0 / 32 # Should be greater than maximum frame time
const MAX_WAIT = 4
const MIN_SIZE = 8
const MAX_SIZE = 128

var _index = LEVELS.find(GlobalScene.get_param("level"))
var _level: ComparisonSort
var _size = GlobalScene.get_param("size", ArrayModel.DEFAULT_SIZE)
var _data_type = GlobalScene.get_param(
    "data_type", ArrayModel.DATA_TYPES.RANDOM_UNIQUE)

func _ready():
    var types = $Level/Right/Display/TypesContainer/Types
    for type in ArrayModel.DATA_TYPES:
        var button = Button.new()
        button.text = type.replace("_", " ")
        button.connect("pressed", self, "_on_Button_pressed", [type])
        types.add_child(button)
    var top = types.get_child(0)
    var bottom = types.get_child(types.get_child_count() - 1)
    top.focus_neighbour_top = bottom.get_path()
    bottom.focus_neighbour_bottom = top.get_path()
    _reload()

func _reload():
    $NamesContainer/Names/Current.grab_focus()
    if _index == -1:
        _index = 0
    _level = LEVELS[_index].new(ArrayModel.new(_size, _data_type))
    _level.connect("done", self, "_on_ComparisonSort_done")
    _load_scores(_level)
    # Load level information
    $NamesContainer/Names/Current.text = _level.NAME
    $Level/Left/Code.text = _level.DESCRIPTION
    $Level/Right/Info/ControlsContainer/Controls.text = _level.CONTROLS
    var view = $Level/Right/Display/ArrayView
    $Level/Right/Display.remove_child(view)
    view.queue_free()
    view = ArrayView.new(_level)
    view.name = "ArrayView"
    $Level/Right/Display.add_child(view)
    $Timer.start()

func _load_scores(level):
    var data = $Level/Right/Info/ScoresContainer/Scores/Data
    data.get_node("Times").text = ""
    for i in data.get_node("Sizes").text.split("\n"):
        var time = str(GlobalScore.get_time(level.NAME, int(i)))
        data.get_node("Times").text += time
        if int(i) != MAX_SIZE:
            data.get_node("Times").text += "\n"

func _switch_level(index):
    if index == -1:
        _index = LEVELS.size() - 1
    elif index == LEVELS.size():
        _index = 0
    else:
        _index = index
    _reload()

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        GlobalScene.change_scene("res://scenes/menu.tscn")
    if event.is_action_pressed("ui_left", true):
        _switch_level(_index - 1)
    if event.is_action_pressed("ui_right", true):
        _switch_level(_index + 1)
    if event.is_action_pressed("bigger"):
        _size = min(_size * 2, MAX_SIZE)
        _reload()
    if event.is_action_pressed("smaller"):
        _size = max(_size / 2, MIN_SIZE)
        _reload()
    if event.is_action_pressed("faster"):
        $Timer.wait_time = max($Timer.wait_time / 2, MIN_WAIT)
    if event.is_action_pressed("slower"):
        $Timer.wait_time = min($Timer.wait_time * 2, MAX_WAIT)
    if event.is_action_pressed("change_data"):
        AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
        $Level/Right/Display/ArrayView.hide()
        $Level/Right/Display/TypesContainer.show()
        $Timer.stop()
        $Level/Right/Display/TypesContainer/Types.get_child(0).grab_focus()

func _on_ComparisonSort_done():
    $Timer.stop()
    yield(get_tree().create_timer(1), "timeout")
    if _level.array.is_sorted():
        _reload()

func _on_Timer_timeout():
    _level.next(null)

func _on_Current_pressed():
    GlobalScene.change_scene("res://scenes/play.tscn",
        {"level": LEVELS[_index], "size": _size, "data_type": _data_type})

func _on_Button_pressed(data_type):
    AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
    $Level/Right/Display/TypesContainer.hide()
    $Level/Right/Display/ArrayView.show()
    $Timer.start()
    _data_type = ArrayModel.DATA_TYPES[data_type]
    _reload()
