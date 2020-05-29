extends ComparisonSort
class_name BubbleSort

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
