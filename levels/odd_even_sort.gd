"""
ODD-EVEN SORT


Odd-even sort is a variant of bubble sort that alternates on elements at
odd and even indices.


If the two highlighted elements are out of order, hit LEFT ARROW to swap
them. Otherwise, hit RIGHT ARROW to continue.
"""

class_name OddEvenSort
extends ComparisonSort

const CODE = """
def odd_even_sort(a):
    swapped = true
    while swapped:
        swapped = false
        for i in range(1, len(a) - 1, 2):
            if a[i] > a[i + 1]:
                a.swap(i, i + 1)
                swapped = true
        for i in range(0, len(a) - 1, 2):
            if a[i] > a[i + 1]:
                a.swap(i, i + 1)
                swapped = true
"""
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

func get_frac():
    return (array.frac(_index) + array.frac(_index + 1)) / 2.0
