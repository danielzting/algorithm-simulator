"""
CYCLE SORT


Cycle sort looks at the first element and finds its correct final
position by counting the number of elements smaller than it. Then it
saves the element at that index, writes the first element there, and
repeats the process with the saved element. For the sake of
demonstration, in the actual level, swaps are used instead.

This results in a quadratic runtime but gives it the special property
of being optimal in the number of writes to the array. This makes cycle
sort useful in storage types where writes are very expensive or reduce
its lifespan.


If the highlighted element is less than the element below the blue
pointer, hit LEFT ARROW. Otherwise, hit RIGHT ARROW.
"""

class_name CycleSort
extends ComparisonSort

const CODE = """
def cycle_sort(a):
    for i in range(len(a)):
        while True:
            position = 0
            for j in a:
                if a[j] > a[i]:
                    position += 1
            if i == position:
                break
            a.swap(i, position)
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
