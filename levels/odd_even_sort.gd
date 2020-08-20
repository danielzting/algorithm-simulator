"""
ODD-EVEN SORT

Odd-even sort is a variant of bubble sort that alternates on elements at
odd and even indices.

If the two highlighted elements are out of order, hit LEFT ARROW to swap
them. Otherwise, hit RIGHT ARROW to continue.
"""

class_name OddEvenSort
extends ComparisonSort

const ACTIONS = {
    "SWAP": "Left",
    "CONTINUE": "Right",
}
var _index = 1
var _swapped = false

func _init(array).(array):
    pass

func next(action):
    if array.at(_index) > array.at(_index + 1):
        if action != null and action != ACTIONS.SWAP:
            return emit_signal("mistake")
        array.swap(_index, _index + 1)
        _swapped = true
    elif action != null  and action != ACTIONS.CONTINUE:
        return emit_signal("mistake")
    _index += 2
    if _index + 1 >= array.size:
        if _index % 2 == 0 and not _swapped:
            emit_signal("done")
        _index = 1 if _index % 2 == 0 else 0
        _swapped = false

func get_effect(i):
    if i == _index or i == _index + 1:
        return EFFECTS.HIGHLIGHTED
    return EFFECTS.NONE
