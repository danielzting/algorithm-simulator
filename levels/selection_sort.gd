"""
SELECTION SORT

Selection sort incrementally builds a sorted array by repeatedly looking
for the smallest element and swapping it onto the end of the sorted
portion of the array, which initially starts with size zero but grows
after each round. It is faster than an unoptimized bubble sort but
slower than insertion sort.

Keep on hitting RIGHT ARROW until you encounter an element that is
smaller than the left highlighted element, then hit LEFT ARROW and
repeat.
"""


class_name SelectionSort
extends ComparisonSort

const ACTIONS = {
    "SWAP": "Left",
    "CONTINUE": "Right",
}
var _base = 0 # Size of sorted subarray
var _min = 0 # Index of smallest known element
var _index = 1 # Element currently being compared

func _init(array).(array):
    pass

func next(action):
    if array.at(_index) < array.at(_min):
        if action != null and action != ACTIONS.SWAP:
            return emit_signal("mistake")
        _min = _index
    elif action != null and action != ACTIONS.CONTINUE:
        return emit_signal("mistake")
    _index += 1
    if _index == array.size:
        array.swap(_base, _min)
        _base += 1
        _min = _base
        _index = _base + 1
    if _base == array.size - 1:
        emit_signal("done")

func get_effect(i):
    if i == _min or i == _index:
        return EFFECTS.HIGHLIGHTED
    if i < _base:
        return EFFECTS.DIMMED
    return EFFECTS.NONE

func get_pointer():
    return _min

func get_frac():
    return array.frac(_index)
