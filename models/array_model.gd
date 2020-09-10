class_name ArrayModel

# For all parameterized signals, i <= j
signal removed(i)
signal swapped(i, j)
signal sorted(i, j)

const DEFAULT_SIZE = 16
enum DATA_TYPES {
    RANDOM_UNIQUE,
    TRUE_RANDOM,
    REVERSED,
    FEW_UNIQUE,
    ALL_THE_SAME,
    NEARLY_SORTED,
    ALREADY_SORTED,
}

var _array = []
var size = 0 setget , get_size
var biggest = null

func _init(size=DEFAULT_SIZE, data_type=DATA_TYPES.RANDOM_UNIQUE):
    """Randomize the array."""
    match data_type:
        DATA_TYPES.RANDOM_UNIQUE:
            for i in range(1, size + 1):
                _array.append(i)
            _array.shuffle()
        DATA_TYPES.TRUE_RANDOM:
            for i in range(size):
                _array.append(randi() % size + 1)
        DATA_TYPES.REVERSED:
            for i in range(size, 0, -1):
                _array.append(i)
        DATA_TYPES.FEW_UNIQUE:
            var values = []
            for i in range(sqrt(size)):
                values.append(randi() % size + 1)
            for i in range(size):
                _array.append(values[randi() % values.size()])
        DATA_TYPES.ALL_THE_SAME:
            for i in range(size):
                _array.append(1)
        DATA_TYPES.NEARLY_SORTED:
            # We interpret nearly sorted as every element being K or
            # less places away from its sorted position, where K is a
            # small number relative to the size of the array.
            for i in range(1, size + 1):
                _array.append(i)
            _array.shuffle()
            _nearly_sort(0, size - 1, ceil(sqrt(size)))
        DATA_TYPES.ALREADY_SORTED:
            for i in range(1, size + 1):
                _array.append(i)
    biggest = _array.max() if data_type != DATA_TYPES.ALL_THE_SAME else 0

func at(i):
    """Retrieve the value of the element at index i."""
    return _array[i]

func frac(i):
    """Get the quotient of the element at index i and the biggest."""
    return float(_array[i]) / biggest if biggest != 0 else 0.5

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

func is_in_place(i):
    """Check if the element at index i is in its correct place."""
    var less = 0
    var equal = 0
    for element in _array:
        if element < _array[i]:
            less += 1
        elif element == _array[i]:
            equal += 1
    return less <= i and i < less + equal

func get_size():
    return _array.size()

func _nearly_sort(start, end, k):
    # If false, then no element in this subarray is more than K places
    # away from its sorted position, and we can exit
    if end - start > k:
        var pointer = start
        for i in range(start, end):
            if _array[i] < _array[end]:
                swap(i, pointer)
                pointer += 1
        swap(pointer, end)
        _nearly_sort(start, pointer - 1, k)
        _nearly_sort(pointer + 1, end, k)
