extends ComparisonSort
class_name InsertionSort

const TITLE = "INSERTION SORT"
const ABOUT = """Insertion sort goes through the array and inserts each
element into its correct position. It is most similar to how most people
would sort a deck of cards. It is also slow on large arrays but it is
one of the faster quadratic algorithms. It is often used to sort smaller
subarrays in hybrid sorting algorithms."""
var end = 1
var index = end

func _init(array).(array):
    pass

func check(action):
    if array.get(index - 1) > array.get(index):
        return action == "swap"
    else:
        return action == "no_swap"

func next():
    if array.get(index - 1) > array.get(index):
        array.swap(index - 1, index)
        index -= 1
        if index == 0:
            _grow()
    else:
        _grow()

func _grow():
    end += 1
    if end == array.size:
        emit_signal("done")
    index = end

func emphasized(i):
    return i == index or i == index - 1
