class_name InsertionSort
extends ComparisonSort

const NAME = "INSERTION SORT"
const ABOUT = """
Insertion sort goes through the array and inserts each
element into its correct position. It is most similar to how most people
would sort a deck of cards. It is also slow on large arrays but it is
one of the faster quadratic algorithms. It is often used to sort smaller
subarrays in hybrid sorting algorithms.
"""
const CONTROLS = """
Hit LEFT ARROW to SWAP the two highlighted elements as long as they are
out of order. When this is no longer the case, hit RIGHT ARROW to
advance.
"""

var _end = 1
var _index = _end

func _init(array).(array):
    pass

func check(action):
    if array.get(_index - 1) > array.get(_index):
        return action == ACTIONS.SWAP
    else:
        return action == ACTIONS.NO_SWAP

func next():
    if array.get(_index - 1) > array.get(_index):
        array.swap(_index - 1, _index)
        _index -= 1
        if _index == 0:
            _grow()
    else:
        _grow()

func _grow():
    _end += 1
    if _end == array.size:
        emit_signal("done")
    _index = _end

func emphasized(i):
    return i == _index or i == _index - 1
