"""
A plain old one-dimensional random access array wrapper around the
built-in class.
"""

class_name ArrayModel
extends Reference

var array = []
var size = 0

func _init(size=16):
    """Randomize the array."""
    for i in range(1, size + 1):
        array.append(i)
    array.shuffle()
    self.size = size

func get(i):
    """Retrieve the value of the element at index i."""
    return array[i]

func is_sorted():
    """Check if the array is in monotonically increasing order."""
    for i in range(size - 1):
        if array[i] > array[i + 1]:
            return false
    return true

func swap(i, j):
    """Swap the elements at indices i and j."""
    var temp = array[i]
    array[i] = array[j]
    array[j] = temp

func sort(i, j):
    """Sort the subarray starting at i and up to but not including j."""
    # Grr to the developer who made the upper bound inclusive
    var front = array.slice(0, i - 1) if i != 0 else []
    var sorted = array.slice(i, j - 1)
    sorted.sort()
    var back = array.slice(j, size - 1) if j != size else []
    array = front + sorted + back
