"""
INSERTION SORT


Insertion sort goes through the array and inserts each element into its
correct place, like how most people would sort a hand of playing cards.

It is one of the fastest quadratic algorithms in practice and is
efficient on small or almost sorted data. It is also simple, stable, and
in-place. For these reasons it is sometimes used within faster divide
and conquer algorithms when the array has been divided to a small size.


If the two highlighted elements are out of order, hit LEFT ARROW to swap
them. Otherwise, hit RIGHT ARROW to continue.
"""

class_name InsertionSort
extends ComparisonSort

const CODE = """
def insertion_sort(a):
    for i in range(len(a)):
        j = i
        while j > 0 and a[j - 1] > a[j]:
            a.swap(j - 1, j)
            j -= 1
"""
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
