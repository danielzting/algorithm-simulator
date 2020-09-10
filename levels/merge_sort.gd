class_name MergeSort
extends ComparisonSort

const NAME = "MERGE SORT"
const DESCRIPTION = """
Merge sort merges subarrays of increasing size by setting a pointer to
the head of each half. Then it repeatedly copies the smaller pointed
element and increments that side's pointer. When one side is exhausted,
it copies the rest of the other side and overwrites the two halves with
the merged copy.
"""
const CONTROLS = """
Press the ARROW KEY corresponding to the side that the smaller
highlighted element is on or the non-exhausted side.
"""
const CODE = """
def merge_sort(a):
    size = 1
    while size < len(a):
        for block in range(len(a) / size / 2):
            merged = []
            begin = size * 2 * block
            i = begin
            j = begin + size
            while len(merged) != size * 2:
                if i >= begin + size:
                    merged += a[j:begin + size * 2]
                elif j >= begin + size * 2:
                    merged += a[i:begin + size]
                elif a[i] < a[j]:
                    merged.append(a[i++])
                else:
                    merged.append(a[j++])
            a[begin:begin + size * 2] = merged
        size *= 2
"""
const ACTIONS = {
    "LEFT": "Left",
    "RIGHT": "Right",
}
var _left = 0 # Index of left subarray pointer
var _right = 1 # Index of right subarray pointer
var _sub_size = 2 # Combined size of left and right subarrays
var _sub_no = 0 # Currently being merged left-right pair number

func _init(array).(array):
    pass

func next(action):
    if _left == _get_middle():
        if action != null and action != ACTIONS.RIGHT:
            return emit_signal("mistake")
        array.emit_signal("removed", _right)
        _right += 1
    elif _right == _get_end():
        if action != null and action != ACTIONS.LEFT:
            return emit_signal("mistake")
        array.emit_signal("removed", _left)
        _left += 1
    elif array.at(_left) <= array.at(_right):
        if action != null and action != ACTIONS.LEFT:
            return emit_signal("mistake")
        array.emit_signal("removed", _left)
        _left += 1
    else:
        if action != null and action != ACTIONS.RIGHT:
            return emit_signal("mistake")
        array.emit_signal("removed", _right)
        _right += 1
    # If both ends have been reached, merge and advance to next block
    if _left == _get_middle() and _right == _get_end():
        array.sort(_get_begin(), _get_end())
        _sub_no += 1
        # If last block has been completed, go up a level
        if _sub_no == array.size / (_sub_size):
            _sub_size *= 2
            _sub_no = 0
            if _sub_size == array.size * 2:
                emit_signal("done")
        # Update pointers
        _left = _get_begin()
        _right = _get_middle()

func get_effect(i):
    var is_left = _left != _get_middle() and i == _left
    var is_right = _right != _get_end() and i == _right
    if is_left or is_right:
        return EFFECTS.HIGHLIGHTED
    if i < _left or i >= _get_middle() and i < _right or i >= _get_end():
        return EFFECTS.DIMMED
    return EFFECTS.NONE

func _get_begin():
    """Get the index of the left subarray's head."""
    return _sub_no * _sub_size

func _get_middle():
    """Get the index of the right subarray's head."""
    return _sub_no * _sub_size + _sub_size / 2

func _get_end():
    """Get the index of one past the right subarray's tail."""
    return _sub_no * _sub_size + _sub_size

func get_frac():
    if _left == _get_middle():
        return array.frac(_right)
    if _right == _get_end():
        return array.frac(_left)
    return (array.frac(_left) + array.frac(_right)) / 2.0
