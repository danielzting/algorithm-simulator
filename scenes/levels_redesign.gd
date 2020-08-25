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

var _index = 0
var _level: ComparisonSort

func _ready():
    _level = LEVELS[_index].new(ArrayModel.new())
    $Names/Current.text = "< " + _level.NAME + " >"

func _switch_level(index):
    if index == -1:
        _index = LEVELS.size() - 1
    elif index == LEVELS.size():
        _index = 0
    else:
        _index = index
    _ready()

func _input(event):
    if event.is_action_pressed("ui_left", true):
        _switch_level(_index - 1)
    if event.is_action_pressed("ui_right", true):
        _switch_level(_index + 1)
