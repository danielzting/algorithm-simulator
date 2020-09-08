"""
SHELL SORT


Shell sort is a variation of insertion sort that sorts arrays separated
by gaps.


Hit LEFT ARROW to swap the two highlighted elements as long as they are
out of order. When this is no longer the case, hit RIGHT ARROW to
advance.
"""

class_name ShellSort
extends ComparisonSort

const CODE = """
def shell_sort(a):
    gap = len(a)
    while gap != 1:
        gap = max(gap / 2, 1)
        for i in range(gap):
            for j in range(i, len(a) - gap, gap):
                k = j
                while k > gap and a[k - gap] > a[k]:
                    a.swap(k - gap, k)
                    k -= gap
"""
const ACTIONS = {
    "SWAP": "Left",
    "CONTINUE": "Right",
}
var _gap = array.size / 2
var _begin = 0 # First element of subarray
var _end = _gap # End of the sorted subarray
var _index = _gap # Position of element currently being inserted

func _init(array).(array):
    pass

func next(action):
    if array.at(_index - _gap) > array.at(_index):
        if action != null and action != ACTIONS.SWAP:
            return emit_signal("mistake")
        array.swap(_index - _gap, _index)
        _index -= _gap
        if _index - _gap < 0:
            _grow()
    else:
        if action != null and action != ACTIONS.CONTINUE:
            return emit_signal("mistake")
        _grow()

func get_effect(i):
    if i == _index - _gap or i == _index:
        return EFFECTS.HIGHLIGHTED
    if (i - _begin) % _gap != 0:
        return EFFECTS.DIMMED
    return EFFECTS.NONE

func get_pointer():
    return _end

func _grow():
    _end += _gap
    _index = _end
    if _end >= array.size:
        _begin += 1
        if _begin >= _gap:
            _gap /= 2
            if _gap == 0:
                emit_signal("done")
            _begin = 0
        _end = _gap + _begin
        _index = _gap + _begin

func get_frac():
    return (array.frac(_index - _gap) + array.frac(_index)) / 2.0
