class_name SelectionSort
extends ComparisonSort

const NAME = "SELECTION SORT"
const ABOUT = """
Selection sort incrementally builds a sorted array by repeatedly looking
for the smallest element and swapping it onto the end of the sorted
portion of the array, which initially starts with size zero but grows
after each round. It is faster than an unoptimized bubble sort but
slower than insertion sort.
"""
const CONTROLS = """
Keep on hitting RIGHT ARROW until you encounter an element that is
smaller than the left highlighted element, then hit LEFT ARROW and
repeat.
"""

var _base = 0 # Size of sorted subarray
var _index = 1 # Index of tentative new smallest

func _init(array).(array):
    pass

func next(action):
    if array.at(_base) > array.at(_index):
        if action != null and action != ACTIONS.SWAP:
            return emit_signal("mistake")
        array.swap(_base, _index)
    elif action != null and action != ACTIONS.NO_SWAP:
        return emit_signal("mistake")
    _index += 1
    if _index == array.size:
        _base += 1
        _index = _base + 1
    if _base == array.size - 1:
        emit_signal("done")

func get_effect(i):
    if i == _index or i == _base:
        return EFFECTS.HIGHLIGHTED
    if i <= _base:
        return EFFECTS.DIMMED
    return EFFECTS.NONE
