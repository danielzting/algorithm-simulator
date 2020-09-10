class_name BubbleSort
extends ComparisonSort

const NAME = "BUBBLE SORT"
const DESCRIPTION = """
Bubble sort looks at consecutive pairs of elements and swaps them if
they are out of order, finishing when it has gone through the whole
array from beginning to end without a single swap. The actual level
contains an optimization that skips over elements guaranteed to be
already in place.

Due to its simplicity, it is commonly taught as the first sorting
algorithm students learn in computer science classes, but is rarely used
in real life because it is slow on large data and other simple quadratic
algorithms like insertion sort perform better.
"""
const CONTROLS = """
If the two highlighted elements are out of order, hit LEFT ARROW to swap
them. Otherwise, hit RIGHT ARROW to continue.
"""
const CODE = """
def bubble_sort(a):
    swapped = true
    while swapped:
        swapped = false
        for i in range(len(a) - 1):
            if a[i] > a[i + 1]:
                a.swap(i, i + 1)
                swapped = true
"""
const ACTIONS = {
    "SWAP": "Left",
    "CONTINUE": "Right",
}
var _index = 0 # First of two elements being compared
var _end = array.size # Beginning of sorted subarray
var _swapped = false

func _init(array).(array):
    pass

func next(action):
    if array.at(_index) > array.at(_index + 1):
        if action != null and action != ACTIONS.SWAP:
            return emit_signal("mistake")
        array.swap(_index, _index + 1)
        _swapped = true
    elif action != null and action != ACTIONS.CONTINUE:
        return emit_signal("mistake")
    _index += 1
    # Prevent player from having to spam tap through the end
    if _index + 1 == _end:
        if not _swapped or _end == 2: # Stop if only one element left
            emit_signal("done")
        _index = 0
        _end -= 1
        _swapped = false

func get_effect(i):
    if i == _index or i == _index + 1:
        return EFFECTS.HIGHLIGHTED
    if i >= _end:
        return EFFECTS.DIMMED
    return EFFECTS.NONE

func get_frac():
    return (array.frac(_index) + array.frac(_index + 1)) / 2.0
