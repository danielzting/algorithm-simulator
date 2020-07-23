class_name MergeSort
extends ComparisonSort

const NAME = "MERGE SORT"
const ABOUT =  """
Merge sort is an efficient sorting algorithm that splits the array into
single-element chunks. Then it merges each pair of chunks until only one
sorted chunk is left by repeatedly choosing the smaller element at the
head of each chunk and moving the head back. However, it needs an entire
array's worth of auxiliary memory.
"""
const CONTROLS = """
Press the ARROW KEY corresponding to the side that the smaller
highlighted element is on. If you've reached the end of one side, press
the other side's ARROW KEY.
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
        _right += 1
    elif _right == _get_end():
        if action != null and action != ACTIONS.LEFT:
            return emit_signal("mistake")
        _left += 1
    elif array.at(_left) <= array.at(_right):
        if action != null and action != ACTIONS.LEFT:
            return emit_signal("mistake")
        _left += 1
    else:
        if action != null and action != ACTIONS.RIGHT:
            return emit_signal("mistake")
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
