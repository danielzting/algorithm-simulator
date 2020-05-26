"""
A plain old one-dimensional random access array.
"""

extends Reference
class_name ArrayModel

var array = []
var size

func _init(size):
	for i in range(1, size + 1):
		array.append(i)
	array.shuffle()
	self.size = size

func get(i):
	return array[i]

func swap(i, j):
	var temp = array[i]
	array[i] = array[j]
	array[j] = temp
