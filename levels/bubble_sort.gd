class_name BubbleSort
extends ComparisonSort

const NAME = "BUBBLE SORT"
const ABOUT = """
Bubble sort iterates through the array and looks at each pair of
elements, swapping them if they are out of order. When it has gone
through the entire array without swapping a single pair, it has
finished. Though simple to understand, bubble sort is hopelessly
inefficient on all but the smallest of arrays.
"""
const CONTROLS = """
If the two highlighted elements are out of order, hit LEFT ARROW to swap
them. Otherwise, hit RIGHT ARROW to continue.
"""

var _index = 0
var _swapped = false

func _init(array).(array):
    pass

func check(action):
    if array.get(_index) > array.get(_index + 1):
        return action == ACTIONS.SWAP
    else:
        return action == ACTIONS.NO_SWAP

func next():
    if array.get(_index) > array.get(_index + 1):
        array.swap(_index, _index + 1)
        _swapped = true
    _index += 1
    if _index == array.size - 1:
        if not _swapped:
            emit_signal("done")
        _index = 0
        _swapped = false

func get_effect(i):
    if i == _index or i == _index + 1:
        return EFFECTS.HIGHLIGHTED
    return EFFECTS.NONE
