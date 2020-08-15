class_name CombSort
extends ComparisonSort

const NAME = "COMB SORT"
const ABOUT = """
Comb sort is a variant of bubble sort that operates on gapped arrays.
"""
const CONTROLS = """
If the two highlighted elements are out of order, hit LEFT ARROW to swap
them. Otherwise, hit RIGHT ARROW to continue.
"""

const SHRINK_FACTOR = 1.3
const ACTIONS = {
    "SWAP": "Left",
    "CONTINUE": "Right",
}
var _gap: int = array.size / SHRINK_FACTOR
var _index = 0 # First of two elements being compared
var _end = array.size # Beginning of sorted subarray
var _swapped = false

func _init(array).(array):
    pass

func next(action):
    if array.at(_index) > array.at(_index + _gap):
        if action != null and action != ACTIONS.SWAP:
            return emit_signal("mistake")
        array.swap(_index, _index + _gap)
        _swapped = true
    elif action != null and action != ACTIONS.CONTINUE:
        return emit_signal("mistake")
    _index += 1
    if _index + _gap >= array.size:
        if not _swapped and _gap == 1:
            emit_signal("done")
        _gap /= SHRINK_FACTOR
        _gap = max(_gap, 1)
        _index = 0
        _swapped = false

func get_effect(i):
    if i == _index or i == _index + _gap:
        return EFFECTS.HIGHLIGHTED
    if i >= _end:
        return EFFECTS.DIMMED
    return EFFECTS.NONE
