extends ComparisonSort
class_name BubbleSort

func _init(array).(array):
	pass

func next(action):
	if action == "swap":
		array.swap(index, index + 1)
	index += 1
	if index == array.size - 1:
		index = 0

func emphasized(i):
	return i == index or i == index + 1
