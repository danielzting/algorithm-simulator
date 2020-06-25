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

var _left = 0 # Index of left subarray pointer
var _right = 1 # Index of right subarray pointer
var _sub_size = 2 # Combined size of left and right subarrays
var _sub_no = 0 # Currently being merged left-right pair number

func _init(array).(array):
    pass

func next(action):
    if _left == -1:
        if action != null and action != ACTIONS.RIGHT:
            return emit_signal("mistake")
        _right += 1
    elif _right == -1:
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
    # Test if end of subarrays have been reached
    if _left == _get_middle():
        _left = -1
    if _right == _get_end():
        _right = -1
    # If both ends have been reached, merge and advance to next block
    if _left == -1 and _right == -1:
        array.sort(_get_begin(), _get_end())
        _sub_no += 1
        _left = _get_begin()
        _right = _get_middle()
        # If last block has been completed, go up a level
        if _sub_no == array.size / (_sub_size):
            _sub_size *= 2
            _sub_no = 0
            _left = _get_begin()
            _right = _get_middle()
            if _sub_size == array.size * 2:
                emit_signal("done")

func get_effect(i):
    if i == _left or i == _right:
        return EFFECTS.HIGHLIGHTED
    if i < _sub_no * _sub_size or i >= _sub_no * _sub_size + _sub_size:
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
