extends ComparisonSort
class_name BubbleSort

const TITLE = "BUBBLE SORT"
const ABOUT = """Bubble sort iterates through the array and looks at
each pair of elements, swapping them if they are out of order. When it
has gone through the entire array without swapping a single pair, it has
finished. Though simple to understand, bubble sort is hopelessly
inefficient on all but the smallest of arrays."""
var index = 0
var swapped = false

func _init(array).(array):
    pass

func check(action):
    if array.get(index) > array.get(index + 1):
        return action == "swap"
    else:
        return action == "no_swap"

func next():
    if array.get(index) > array.get(index + 1):
        array.swap(index, index + 1)
        swapped = true
    index += 1
    if index == array.size - 1:
        if not swapped:
            emit_signal("done")
        index = 0
        swapped = false

func emphasized(i):
    return i == index or i == index + 1
