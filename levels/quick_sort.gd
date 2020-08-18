"""
QUICKSORT

Quicksort designates the last element as the pivot and puts everything
less than the pivot before it and everything greater after it. This
partitioning is done by iterating through the array while keeping track
of a pointer initially set to the first element. Every time an element
less than the pivot is encountered, it is swapped with the pointed
element and the pointer moves forward. At the end, the pointer and pivot
are swapped, and the process is repeated on the left and right halves.

If the highlighted element is less than the pivot or the pivot has been
reached, press LEFT ARROW to swap it with the pointer. Otherwise, press
RIGHT ARROW to move on.
"""

class_name QuickSort
extends ComparisonSort

const ACTIONS = {
    "SWAP": "Left",
    "CONTINUE": "Right",
}
var _index = 0 # Index of element being compared with pivot
var _pointer = 0 # Boundary between partitions
# Bookkeep simulated recursion with a binary tree of subarray bounds
var _stack = BinaryTreeModel.new(Vector2(0, array.size - 1))

func _init(array).(array):
    pass

func next(action):
    if _index == _pivot():
        if action != null and action != ACTIONS.SWAP:
            return emit_signal("mistake")
        array.swap(_index, _pointer)
        if _pointer - _begin() > 1:
            _stack.left = BinaryTreeModel.new(Vector2(_begin(), _pointer - 1))
            _stack = _stack.left
        elif _pivot() - _pointer > 1:
            _stack.right = BinaryTreeModel.new(Vector2(_pointer + 1, _pivot()))
            _stack = _stack.right
        else:
            while (_stack.parent.right != null
                or _stack.parent.left.value.y + 2 >= _stack.parent.value.y):
                _stack = _stack.parent
                if _stack.parent == null:
                    return emit_signal("done")
            _stack.parent.right = BinaryTreeModel.new(Vector2(
                _stack.parent.left.value.y + 2, _stack.parent.value.y))
            _stack = _stack.parent.right
        _index = _begin()
        _pointer = _index
    elif array.at(_index) < array.at(_pivot()):
        if action != null and action != ACTIONS.SWAP:
            return emit_signal("mistake")
        array.swap(_index, _pointer)
        _index += 1
        _pointer += 1
    else:
        if action != null and action != ACTIONS.CONTINUE:
            return emit_signal("mistake")
        _index += 1

func _begin():
    return _stack.value.x

func _pivot():
    return _stack.value.y

func get_effect(i):
    if i < _begin() or i > _pivot():
        return EFFECTS.DIMMED
    if i == _index or i == _pivot():
        return EFFECTS.HIGHLIGHTED
    return EFFECTS.NONE

func get_pointer():
    return _pointer
