"""
INSERTION SORT


Insertion sort goes through the array and inserts each
element into its correct position. It is most similar to how most people
would sort a deck of cards. It is also slow on large arrays but it is
one of the faster quadratic algorithms. It is often used to sort smaller
subarrays in hybrid sorting algorithms.


Hit LEFT ARROW to swap the two highlighted elements as long as they are
out of order. When this is no longer the case, hit RIGHT ARROW to
advance.
"""

class_name InsertionSort
extends ComparisonSort

const ACTIONS = {
    "SWAP": "Left",
    "CONTINUE": "Right",
}
var _end = 1 # Size of the sorted subarray
var _index = 1 # Position of element currently being inserted

func _init(array).(array):
    pass

func next(action):
    if array.at(_index - 1) > array.at(_index):
        if action != null and action != ACTIONS.SWAP:
            return emit_signal("mistake")
        array.swap(_index - 1, _index)
        _index -= 1
        if _index == 0:
            _grow()
    else:
        if action != null and action != ACTIONS.CONTINUE:
            return emit_signal("mistake")
        _grow()

func get_effect(i):
    if i == _index or i == _index - 1:
        return EFFECTS.HIGHLIGHTED
    if i <= _end:
        return EFFECTS.DIMMED
    return EFFECTS.NONE

func _grow():
    _end += 1
    if _end == array.size:
        emit_signal("done")
    _index = _end

func get_frac():
    return (array.frac(_index - 1) + array.frac(_index)) / 2.0
