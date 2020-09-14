class_name CycleSort
extends ComparisonSort

const NAME = "CYCLE SORT"
const DESCRIPTION = """
Cycle sort looks at the first element and finds its correct final
position by counting the number of elements smaller than it. Then it
saves the element at that index, writes the first element there, and
repeats the process with the saved element. For the sake of
demonstration, the actual level uses swaps instead and skips over
elements already in place.

This results in a quadratic runtime but gives it the special property
of being optimal in the number of writes to the array, making it useful
when writes are expensive.
"""
const CONTROLS = """
If the highlighted element is less than the element below the blue
pointer, hit LEFT ARROW. Otherwise, hit RIGHT ARROW.
"""
const CODE = """
def cycle_sort(a):
    for i in range(len(a)):
        while True:
            less = equal = 0
            for element in a:
                if element < a[i]:
                    less += 1
                elif element == a[i]:
                    equal += 1
            if less <= i and i < less + equal:
                break
            while a[i] == a[less]:
                less += 1
            a.swap(i, less)
"""
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
        # Skip over duplicates to avoid infinite cycling
        while _smaller != _pointer and array.at(_pointer) == array.at(_smaller):
            _smaller += 1
        array.swap(_pointer, _smaller)
        while array.is_in_place(_pointer):
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
