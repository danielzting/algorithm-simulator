"""
SELECTION SORT


Selection sort incrementally builds a sorted subarray by finding the
smallest unprocessed element and putting it in place.

It is not very useful in real life as it is beat by insertion sort.
However, it has the distinguishing feature of making the least number
of swaps in the worst case.


If the two highlighted elements are out of order, hit LEFT ARROW to swap
them. Otherwise, hit RIGHT ARROW to continue.
"""


class_name SelectionSort
extends ComparisonSort

const CODE = """
def selection_sort(a):
    for i in range(len(a)):
        smallest = i
        for j in range(i + 1, len(a)):
            if a[j] < a[smallest]:
                smallest = j
        a.swap(i, smallest)
"""
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
