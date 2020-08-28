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

var _index = 0
var _level: ComparisonSort
var _size = ArrayModel.DEFAULT_SIZE

func _ready():
    _level = LEVELS[_index].new(ArrayModel.new(_size))
    _level.connect("done", self, "_on_ComparisonSort_done")
    $NamesContainer/Names/Current.text = _level.NAME
    for child in $Level/Info/Display.get_children():
        child.queue_free()
    $Level/Info/Display.add_child(ArrayView.new(_level))
    $Timer.start()
    _load_scores(_level)

func _load_scores(level):
    var data = $Level/Info/Footer/Meta/ScoresContainer/Scores/Data
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
    _ready()

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        GlobalScene.change_scene("res://scenes/menu.tscn")
    if event.is_action_pressed("ui_left", true):
        _switch_level(_index - 1)
    if event.is_action_pressed("ui_right", true):
        _switch_level(_index + 1)
    if event.is_action_pressed("bigger"):
        _size = min(_size * 2, MAX_SIZE)
        _ready()
    if event.is_action_pressed("smaller"):
        _size = max(_size / 2, MIN_SIZE)
        _ready()
    if event.is_action_pressed("faster"):
        $Timer.wait_time = max($Timer.wait_time / 2, MIN_WAIT)
    if event.is_action_pressed("slower"):
        $Timer.wait_time = min($Timer.wait_time * 2, MAX_WAIT)
    if event.is_action_pressed("ui_accept"):
        GlobalScene.change_scene("res://scenes/play.tscn",
            {"level": LEVELS[_index], "size": _size})

func _on_ComparisonSort_done():
    $Timer.stop()
    yield(get_tree().create_timer(1), "timeout")
    if _level.array.is_sorted():
        _ready()

func _on_Timer_timeout():
    _level.next(null)
