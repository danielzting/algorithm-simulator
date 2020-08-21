"""
CYCLE SORT

Cycle sort repeatedly counts the number of elements less than the first
and swaps it with that index until the smallest element is reached. Then
it does this process starting at the next out-of-place element.

If the highlighted element is less than the pointer, hit LEFT ARROW.
Otherwise, hit RIGHT ARROW.
"""

class_name CycleSort
extends ComparisonSort

const ACTIONS = {
    "SMALLER": "Left",
    "BIGGER": "Right",
}
var _pointer = 0
var _index = 0
var _smaller = 0

func _init(array).(array):
    pass

func next(action):
    if array.at(_index) < array.at(_pointer):
        if action != null and action != ACTIONS.SMALLER:
            return emit_signal("mistake")
        _smaller += 1
    elif array.at(_index) >= array.at(_pointer):
        if action != null and action != ACTIONS.BIGGER:
            return emit_signal("mistake")
    _index += 1
    if _index == array.size:
        array.swap(_pointer, _smaller)
        while array.at(_pointer) == _pointer + 1:
            _pointer += 1
            if _pointer == array.size:
                return emit_signal("done")
        _index = 0
        _smaller = 0

func get_effect(i):
    if i == _index:
        return EFFECTS.HIGHLIGHTED
    return EFFECTS.NONE

func get_pointer():
    return _pointer

func get_frac():
    return array.frac(_index)
