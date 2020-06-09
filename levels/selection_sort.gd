extends ComparisonSort
class_name SelectionSort

const TITLE = "SELECTION SORT"
const ABOUT = """Selection sort incrementally builds a sorted array by
repeatedly looking for the smallest element and swapping it onto the
end of the sorted portion of the array, which initially starts with size
zero but grows after each round. It is faster than an unoptimized bubble
sort but slower than insertion sort."""
var base = 0
var index = base + 1

func _init(array).(array):
    pass

func check(action):
    if array.get(base) > array.get(index):
        return action == "swap"
    else:
        return action == "no_swap"

func next():
    if array.get(base) > array.get(index):
        array.swap(base, index)
    index += 1
    if index == array.size:
        base += 1
        index = base + 1
    if base == array.size - 1:
        emit_signal("done")

func emphasized(i):
    return i == index or i == base
