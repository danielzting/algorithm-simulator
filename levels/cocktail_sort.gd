"""
COCKTAIL SORT

Cocktail shaker sort is a variation of bubble sort that
alternates going backwards and forwards.

If the two highlighted elements are out of order, hit LEFT ARROW to swap
them. Otherwise, hit RIGHT ARROW to continue.
"""

class_name CocktailSort
extends ComparisonSort

const ACTIONS = {
    "SWAP": "Left",
    "CONTINUE": "Right",
}
var _index = 0 # First of two elements being compared
var _sorted = 0 # Size of the sorted subarray at the end of the array
var _forwards = true
var _swapped = false

func _init(array).(array):
    pass

func next(action):
    if array.at(_index) > array.at(_index + 1):
        if action != null and action != ACTIONS.SWAP:
            return emit_signal("mistake")
        array.swap(_index, _index + 1)
        _swapped = true
    else:
        if action != null and action != ACTIONS.CONTINUE:
            return emit_signal("mistake")
    if _forwards:
        _index += 1
        if _index == array.size - _sorted - 1:
            if not _swapped:
                emit_signal("done")
            _swapped = false
            _forwards = false
            _index -= 2
            _sorted += 1
    else:
        _index -= 1
        if _index == _sorted - 2:
            if not _swapped:
                emit_signal("done")
            _swapped = false
            _forwards = true
            _index += 2

func get_effect(i):
    if i == _index or i == _index + 1:
        return EFFECTS.HIGHLIGHTED
    if i < _sorted and _forwards == true or i < _sorted - 1 or i >= array.size - _sorted:
        return EFFECTS.DIMMED
    return EFFECTS.NONE

func get_frac():
    return (array.frac(_index) + array.frac(_index + 1)) / 2.0
