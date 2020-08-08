class_name ArrayModel
extends Reference

# For all parameterized signals, i <= j
signal removed(i)
signal swapped(i, j)
signal sorted(i, j)

var _array = []
var size = 0 setget , get_size
var biggest = null

func _init(size=16):
    """Randomize the array."""
    for i in range(1, size + 1):
        _array.append(i)
    _array.shuffle()
    biggest = _array.max()

func at(i):
    """Retrieve the value of the element at index i."""
    return _array[i]

func frac(i):
    """Get the quotient of the element at index i and the biggest."""
    return float(_array[i]) / biggest

func is_sorted():
    """Check if the array is in monotonically increasing order."""
    for i in range(get_size() - 1):
        if _array[i] > _array[i + 1]:
            return false
    return true

func swap(i, j):
    """Swap the elements at indices i and j."""
    var temp = _array[i]
    _array[i] = _array[j]
    _array[j] = temp
    emit_signal("swapped", min(i, j), max(i, j))

func sort(i, j):
    """Sort the subarray starting at i and up to but not including j."""
    # Grr to the developer who made the upper bound inclusive
    var front = _array.slice(0, i - 1) if i != 0 else []
    var sorted = _array.slice(i, j - 1)
    sorted.sort()
    var back = _array.slice(j, size - 1) if j != size else []
    _array = front + sorted + back
    emit_signal("sorted", i, j)

func get_size():
    return _array.size()
